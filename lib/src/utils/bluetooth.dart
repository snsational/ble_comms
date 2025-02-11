import 'dart:io';
import 'package:ble_comms/src/utils/ble_message_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'debug_handler.dart';


class BluetoothFunctions {
  static Future<void> bluetoothActionIdle(
      {DebugHandler? debugController}) async {
    FlutterBluePlus.setLogLevel(LogLevel.verbose);
    DebugHandler debug =
        (debugController == null) ? DebugHandler() : debugController;

    if (await FlutterBluePlus.isSupported == false) {
      debug.append(text: "Bluetooth not supported by this device");
      return;
    }

    if (!kIsWeb && Platform.isAndroid) {
      await FlutterBluePlus.turnOn(); // Request the user to turn on Bluetooth
    }

    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;
    debug.append(text: 'Started Bluetooth Idle Action!');

    // Start scanning for devices
    debug.append(text: 'Scanning for devices...');
    FlutterBluePlus.startScan(
        withNames: ["RS-00000320"], timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) async {
      debug.append(text: 'Found device: ${results.first.device.platformName}');
      await connectToDevice(results.first.device, debug);
      FlutterBluePlus.stopScan();
      /*
      for (ScanResult result in results) {
        debug.append(text: 'Found device: ${result.device.platformName}');
        /*
        await connectToDevice(result.device, debug);
        FlutterBluePlus.stopScan();
        */

        break;
      }
      */
    });
  }

  static Future<void> connectToDevice(
      BluetoothDevice device, DebugHandler debug) async {
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

      String serviceUUID = '';
      String characteristicUUID = '';
      for (BluetoothService service in services) {
        debug.append(text: 'Service UUID: ${service.uuid}');
        serviceUUID = '${service.uuid}';
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          characteristicUUID = '${characteristic.uuid}';
          debug.append(
            text:
                'Characteristic UUID: ${characteristic.uuid}\n Properties: Read=${characteristic.properties.read}, Write=${characteristic.properties.write}, WriteWithoutResponse=${characteristic.properties.writeWithoutResponse}, Notify=${characteristic.properties.notify}, Indicate=${characteristic.properties.indicate}',
          );
        }
      }

      // Find the required service and characteristic
      BluetoothService targetService = services.firstWhere(
        (s) => s.uuid.toString() == serviceUUID,
        orElse: () => throw Exception('Service not found'),
      );

      BluetoothCharacteristic targetCharacteristic =
          targetService.characteristics.firstWhere(
        (c) => c.uuid.toString() == characteristicUUID,
        orElse: () => throw Exception('Characteristic not found'),
      );


      // Enable notifications
      await targetCharacteristic.setNotifyValue(true);
      debug.append(text: 'Notifications enabled for characteristic');

      int userId = 1;

      final subscription = BLEMessageHandler.listenStream(targetCharacteristic: targetCharacteristic, debug: debug, userId: userId);

      device.cancelWhenDisconnected(subscription);
    } catch (e) {
      debug.append(text: 'Error: $e');
    }
  }


  static Future<void> bluetoothActionListening(
      {DebugHandler? debugController}) async {
    DebugHandler debug =
        (debugController == null) ? DebugHandler() : debugController;
    debug.append(text: 'Started Bluetooth Waiting Action!');
    // Insert your bluetooth listening actions here

    debug.append(text: 'Finished Bluetooth Waiting Action!');
  }
}
