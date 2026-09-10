--- @sync entry

-- Maximum history size
local MAX_HISTORY = 50

local get_cwd = ya.sync(function(state)
  return tostring(cx.active.current.cwd)
end)

local function go_back(state)
  if state.index <= 1 then
    ya.notify { title = "Jump", content = "No more directories to go back to", timeout = .5 }
    return
  end
  state.index = state.index - 1
  local dir = state.history[state.index]
  state.lastToggled = dir
  ya.emit("cd", { dir })
  -- ya.notify { title = "Jump", content = "Went back to: " .. dir, timeout = .5 }
end

local function go_forward(state)
  if state.index >= #state.history then
    ya.notify { title = "Jump", content = "No more directories to go forward to", timeout = .5 }
    return
  end
  state.index = state.index + 1
  local dir = state.history[state.index]
  state.lastToggled = dir
  ya.emit("cd", { dir })
  -- ya.notify { title = "Jump", content = "Went forward to: " .. dir, timeout = .5 }
end

local function light_down(state)
  ya.emit("arrow", { 5 })
  -- ya.notify { title = "Jump", content = "Jumped 5 entries down", timeout = .5 }
end

local function light_up(state)
  ya.emit("arrow", { -5 })
  -- ya.notify { title = "Jump", content = "Jumped 5 entries up", timeout = .5 }
end


local function add_history(state, dir)
  -- If we are not at the end of the history, truncate it
  if state.index < #state.history then
    for i = #state.history, state.index + 1, -1 do
      table.remove(state.history, i)
    end
  end

  -- Avoid duplicates: don't add if the last entry is the same
  if #state.history > 0 and state.history[#state.history] == dir then
    return
  end

  -- Add new directory
  table.insert(state.history, dir)
  state.index = #state.history

  -- Trim history if it exceeds MAX_HISTORY
  if #state.history > MAX_HISTORY then
    table.remove(state.history, 1)
    state.index = state.index - 1
  end
end


return {

  setup = function (state, opts)
    state.history = state.history or {}
    state.index = 0  -- state.index or 0
    state.lastToggled = ""


    ps.sub("cd", function()
      local current_dir = get_cwd()
      if current_dir == state.lastToggled then
        state.lastToggled = ""
        return
      end
      add_history(state, current_dir)
      state.lastToggled = current_dir
    end)
  end,
  
  entry = function (state, job)
    local action = job.args[1] -- Action: back, forward, light_up, light_down

    if action == "back" then
      go_back(state)
    elseif action == "forward" then
      go_forward(state)
    elseif action == "light_down" then
      light_down(state)
    elseif action == "light_up" then
      light_up(state)
    else
      ya.notify { title = "Jump", content = "Unknown action: ", timeout = .5 }
      return
    end

  end,
}
