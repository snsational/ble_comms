import 'package:ble_comms/src/utils/debug_handler.dart';
import 'package:flutter/material.dart';
import 'actionbtn_status.dart';
import '../../utils/bluetooth.dart';

class BluetoothActionButton extends StatelessWidget {
  /// Creates a form button that validates the form contents. The user inserts
  /// the text in the [formKey]'s fields and, when pressing the button, a circular loading
  /// indicator replaces the [buttonTitle] while the actions of the [onPressed]
  /// function runs. It then displays the [buttonTitle] text again at the end of
  /// the function.
  BluetoothActionButton({
    super.key,
    required this.debugController,
  });

  final DebugHandler debugController;

  final ValueNotifier<ActionBtnStatus> status =
      ValueNotifier<ActionBtnStatus>(ActionBtnStatus.idle);

  /// Text Style of the Primary Button, for the default Input and Action Buttons
  final TextStyle primaryButtonText = const TextStyle(
      color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: ValueListenableBuilder(
            valueListenable: status,
            builder: (BuildContext context, ActionBtnStatus value, child) {
              switch (value) {
                case ActionBtnStatus.idle:
                  return FloatingActionButton(
                    child: Icon(Icons.bluetooth_outlined),
                    onPressed: () async {
                      await BluetoothFunctions.bluetoothActionIdle(
                          debugController: debugController).then((a) {
                        status.value = cycle(value);
                      });
                    },
                  );
                case ActionBtnStatus.listening:
                  return FloatingActionButton(
                    child: Icon(Icons.bluetooth_searching),
                    onPressed: () async {
                      await BluetoothFunctions.bluetoothActionListening(
                          debugController: debugController).then((a){
                        status.value = cycle(value);
                      });
                    },
                  );

                  // Add more cases here if you created more ActionBtnStatus

              }
            },
          ),
        ));
  }
}
