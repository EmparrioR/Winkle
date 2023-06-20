import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import 'adim_sayar_db_helper.dart';

class AdimSayar extends StatefulWidget {
  AdimSayar({Key? key}) : super(key: key);

  @override
  AdimSayarState createState() => AdimSayarState();
}

class AdimSayarState extends State<AdimSayar> {
  Stream<StepCount>? _stepCountStream;
  int _stepCount = 0;
  int _stepGoal = 10000;
  String? _userId;
  final TextEditingController _goalController = TextEditingController();
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Stream<DateTime> _dayChangedStream = Stream.periodic(Duration(days: 1), (_) => DateTime.now());

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      int stepCount = await dbHelper.getStepCountForDate(
          _userId!, selectedDay.toIso8601String().substring(0, 10));
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      if (!isSameDay(DateTime.now(), selectedDay)) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(
                      '${selectedDay.day}/${selectedDay.month}/${selectedDay.year}', textAlign: TextAlign.center,),
                  content: Text('Bugün $stepCount adım yürüdünüz'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        _userId = user.uid;
        if (_userId != null) {
          initializePedometer();
          requestActivityRecognitionPermission();
        }
      }
    });

    _dayChangedStream.listen(resetStepsForNewDay);
  }

  void resetStepsForNewDay(DateTime day) async {
    if (_userId != null) {
      await dbHelper.insert({
        DatabaseHelper.columnUserId: _userId,
        DatabaseHelper.columnSteps: _stepCount,
        DatabaseHelper.columnGoal: _stepGoal,
        DatabaseHelper.columnDate: DateTime.now().toIso8601String(),
      });
    }
    setState(() {
      _stepCount = 0;
    });
  }

  void onStepCount(StepCount event) async {
    setState(() {
      _stepCount = event.steps;
    });
    if (_userId != null) {
      await dbHelper.update({
        DatabaseHelper.columnUserId: _userId,
        DatabaseHelper.columnSteps: _stepCount,
        DatabaseHelper.columnDate: DateTime.now().toIso8601String(),
      });
    }
  }

  void onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void initializePedometer() async {
    if (_userId != null) {
      var data = await dbHelper.getRow(_userId!);
      if (data.isNotEmpty) {
        _stepCount = data[DatabaseHelper.columnSteps];
        _stepGoal = data[DatabaseHelper.columnGoal];
      } else {
        await dbHelper.insert({
          DatabaseHelper.columnUserId: _userId,
          DatabaseHelper.columnSteps: _stepCount,
          DatabaseHelper.columnGoal: _stepGoal,
          DatabaseHelper.columnDate: DateTime.now().toIso8601String(),
        });
      }
    }

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(onStepCount).onError(onStepCountError);
  }

  void requestActivityRecognitionPermission() async {
    PermissionStatus permissionStatus =
        await Permission.activityRecognition.status;

    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.activityRecognition,
      ].request();
      print(statuses[Permission.activityRecognition]);
    }
  }

  void updateGoal() async {
    int? newGoal = int.tryParse(_goalController.text);
    if (newGoal != null && newGoal > 0) {
      setState(() {
        _stepGoal = newGoal;
      });
      if (_userId != null) {
        await dbHelper.update({
          DatabaseHelper.columnUserId: _userId,
          DatabaseHelper.columnGoal: _stepGoal,
          DatabaseHelper.columnDate: DateTime.now().toIso8601String(),
        });
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content:
                      Text('Günlük hedefiniz $_stepGoal adıma güncellendi'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    } else {
      print("Invalid goal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularPercentIndicator(
                    radius: 150.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent:
                        _stepCount > _stepGoal ? 1 : _stepCount / _stepGoal,
                    center: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.directions_run, size: 40,color: Colors.black,),
                        Text(
                          '$_stepCount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 50.0,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                    footer: Text(
                      'of $_stepGoal steps',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0,color: Colors.black),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.purple,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(

                            controller: _goalController,
                            decoration: InputDecoration(
                              labelText: "Hedefinizi Girin",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(color: Colors.black)),  //Add this
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(color: Colors.black)),
                              prefixIcon:
                                  Icon(Icons.radio_button_unchecked_sharp, color: Colors.black,),

                            ),
                            keyboardType: TextInputType.number,
                            onSubmitted: (value) => updateGoal(),
                          ),
                        ),
                        SizedBox(width: 10),
                        FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () {
                              updateGoal();
                              _goalController.clear();
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.now(),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(color: Colors.black),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),  //Add this
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),  //And this
                  titleCentered: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
