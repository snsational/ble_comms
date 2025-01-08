import '../controllers/debug_controller.dart';

class BluetoothFunctions {
  static Future<void> bluetoothActionIdle({DebugController? debugController}) async {
    DebugController debug = (debugController == null) ? DebugController() : debugController;
    debug.append(text: 'Started Bluetooth Idle Action!');
    // Insert your bluetooth idle actions here


    debug.append(text: 'Finished Bluetooth Idle Action!');
  }

  static Future<void> bluetoothActionListening({DebugController? debugController}) async {
    DebugController debug = (debugController == null) ? DebugController() : debugController;
    debug.append(text: 'Started Bluetooth Waiting Action!');
    // Insert your bluetooth listening actions here


    debug.append(text: 'Finished Bluetooth Waiting Action!');
  }

  // Insert other methods here if needed

}