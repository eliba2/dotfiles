--- @since 25.5.28
--- worktrees.yazi — pick a git worktree in a full-screen fzf overlay and remove it.
---
--- Invoked via `plugin worktrees` from keymap.toml.
--- The picker replaces Yazi's UI (via ui.hide) with fzf:
---   Enter  → remove (safe; fails if the worktree is dirty)
---   Ctrl-F → force remove (discards uncommitted changes)
---   Esc    → cancel
--- The highlighted worktree's `git status` + recent log show in the preview pane.
--- Requires `fzf` on PATH.

-- Read the directory Yazi is currently browsing. Anything touching `cx`
-- must run inside ya.sync (plugins run in an async context otherwise).
local get_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

local function notify(content, level)
	ya.notify {
		title = "Worktrees",
		content = content,
		level = level or "info", -- "info" | "warn" | "error"
		timeout = 4,
	}
end

local function trim(s)
	return (s:gsub("%s+$", ""))
end

-- Run `git -C <cwd> <args...>` to completion, capturing stdout/stderr.
local function git(cwd, args)
	local cmd = Command("git"):arg("-C"):arg(cwd)
	for _, a in ipairs(args) do
		cmd = cmd:arg(a)
	end
	return cmd:stdout(Command.PIPED):stderr(Command.PIPED):output()
end

-- Parse `git worktree list --porcelain`. The FIRST record is always the
-- main worktree, so trees[1] is the one we must never offer for removal.
local function parse_worktrees(stdout)
	local trees, cur = {}, nil
	for line in stdout:gmatch("[^\r\n]+") do
		local path = line:match("^worktree (.+)")
		if path then
			if cur then
				trees[#trees + 1] = cur
			end
			cur = { path = path }
		elseif cur then
			local branch = line:match("^branch (.+)")
			local head = line:match("^HEAD (.+)")
			if branch then
				cur.branch = branch
			elseif head then
				cur.head = head
			elseif line == "bare" then
				cur.bare = true
			elseif line == "detached" then
				cur.detached = true
			end
		end
	end
	if cur then
		trees[#trees + 1] = cur
	end
	return trees
end

local function label_for(t)
	if t.bare then
		return "(bare)"
	elseif t.branch then
		return (t.branch:gsub("^refs/heads/", ""))
	elseif t.detached then
		return "(detached " .. (t.head and t.head:sub(1, 7) or "?") .. ")"
	end
	return "(no branch)"
end

-- Show the removable worktrees in a full-screen fzf overlay.
-- `lines` are TAB-separated "<path>\t<display>" rows (fzf shows fields 2.. only,
-- while {1} in the preview/output keeps the real path).
-- Returns (path, force) on selection, or nil on cancel/error.
local function fzf_pick(lines, cwd)
	local preview = table.concat({
		"git -C {1} -c color.ui=always status -sb 2>/dev/null",
		"echo",
		"git -C {1} -c color.ui=always log --graph --oneline -20 2>/dev/null",
	}, "; ")

	local args = {
		"--ansi",
		"--no-multi",
		"--layout=reverse",
		"--cycle",
		"--multi",
		"--marker",
		"✓ ",
		"--bind",
		"ctrl-a:toggle-all",
		"--delimiter",
		"\t",
		"--with-nth",
		"2..",
		"--prompt",
		"Worktree ❯ ",
		"--header",
		"Tab: mark    Enter: remove marked    Ctrl-F: force    Ctrl-A: all    Esc: cancel",
		"--expect",
		"enter,ctrl-f",
		"--preview",
		preview,
		"--preview-window",
		"right,55%,border-left,wrap",
	}

	-- Suspend Yazi's TUI so fzf can take over the terminal. The permit restores
	-- the UI when dropped; ui.hide() must not be called again before then.
	local permit = ui.hide()

	local child, err = Command("fzf")
		:arg(args)
		:stdin(Command.PIPED)
		:stdout(Command.PIPED)
		:stderr(Command.INHERIT)
		:spawn()

	if not child then
		permit:drop()
		notify("Failed to launch fzf: " .. tostring(err), "error")
		return nil
	end

	child:write_all(table.concat(lines, "\n"))
	child:flush()
	local output = child:wait_with_output()
	permit:drop()

	-- fzf exits non-zero on Esc (130) or no match (1).
	if not (output and output.status and output.status.success) then
		return nil
	end

	-- With --expect + --multi: line 1 = the key pressed, lines 2.. = the marked
	-- rows (or the highlighted row if nothing was marked).
	local out_lines = {}
	for l in output.stdout:gmatch("[^\n]+") do
		out_lines[#out_lines + 1] = l
	end
	local key = out_lines[1]
	local paths = {}
	for i = 2, #out_lines do
		local p = out_lines[i]:match("^([^\t]+)")
		if p then
			paths[#paths + 1] = p
		end
	end
	if #paths == 0 then
		return nil
	end

	return paths, key == "ctrl-f"
end

local function entry()
	local cwd = get_cwd()

	-- Verify we're in a repo (and learn the current worktree root in one shot).
	local top = git(cwd, { "rev-parse", "--show-toplevel" })
	if not (top and top.status and top.status.success) then
		notify("Not inside a Git repository", "error")
		return
	end
	local current_root = trim(top.stdout)

	local out = git(cwd, { "worktree", "list", "--porcelain" })
	if not (out and out.status and out.status.success) then
		notify("Failed to list worktrees: " .. (out and trim(out.stderr) or "git error"), "error")
		return
	end

	local trees = parse_worktrees(out.stdout)
	if #trees == 0 then
		notify("No worktrees found", "info")
		return
	end
	local main_path = trees[1].path

	-- Offer every worktree except the main one and any bare entry.
	local lines = {}
	for _, t in ipairs(trees) do
		if t.path ~= main_path and not t.bare then
			local mark = (t.path == current_root) and "  📍 current" or ""
			lines[#lines + 1] = string.format("%s\t%s%s   —   %s", t.path, label_for(t), mark, t.path)
		end
	end
	if #lines == 0 then
		notify("No removable worktrees (only the main worktree exists)", "info")
		return
	end

	local paths, force = fzf_pick(lines, cwd)
	if not paths then
		return -- cancelled / nothing selected
	end

	-- Remove each marked worktree, tracking results for one summary toast.
	local removed, failed, removed_current = {}, {}, false
	for _, path in ipairs(paths) do
		local rm = { "worktree", "remove" }
		if force then
			rm[#rm + 1] = "--force"
		end
		rm[#rm + 1] = path

		local res = git(cwd, rm)
		if res and res.status and res.status.success then
			removed[#removed + 1] = path
			if path == current_root then
				removed_current = true
			end
		else
			failed[#failed + 1] = path
		end
	end

	-- Reload the browsed directory once. If we deleted the worktree we were
	-- standing in, jump to the main worktree instead.
	if #removed > 0 then
		ya.emit("cd", { removed_current and main_path or cwd })
	end

	local parts = {}
	if #removed > 0 then
		parts[#parts + 1] = string.format("Removed %d worktree(s)", #removed)
	end
	if #failed > 0 then
		parts[#parts + 1] = string.format("%d failed (dirty? use Ctrl-F to force)", #failed)
	end
	notify(table.concat(parts, "; "), #failed > 0 and "warn" or "info")
end

return { entry = entry }
