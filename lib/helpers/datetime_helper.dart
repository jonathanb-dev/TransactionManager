import 'package:flutter/material.dart';

// Extensions
import '../extensions/datetime_extension.dart';

class DateTimeHelper {
  static Future<DateTime> showDateAndTimePicker(BuildContext context, DateTime dateAndTime) async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      initialDate: dateAndTime != null ? dateAndTime.date : DateTime.now().date,
      lastDate: DateTime.now().date,
    );
    if (pickedDate != null) {
      TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: dateAndTime != null ? TimeOfDay.fromDateTime(dateAndTime) : TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        return pickedDate.applyTimeOfDay(pickedTime);
      }
    }
    return null;
  }
}