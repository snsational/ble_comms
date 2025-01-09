import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DebugHandler {
  static final timeFormatter = DateFormat('HH:mm:ss');
  final ValueNotifier<String> message = ValueNotifier<String>("");

  void replace({required String text}) {
    message.value = ("[${timeFormatter.format(DateTime.now())}] $text\n");
  }

  void append({required String text}) {
    message.value += ("[${timeFormatter.format(DateTime.now())}] $text\n");
  }

  void clear() {
    message.value = '';
  }
}