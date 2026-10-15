const LEFT = 0;
const RIGHT = 1;

// NOTE - to debug use "log stream --process Phoenix"

const focusWindow = (app, window) => {
  if (!window) {
    return false;
  }
  /*
  if (app) {
    if (app.isHidden()) {
      app.show();
    }
    if (!app.isActive()) {
      app.activate();
      app.focus();
    }
  }
  */
  const focused = window.focus();
  if (!focused && app && !app.isActive()) {
    app.activate();
    app.focus();
    return window.focus();
  }
  return focused;
};

const activeOrCycle = (appName, notInstalled=false, windowFilter=null) => {
  // Optionally drop some windows (e.g. the floating-yazi window) from
  // consideration, so focus/cycle only sees the app's "real" windows.
  const wins = (appInstance) => {
    const ws = appInstance.windows();
    return windowFilter ? ws.filter(windowFilter) : ws;
  };

  const allAppInstancesNonFiltered = App.all().filter((s) => s.name() === appName);
  // non-hidden apps that still have a (filtered) non-minimized window
  const allAppInstances = allAppInstancesNonFiltered.filter((appInstance) => {
    return wins(appInstance).some((window) => !window.isMinimized());
  });

  let app;
  if (allAppInstances.length === 1) {
    app = allAppInstances[0];
  } else {
    // find if there's any active app instance
    app = allAppInstances.find((s) => s.isActive());
    if (!app) {
      // no active app
      app = allAppInstances[0];
    }
  }

  if (app !== undefined) {
    const windowsNum = wins(app).length;

    if (app.isActive()) {
      // check for additional windows
      if (windowsNum > 1) {
        const cycleWindows = wins(app).filter((window) => !window.isMinimized());
        const focusedIndex = cycleWindows.findIndex((window) => window.isMain());
        const nextIndex =
          focusedIndex === -1
            ? cycleWindows.length - 1
            : (focusedIndex - 1 + cycleWindows.length) % cycleWindows.length;
        focusWindow(app, cycleWindows[nextIndex]);
        return;
      } else {
        try {
          // check for multiple apps (in such case each one has one window)
          if (allAppInstances.length > 1) {
            // we can't do the window cycle trick so I'll use storage
            const key = `${appName}_num`;
            let appCycleNum = Storage.get(key);
            if (
              appCycleNum === undefined ||
              appCycleNum >= allAppInstances.length
            ) {
              appCycleNum = 0;
            } else {
              // only cycle if its visible, otherwise bring the last window back
              if (allAppInstances[appCycleNum].isActive()) {
                appCycleNum++;
              }
            }
            appCycleNum = appCycleNum % allAppInstances.length;
            Storage.set(key, appCycleNum);
            focusWindow(
              allAppInstances[appCycleNum],
              wins(allAppInstances[appCycleNum])[0]
            );
          }
        } catch (e) {
          console.log("ERR", e.message);
        }
      }
    } else {
      // app is inactive, activate the latest window
      if (allAppInstances.length > 1) {
        // we can't do the window cycle trick so I'll use storage
        const key = `${appName}_num`;
        let appCycleNum = Storage.get(key);
        if (
          appCycleNum === undefined ||
          appCycleNum >= allAppInstances.length
        ) {
          appCycleNum = 0;
        }
        Storage.set(key, appCycleNum);
        if (notInstalled) {
          focusWindow(
            allAppInstances[appCycleNum],
            wins(allAppInstances[appCycleNum])[0]
          );
        }
        else {
          focusWindow(app, wins(app)[appCycleNum]);
        }
      } else {
        focusWindow(app, wins(app)[0]);
      }
    }
  }
};

function frameRatio(a, b) {
  const widthRatio = b.width / a.width;
  const heightRatio = b.height / a.height;

  return ({ width, height, x, y }) => {
    width = Math.round(width * widthRatio);
    height = Math.round(height * heightRatio);
    x = Math.round(b.x + (x - a.x) * widthRatio);
    y = Math.round(b.y + (y - a.y) * heightRatio);

    return { width, height, x, y };
  };
}

