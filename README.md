# BLE Demo

Bluetooth communications demonstration app.
In this repository you can find a blank project with pre-structured folders and files to test flutter BLE communications.

# Requirements

To compile this project, you'll need:

<li> Flutter (ver. 3.27.1 or higher)</li>

Development in Android Studio is recommended, but you can use other IDEs.
You can find the installation guide for Flutter [here](https://docs.flutter.dev/get-started/install);

After the installation of Flutter, you can run `flutter doctor -v`
in the root directory of your project, to check if there is any issue with your installation. Usually, any common issues can be fixed through the instructions given in the result. You can find other common issues in the installation [here](https://docs.flutter.dev/get-started/install/help);

# Project Overview

The project files are located in the `/lib` directory. In here, you can find the file tree below:

```
lib
│   main.dart
└───src
│   └───components
│       └─── buttons
│               actionbtn.dart
│               actionbtn_status.dart
│
└───────config
│       └─── constants
│               app_styles.dart
└───────utils
            bluetooth.dart
            debug_handler.dart

```

In the `components` directory we placed every custom widget that the app uses. In this case, we only created a button with an action and custom status for the button. When you press the button, it will cycle through the status and do different actions for each. If you feel the need to add more status or edit them, you can do so by:

- First, in the `actionbtn_status.dart` file, add any new status that you want below the other already created statuses:

```
enum ActionBtnStatus {
  idle,
  listening,

  // Insert other status here if needed
  ...
```

Your IDE might, then, identify the following issue:

```
The type 'ActionBtnStatus' is not exhaustively matched by the switch cases since it doesn't match 'ActionBtnStatus.<yournewstatus>'
```

To contemplate the case for your newly created status, you can add a new function in the file `/lib/src/utils/bluetooth.dart` and before the last `}`, you can create a new method, and follow this example:

```
  static Future<void> bluetoothActionExample({DebugHandler? debugController}) async {
    DebugHandler debug = (debugController == null) ? DebugHandler() : debugController;

    debug.append(text: 'Example Log message');
    // Write what your new status will do in here, when you click the button

  }
```

With the newly created action for this button, you can implement it on the switch located in the file `/lib/src/components/buttons/actionbtn.dart`. Find the comment where it says:

```
// Add more cases here if you created more ActionBtnStatus
```

and add your new action like this example:

```
case ActionBtnStatus.<yourNewActionName>:
                  return FloatingActionButton(
                    child: Icon(Icons.<iconOfYourChoice>),
                    onPressed: () async {
                      await BluetoothFunctions.<yourNewActionMethod>(
                          debugController: debugController).then((a){
                        status.value = cycle(value);
                      });
                    },
                  );
```

In this example, replace `<yourNewActionName>` with the name of the action that you created on the file `lib/src/components/button/actionbtn_status.dart`. Replace `<iconOfYourChoice>` with an icon that you want to be displayed on the button when this action is cycled (You can find a list of all the icons [here](https://api.flutter.dev/flutter/material/Icons-class.html)). Replace `<yourNewActionMethod>` with the method created in the file `/lib/src/components/buttons/actionbtn.dart`.

This is the structure we follow for our projects, but feel free to add/change it accoording to your needs.
