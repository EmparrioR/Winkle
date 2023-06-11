import 'package:flutter/material.dart';

class Todo {
  String title;
  bool isDone;
  DateTime? date;
  TimeOfDay? time;
  Todo({
    required this.title,
    required this.isDone,
    this.date,
    this.time
  });
}