/* stopped working */
const moveScreen = (whereTo) => {

  const win = Window.focused();
  if (!win) {
    return;
  }

  const oldScreen = Screen.main();

  const allScreens = Screen.all();
  if (allScreens.length < 2) {
    return;
  }

  // find the current screen index
  let screenIndex = allScreens.findIndex((s) => s.identifier() === oldScreen.identifier());
  if (screenIndex === -1) {
    return;
  }

  if (whereTo === LEFT) {
    screenIndex -= 1;
    if (screenIndex < 0) {
      screenIndex = allScreens.length - 1;
    }
  } else {
    screenIndex += 1;
    if (screenIndex >= allScreens.length) {
      screenIndex = 0;
    }
  }

  const newScreen = allScreens[screenIndex];



  if (oldScreen.isEqual(newScreen)) {
    console.log("===>> Old screen is the same as new screen");
    return;
  }

  const ratio = frameRatio(
    oldScreen.flippedVisibleFrame(),
    newScreen.flippedVisibleFrame()
  );
  win.setFrame(ratio(win.frame()));

  // win.setTopLeft({ x: newScreen.visibleFrame().topLeft, y: 0 });

};

Key.on("j", ["ctrl", "shift"], async function (_, repeat) {
  if (repeat) {
    return;
  }
  activeOrCycle("Neovim", true);
});

Key.on("k", ["ctrl", "shift"], async function (_, repeat) {
  if (repeat) {
    return;
  }
  // Exclude the floating yazi / ktcal windows so Ctrl-Shift-K jumps to a real
  // terminal even while one of them (a separate kitty process) is open.
  activeOrCycle("kitty", false, (w) => !isFloatWindow(w));
});

Key.on("l", ["ctrl", "shift"], async function (_, repeat) {
  if (repeat) {
    return;
  }
  activeOrCycle("Google Chrome");
});
/*
Key.on("l", ["ctrl", "shift"], async function (_, repeat) {
  if (repeat) {
    return;
  }
  activeOrCycle("Microsoft Edge");
});
*/
Key.on("left", ["cmd"], () => {
  moveScreen(LEFT);
});

Key.on("right", ["cmd"], () => {
  moveScreen(RIGHT);
});

Key.on("up", ["cmd"], () => {
  const win = Window.focused();
  if (!win) {
    return;
  }
  win.maximise();
});

// Floating windows: dedicated kitty instances, each with its own config directory
// (own kitty.conf + dock icon) so they never touch the main kitty.conf.
//   Cmd-Y : yazi   (kitty/yazi-float)
//   Cmd-; : ktcal  (kitty/ktcal-float)
// The hotkey focuses the window if it's already open, otherwise launches a fresh one,
// sized 80% x 80% and centered on the active screen.
const KITTY_APP = "/Applications/kitty.app";
const KITTEN_BIN = "/Applications/kitty.app/Contents/MacOS/kitten";
// macOS title bar height. kitty's --position and initial_window_height apply to
// the content area (below the title bar), while Phoenix frames include it.
const TITLEBAR_H = 28;

const FLOATS = {
  // yazi opens in ~ and drives the window title ("Yazi: <dir>"), which updates
  // live as you navigate.
  yazi: {
    // Remote-control socket from kitty.conf's listen_on (kitty appends "-<pid>").
    socket: "/tmp/kitty-yazi-float",
    confDir: "/Users/elibabila/.dotfiles/kitty/yazi-float",
    // Separate yazi config home for the floating window: symlinks all the shared
    // config (openers/keymaps/plugins) but adds the rose-pine-dawn flavor, so ONLY
    // the floating yazi is themed — the terminal yazi keeps its default theme.
    env: { YAZI_CONFIG_HOME: "/Users/elibabila/.config/yazi-float" },
    title: null,
    command: "/opt/homebrew/bin/yazi /Users/elibabila",
    isWindow: (title) => title.indexOf("Yazi:") === 0,
  },
  // ktcal doesn't set a title, so kitty's --title fixes it. Quitting ktcal (q)
  // ends the window's only program, which closes the window and this kitty.
  ktcal: {
    socket: "/tmp/kitty-ktcal-float",
    confDir: "/Users/elibabila/.dotfiles/kitty/ktcal-float",
    env: {},
    title: "Calendar",
    command: "/Users/elibabila/Library/pnpm/bin/ktcal",
    isWindow: (title) => title === "Calendar",
  },
};

// True for any floating window, so Ctrl-Shift-K's kitty cycling can skip them.
const isFloatWindow = (w) => {
  const title = w.title() || "";
  return Object.keys(FLOATS).some((k) => FLOATS[k].isWindow(title));
};

