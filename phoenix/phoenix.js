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
  // Exclude the floating-yazi window ("Yazi: <dir>") so Ctrl-Shift-K jumps to a
  // real terminal even while the floating yazi (a separate kitty process) is open.
  activeOrCycle("kitty", false, (w) => (w.title() || "").indexOf("Yazi:") !== 0);
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

// Floating Yazi window (a dedicated kitty instance running yazi).
// Cmd-Y focuses it if it's already open, otherwise launches a fresh one.
// Uses a standalone kitty config so it never touches the main kitty.conf.
const KITTY_APP = "/Applications/kitty.app";
const KITTEN_BIN = "/Applications/kitty.app/Contents/MacOS/kitten";
const YAZI_BIN = "/opt/homebrew/bin/yazi";
// Dedicated kitty config DIRECTORY: holds kitty.conf, the custom dock icon,
// and a remote-control socket (listen_on unix:/tmp/kitty-yazi-float-<pid>).
// yazi opens in ~ and drives the window title ("Yazi: <dir>"), which updates
// live as you navigate.
const YAZI_KITTY_CONF_DIR = "/Users/elibabila/.dotfiles/kitty/yazi-float";
const YAZI_START_DIR = "/Users/elibabila";
// Separate yazi config home for the floating window: symlinks all the shared
// config (openers/keymaps/plugins) but adds the rose-pine-dawn flavor, so ONLY
// the floating yazi is themed — the terminal yazi keeps its default theme.
const YAZI_CONFIG_HOME_DIR = "/Users/elibabila/.config/yazi-float";

// Cmd-Y : focus the floating window if that exact kitty instance is alive
// (found via ITS OWN socket), otherwise launch it. We identify it by the
// socket, NOT the window title, because terminal yazi sessions share the same
// "Yazi: <dir>" title and would otherwise be focused by mistake.
//
// Launch is via `open` (LaunchServices) rather than a direct fork/exec so kitty
// becomes its OWN macOS "responsible process". Otherwise every protected-folder
// access by yazi (~/Downloads, etc.) would prompt for *Phoenix*; via `open` it's
// attributed to kitty, which already has those permissions.
//
// w/h (pixels) size the new window; passed as kitty -o overrides so it opens at
// 80% of the screen (computed in the handler below).
const yaziFocusOrLaunch = (w, h) =>
  'sock="$(ls -t /tmp/kitty-yazi-float-* 2>/dev/null | head -1)"; ' +
  'if [ -n "$sock" ] && "' +
  KITTEN_BIN +
  '" @ --to "unix:$sock" focus-window >/dev/null 2>&1; then exit 0; fi; ' +
  'exec /usr/bin/open --env KITTY_CONFIG_DIRECTORY="' +
  YAZI_KITTY_CONF_DIR +
  '" --env YAZI_CONFIG_HOME="' +
  YAZI_CONFIG_HOME_DIR +
  '" -n -a "' +
  KITTY_APP +
  '" --args -o initial_window_width=' +
  w +
  ' -o initial_window_height=' +
  h +
  // Run yazi via a no-rc zsh (`-f`, skips oh-my-zsh so it's fast & flash-free)
  // that sources only what tools launched from yazi need on PATH: nvm (node,
  // for coc.nvim), Homebrew, and ~/.local/bin (vd, etc.). `open` gives launchd's
  // minimal env, which otherwise breaks those tools.
  " /bin/zsh -fc 'export NVM_DIR=\"$HOME/.nvm\"; . \"$NVM_DIR/nvm.sh\" >/dev/null 2>&1; eval \"$(/opt/homebrew/bin/brew shellenv)\"; export PATH=\"$HOME/.local/bin:$PATH\"; exec " +
  YAZI_BIN +
  " " +
  YAZI_START_DIR +
  "'";

// Enforce the floating yazi window at 80% x 80%, centered on its screen. `open`
// launches asynchronously, so poll briefly until the yazi window is focused,
// then set its frame. (kitty's -o gives the right initial size to minimize the
// visible jump; Phoenix does the authoritative size + centering.)
const sizeAndCenterYazi = (attempt) => {
  const win = Window.focused();
  if (
    win &&
    win.app() &&
    win.app().name() === "kitty" &&
    (win.title() || "").indexOf("Yazi:") === 0
  ) {
    const sf = Screen.main().flippedVisibleFrame();
    const w = Math.round(sf.width * 0.8);
    const h = Math.round(sf.height * 0.8);
    win.setFrame({
      x: sf.x + Math.round((sf.width - w) / 2),
      y: sf.y + Math.round((sf.height - h) / 2),
      width: w,
      height: h,
    });
    return;
  }
  if ((attempt || 0) < 20) {
    Timer.after(0.15, () => sizeAndCenterYazi((attempt || 0) + 1));
  }
};

Key.on("y", ["cmd"], () => {
  // Size the floating window at 80% x 80% of the active screen's usable area.
  const sf = Screen.main().flippedVisibleFrame();
  const w = Math.round(sf.width * 0.8);
  const h = Math.round(sf.height * 0.8);
  Task.run("/bin/sh", ["-c", yaziFocusOrLaunch(w, h)], (task) => {
    if (task.status !== 0) {
      console.log(
        "yazi float focus/launch failed (status " +
          task.status +
          "): " +
          task.error +
          " " +
          task.output
      );
    }
  });
  sizeAndCenterYazi(0);
});
