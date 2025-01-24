import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'debug_handler.dart';
import 'dart:convert';

class BluetoothFunctions {
  static Future<void> bluetoothActionIdle({DebugHandler? debugController}) async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    DebugHandler debug = (debugController == null) ? DebugHandler() : debugController;

    if (await FlutterBluePlus.isSupported == false) {
      debug.append(text: "Bluetooth not supported by this device");
      return;
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn(); // Request the user to turn on Bluetooth
    }

    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    debug.append(text: 'Started Bluetooth Idle Action!');

    // Start scanning for devices
    debug.append(text: 'Scanning for devices...');
    FlutterBluePlus.startScan(withNames: ["RS-00000466"], timeout: Duration(seconds: 30));

    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult result in results) {
        debug.append(text: 'Found device: ${result.device.platformName}');
        await connectToDevice(result.device, debug);
        FlutterBluePlus.stopScan();
        break;
      }
    });
  }

  static Future<void> connectToDevice(BluetoothDevice device, DebugHandler debug) async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose);

    try {
      debug.append(text: 'Connecting to device: ${device.platformName}');
      await device.connect(autoConnect: false);

      device.connectionState.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.connected) {
          debug.append(text: 'Connected to the device!');
          // Proceed with discovering services
        } else if (state == BluetoothConnectionState.disconnected) {
          debug.append(text: 'Disconnected from the device!');
          // Handle disconnection
        }
      });

      List<BluetoothService> services = await device.discoverServices();

      /*for (BluetoothService service in services) {
        debug.append(text: 'Service UUID: ${service.uuid}');
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          debug.append(
            text: 'Characteristic UUID: ${characteristic.uuid}\n Properties: Read=${characteristic.properties.read}, Write=${characteristic.properties.write}, WriteWithoutResponse=${characteristic.properties.writeWithoutResponse}, Notify=${characteristic.properties.notify}, Indicate=${characteristic.properties.indicate}',
          );
        }
      }*/
      // Find the required service and characteristic
      BluetoothService targetService = services.firstWhere(
            (s) => s.uuid.toString() == '49535343-fe7d-4ae5-8fa9-9fafd205e455',
        orElse: () => throw Exception('Service not found'),
      );
      BluetoothCharacteristic targetCharacteristic = targetService.characteristics.firstWhere(
            (c) => c.uuid.toString() == '49535343-1e4d-4bd9-ba61-23c647249616',
        orElse: () => throw Exception('Characteristic not found'),
      );
      /*BluetoothCharacteristic writableCharacteristic = targetService.characteristics.firstWhere(
            (c) => c.properties.write == true || c.properties.writeWithoutResponse == true,
        orElse: () => throw Exception('No writable characteristic found'),
      );

      if (!writableCharacteristic.properties.write) {
        debug.append(text: 'Write property is not supported by this characteristic');
      }*/

      // Enable notifications
      await targetCharacteristic.setNotifyValue(true);
      debug.append(text: 'Notifications enabled for characteristic');

      // Listen for notifications
      bool atcReceived = false;
      targetCharacteristic.onValueReceived.listen((value) {
        handleNotification(value, targetCharacteristic, debug, atcReceived);
        if (!atcReceived && utf8.decode(value).contains('"a":"atc"')) {
          atcReceived = true; // Ensure only the first "atc" is handled
        }
      });

    } catch (e) {
      debug.append(text: 'Error: $e');
    }
  }

  static Future<void> sendLoginMessage(BluetoothCharacteristic characteristic, DebugHandler debug) async {
    try {
      debug.append(text: 'Sending login message...');
      Map<String, dynamic> loginMessage = {
        "a": "login-done", // Action
        "uid": "5995ac98fa9c3d23b87a11a4" // User ID
      };
      String jsonString = jsonEncode(loginMessage);
      List<int> byteData = utf8.encode(jsonString);
      await characteristic.write(byteData, withoutResponse: true);
      debug.append(text: 'Login message sent');
    } catch (e) {
      debug.append(text: 'Error sending login message: $e');
    }
  }

  static Future<void> handleNotification(List<int> value, BluetoothCharacteristic characteristic, DebugHandler debug, bool atcReceived) async {
    try {
      String message = utf8.decode(value);
      debug.append(text: 'Received: $message');
      if (message.contains('"a":"atc"')) {
        if (!atcReceived) {
          debug.append(text: 'Received: $message');
          debug.append(text: 'ATC received!');
        }
        sendLoginMessage(characteristic, debug);
      }

      if (message.contains('"a":"login-done"')) {
        debug.append(text: 'Received: $message');
        debug.append(text: 'Login complete!');
      }
    } catch (e) {
      debug.append(text: 'Error handling notification: $e');
    }
  }

  static Future<void> bluetoothActionListening({DebugHandler? debugController}) async {
    DebugHandler debug = (debugController == null) ? DebugHandler() : debugController;
    debug.append(text: 'Started Bluetooth Waiting Action!');
    // Insert your bluetooth listening actions here


    debug.append(text: 'Finished Bluetooth Waiting Action!');
  }
}