// Focus the floating window if that exact kitty instance is alive (found via
// ITS OWN socket), otherwise launch it. We identify it by the socket, NOT the
// window title, because e.g. terminal yazi sessions share the same "Yazi: <dir>"
// title and would otherwise be focused by mistake.
//
// Launch is via `open` (LaunchServices) rather than a direct fork/exec so kitty
// becomes its OWN macOS "responsible process". Otherwise every protected-folder
// access (~/Downloads, etc.) would prompt for *Phoenix*; via `open` it's
// attributed to kitty, which already has those permissions.
//
// fr (floatFrame()) places the new window: --position opens it already centered
// and the -o overrides size it at 80% of the screen, so Phoenix's follow-up
// setFrame (sizeAndCenterFloat) is at most a small correction, not a visible jump.
const floatFocusOrLaunch = (f, fr) =>
  'sock="$(ls -t ' +
  f.socket +
  '-* 2>/dev/null | head -1)"; ' +
  'if [ -n "$sock" ] && "' +
  KITTEN_BIN +
  '" @ --to "unix:$sock" focus-window >/dev/null 2>&1; then exit 0; fi; ' +
  'exec /usr/bin/open --env KITTY_CONFIG_DIRECTORY="' +
  f.confDir +
  '"' +
  Object.keys(f.env)
    .map((k) => " --env " + k + '="' + f.env[k] + '"')
    .join("") +
  ' -n -a "' +
  KITTY_APP +
  '" --args' +
  (f.title ? ' --title "' + f.title + '"' : "") +
  " --position=" +
  fr.x +
  "x" +
  (fr.y + TITLEBAR_H) +
  " -o initial_window_width=" +
  fr.width +
  " -o initial_window_height=" +
  (fr.height - TITLEBAR_H) +
  // Run the program via a no-rc zsh (`-f`, skips oh-my-zsh so it's fast & flash-free)
  // that sets up only what's needed on PATH: node (for ktcal and coc.nvim),
  // Homebrew, and ~/.local/bin (vd, etc.). `open` gives launchd's minimal env,
  // which otherwise breaks those tools.
  // node: instead of sourcing nvm.sh (~0.5s), resolve nvm's default alias
  // (e.g. "22") to the newest matching installed version and put its bin on PATH;
  // falls back to the newest installed node for aliases like "node"/"lts/*".
  " /bin/zsh -fc 'a=$(<$HOME/.nvm/alias/default); a=${a#v}; n=($HOME/.nvm/versions/node/v$a(|.*)(N/n)); [ -z \"$n\" ] && n=($HOME/.nvm/versions/node/v*(N/n)); export PATH=\"$n[-1]/bin:$PATH\"; eval \"$(/opt/homebrew/bin/brew shellenv)\"; export PATH=\"$HOME/.local/bin:$PATH\"; exec " +
  f.command +
  "'";

// The floating window's frame: 80% x 80% of the active screen, centered.
const floatFrame = () => {
  const sf = Screen.main().flippedVisibleFrame();
  const w = Math.round(sf.width * 0.8);
  const h = Math.round(sf.height * 0.8);
  return {
    x: sf.x + Math.round((sf.width - w) / 2),
    y: sf.y + Math.round((sf.height - h) / 2),
    width: w,
    height: h,
  };
};

// Enforce the floating window's frame. `open` launches asynchronously, so poll
// briefly until the window is focused, then set its frame. (kitty's --position
// and -o give the right initial placement to minimize the visible jump; Phoenix
// does the authoritative size + centering.)
const sizeAndCenterFloat = (f, attempt) => {
  const win = Window.focused();
  if (win && win.app() && win.app().name() === "kitty" && f.isWindow(win.title() || "")) {
    win.setFrame(floatFrame());
    return;
  }
  if (attempt < 20) {
    Timer.after(0.15, () => sizeAndCenterFloat(f, attempt + 1));
  }
};

const toggleFloat = (name) => {
  const f = FLOATS[name];
  Task.run("/bin/sh", ["-c", floatFocusOrLaunch(f, floatFrame())], (task) => {
    if (task.status !== 0) {
      console.log(
        name + " float focus/launch failed (status " + task.status + "): " + task.error + " " + task.output
      );
    }
  });
  sizeAndCenterFloat(f, 0);
};

Key.on("y", ["cmd"], () => toggleFloat("yazi"));
Key.on(";", ["cmd"], () => toggleFloat("ktcal"));
