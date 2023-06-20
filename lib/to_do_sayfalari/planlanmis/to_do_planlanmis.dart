import 'package:flutter/material.dart';

class Todo {
  int? id;
  String title;
  bool isDone;
  DateTime? date;
  TimeOfDay? time;


  Todo({
    this.id,
    required this.title,
    required this.isDone,
    this.date,
    this.time,

  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date != null ? date!.toIso8601String() : null,
      'time': time != null
          ? '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}'
          : null,
      'isDone': isDone,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'] != null
          ? TimeOfDay(
        hour: int.parse(json['time'].split(':')[0]),
        minute: int.parse(json['time'].split(':')[1]),
      )
          : null,
      isDone: json['isDone'],
    );
  }
}
