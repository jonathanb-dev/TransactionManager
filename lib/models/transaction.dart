import 'package:flutter/foundation.dart';

class Transaction {
  int id;
  String name;
  String description;
  double amount;
  DateTime dateAndTime;

  Transaction({
    this.id,
    @required this.name,
    @required this.description,
    @required this.amount,
    @required this.dateAndTime,
  });

  Transaction.fromMap(Map<String, dynamic> map) {
    id = map['Id'];
    name = map['Name'];
    description = map['Description'];
    amount = map['Amount'];
    dateAndTime = DateTime.parse(map['DateAndTime'].toString());
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'Name': name,
      'Description': description,
      'Amount': amount,
      'DateAndTime': dateAndTime.toIso8601String(),
    };
    if (id != null) {
      map['Id'] = id;
    }
    return map;
  }
}