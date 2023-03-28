const LEFT = 0;
const RIGHT = 1;

const activeOrCycle = (appName) => {
  const allAppInstances = App.all().filter((s) => s.name() === appName);
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
    //console.log(app.name());

    if (app.isActive()) {
      // check for additional windows
      if (windowsNum > 1) {
        // there are several windows, so cycle
        // active seems to always be #0, and when switching the new active switches with #0.
        // so a quick cycle would be to use the last one.
        app.windows()[windowsNum - 1].focus();
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
            allAppInstances[appCycleNum].windows()[0].focus();
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
        allAppInstances[appCycleNum].windows()[0].focus();
      } else {
        app.windows()[0].focus();
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

const moveScreen = (whereTo) => {
  const win = Window.focused();
  if (!win) {
    return;
  }

  const oldScreen = win.screen();
  const newScreen = whereTo === LEFT ? oldScreen.previous() : oldScreen.next();

  if (oldScreen.isEqual(newScreen)) {
    return;
  }

  const ratio = frameRatio(
    oldScreen.flippedVisibleFrame(),
    newScreen.flippedVisibleFrame()
  );
  win.setFrame(ratio(win.frame()));
};

Key.on("j", ["ctrl", "shift"], async function (_, repeat) {
  if (repeat) {
    return;
  }
  activeOrCycle("Neovim");
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
