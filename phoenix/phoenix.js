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

const activeOrCycle = (appName, notInstalled=false) => {
  const allAppInstancesNonFiltered = App.all().filter((s) => s.name() === appName);
  // searching for only non-hidden apps
  const allAppInstances = allAppInstancesNonFiltered.filter((appInstance) => {
    // Get all windows for the current app instance
    const windows = appInstance.windows();

    // Check if any window is not minimized
    return windows.some((window) => !window.isMinimized());
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
    const windowsNum = app.windows().length;

    if (app.isActive()) {
      // check for additional windows
      if (windowsNum > 1) {
        const cycleWindows = app
          .windows()
          .filter((window) => !window.isMinimized());
        const focusedIndex = cycleWindows.findIndex((window) => window.isMain());
        const nextIndex =
          focusedIndex === -1
            ? cycleWindows.length - 1
            : (focusedIndex - 1 + cycleWindows.length) % cycleWindows.length;
        console.log("***************************** focusedIndex", focusedIndex);
        console.log("***************************** nextIndex", nextIndex);
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
              allAppInstances[appCycleNum].windows()[0]
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
            allAppInstances[appCycleNum].windows()[0]
          );
        }
        else {
          focusWindow(app, app.windows()[appCycleNum]);
        }
      } else {
        focusWindow(app, app.windows()[0]);
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
  activeOrCycle("kitty");
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
// Cmd-; focuses it if it's already open, otherwise launches a fresh one.
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

// Cmd-; : focus the floating window if that exact kitty instance is alive
// (found via ITS OWN socket), otherwise launch it. We identify it by the
// socket, NOT the window title, because terminal yazi sessions share the same
// "Yazi: <dir>" title and would otherwise be focused by mistake.
//
// Launch is via `open` (LaunchServices) rather than a direct fork/exec so kitty
// becomes its OWN macOS "responsible process". Otherwise every protected-folder
// access by yazi (~/Downloads, etc.) would prompt for *Phoenix*; via `open` it's
// attributed to kitty, which already has those permissions.
const YAZI_FOCUS_OR_LAUNCH =
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
  // Run yazi via a no-rc zsh (`-f`, skips oh-my-zsh so it's fast & flash-free)
  // that sources only what tools launched from yazi need on PATH: nvm (node,
  // for coc.nvim), Homebrew, and ~/.local/bin (vd, etc.). `open` gives launchd's
  // minimal env, which otherwise breaks those tools.
  "\" --args /bin/zsh -fc 'export NVM_DIR=\"$HOME/.nvm\"; . \"$NVM_DIR/nvm.sh\" >/dev/null 2>&1; eval \"$(/opt/homebrew/bin/brew shellenv)\"; export PATH=\"$HOME/.local/bin:$PATH\"; exec " +
  YAZI_BIN +
  " " +
  YAZI_START_DIR +
  "'";

Key.on("y", ["cmd"], () => {
  Task.run("/bin/sh", ["-c", YAZI_FOCUS_OR_LAUNCH], (task) => {
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
});
