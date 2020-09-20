import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  DateTime get date {
    return DateTime(year, month, day);
  }
  DateTime applyTimeOfDay(TimeOfDay time) {
    return DateTime(year, month, day, time.hour, time.minute);
  }
}