import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../data/models/response.dart';
import 'debug_handler.dart';

class BLEMessageHandler {
  static bool isMessageComplete({required String message}){
    if (message[0] == "{" && message[message.length - 1] == "}") {
      if (message.allMatches('{').length == message.allMatches('}').length) {
        return true;
      }
    }
    return false;
  }

  static StreamSubscription<List<int>> listenStream({required BluetoothCharacteristic targetCharacteristic, required DebugHandler debug, required int userId}) {
    /* I'm declaring the message here, outside of the stream, so I can append
    the next value, in case the message comes incomplete. */
    String message = '';

    return targetCharacteristic.lastValueStream.listen((value) async {
      message += utf8.decode(value);
      if (BLEMessageHandler.isMessageComplete(message: message)) {
        // debug.append(text: message);
        String finalMessage = message;
        Map<String, dynamic> result = jsonDecode(finalMessage);
        ResponseModel response = ResponseModel.fromJson(json: result);
        switch (response.action) {
          case 'atc':
            debug.append(text: 'ATC received!');
            await sendLoginMessage(targetCharacteristic, debug, userId);
            break;
          case 'login-done':
            debug.append(text: 'Login complete!');
            break;
          case 'recycle-result':
            if (response.result == "OK") {
              debug.append(
                  text: "Valid Recycling action!",
                  c: Color.fromRGBO(30, 129, 39, 1.0));
            } else {
              debug.append(
                  text: "Inalid Recycling action!",
                  c: Color.fromRGBO(190, 2, 52, 1.0));
            }
            break;
          case 'r':
            debug.append(text: 'User recycled ${response.getCategory()} and kept the door open for ${response.openDoorDuration}ms');
            break;
        }
        message = '';
      }
    });
  }



  static Future<void> sendLoginMessage(
      BluetoothCharacteristic characteristic, DebugHandler debug, int userId) async {
    try {
      String uid = (userId.toString().padLeft(24, "0"));
      debug.append(text: 'Sending login message request for user $userId');
      String loginMessage =
      '{"a":"login","uid":"$uid","l":"1"}'
          .replaceAll(" ", "");

      List<int> byteData = utf8.encode(loginMessage);
      // Write the login message to the characteristic using "WRITE WITHOUT RESPONSE"
      await characteristic.write(byteData, withoutResponse: true);
      debug.append(text: 'Login message sent');
    } catch (e) {
      debug.append(text: 'Error sending login message: $e');
    }
  }
}