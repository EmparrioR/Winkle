import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'aliskanlik_takip_edici.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitDetailPage extends StatefulWidget {
  final Habit habit;
  final Color color;

  HabitDetailPage(this.habit, this.color);

  @override
  _HabitDetailPageState createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final duration = DateTime.now().difference(widget.habit.startDate);
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
        backgroundColor: widget.habit.color,
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: days / 90,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(widget.habit.color),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(days / 90 * 100).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 24, color: widget.color),
                    ),
                    Text("90 gün")
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Divider(color: Colors.black),
          SizedBox(height: 16),
          Text(
            '$days gün',
            style: TextStyle(fontSize: 24, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '$hours h $minutes m',
            style: TextStyle(fontSize: 24, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Divider(
            color: Colors.black,
          ),
          SizedBox(height: 16),
          TableCalendar(
            firstDay: widget.habit.startDate,
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            calendarBuilders: CalendarBuilders(
              // bu fonksiyon, her bir günün görünümünü belirler
              // bu örnekte, alışkanlığın başladığı günden itibaren geçen tüm günleri belirli bir renkle işaretliyoruz
              markerBuilder: (context, day, events) {
                if (day.isBefore(DateTime.now()) &&
                    !(isSameDay(day, DateTime.now()))) {
                  return Container(
                    decoration: BoxDecoration(
                      color: widget.habit.color, // işaretli günlerin rengi
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('d').format(day),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
