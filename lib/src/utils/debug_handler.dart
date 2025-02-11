import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DebugHandler {
  static final timeFormatter = DateFormat('HH:mm:ss');
  final ValueNotifier<String> message = ValueNotifier<String>("");
  final ValueNotifier<Color> color = ValueNotifier<Color>(Color.fromRGBO(0, 0, 0, 1));

  void replace({required String text, Color? c}) {
    color.value = c ?? Color.fromRGBO(0, 0, 0, 1);
    message.value = ("[${timeFormatter.format(DateTime.now())}] $text\n");
    log("[${timeFormatter.format(DateTime.now())}] $text");
  }

  void append({required String text, Color? c}) {
    color.value = c ?? Color.fromRGBO(0, 0, 0, 1);
    message.value += ("[${timeFormatter.format(DateTime.now())}] $text\n");
    log("[${timeFormatter.format(DateTime.now())}] $text");
  }

  void clear() {
    message.value = '';
  }
}