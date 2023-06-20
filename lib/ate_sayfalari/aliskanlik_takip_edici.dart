import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'aliskanlik_detay_sayfasi.dart';
import 'ate_db_helper.dart';

class Aliskanlik_Takip_Edici extends StatefulWidget {
  @override
  _Aliskanlik_Takip_EdiciState createState() => _Aliskanlik_Takip_EdiciState();
}

class _Aliskanlik_Takip_EdiciState extends State<Aliskanlik_Takip_Edici> {
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> rawHabits =
        await DatabaseHelper.instance.queryAllRows(currentUserId);
    habits = rawHabits.map((habitMap) => Habit.fromMap(habitMap)).toList();
    setState(() {});
  }

  Future<void> _showEditHabitDialog(int index) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // Mevcut habit bilgilerini alır.
    Habit currentHabit = habits[index];
    TextEditingController _habitNameController =
        TextEditingController(text: currentHabit.name);
    DateTime _startDate = currentHabit.startDate;
    Color _color = currentHabit.color;
    final user = FirebaseAuth.instance.currentUser;

    final result = await showDialog<Habit>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: _habitNameController,
                      decoration:
                          InputDecoration(labelText: 'Alışkanlık Adını Yazın'),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _startDate = pickedDate;
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          _startDate == null
                              ? 'Başlangıç tarihini seçin'
                              : DateFormat('dd-MM-yyyy').format(_startDate),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        _color = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titlePadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      color: _color,
                                      onColorChanged: (Color color) =>
                                          _color = color,
                                      width: 44,
                                      height: 44,
                                      borderRadius: 22,
                                      spacing: 0,
                                      runSpacing: 0,
                                      wheelDiameter: 165,
                                      enableOpacity: true,
                                      colorCodeHasColor: true,
                                    ),
                                  ),
                                );
                              },
                            ) ??
                            _color;
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Renk seçin',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('İptal'),
                  onPressed: () {
                    Navigator.of(context).pop(currentHabit);
                  },
                ),
                TextButton(
                  child: Text('Düzenle'),
                  onPressed: () {
                    if (_habitNameController.text.isNotEmpty &&
                        _startDate != null) {
                      final User? currentUser =
                          FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        Navigator.of(context).pop(
                          Habit(
                            id: currentHabit.id,
                            name: _habitNameController.text,
                            startDate: _startDate!,
                            color: _color,
                            userId: currentUser.uid,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      await DatabaseHelper.instance.update(result.toMap());
      loadHabits();
    }
  }

  Future<void> _showAddHabitDialog() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    TextEditingController _habitNameController = TextEditingController();
    DateTime _startDate = DateTime.now();
    Color _color = Colors.blue; // Default color

    final result = await showDialog<Habit>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: _habitNameController,
                      decoration:
                          InputDecoration(labelText: 'Alışkanlık Adını Yazın'),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          _startDate = pickedDate;
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          _startDate == null
                              ? 'Başlangıç tarihini seçin'
                              : DateFormat('dd-MM-yyyy').format(_startDate),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        _color = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titlePadding: const EdgeInsets.all(0),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      color: _color,
                                      onColorChanged: (Color color) =>
                                          _color = color,
                                      width: 44,
                                      height: 44,
                                      borderRadius: 22,
                                      spacing: 0,
                                      runSpacing: 0,
                                      wheelDiameter: 165,
                                      enableOpacity: true,
                                      colorCodeHasColor: true,
                                    ),
                                  ),
                                );
                              },
                            ) ??
                            _color;
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Renk seçin',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('İptal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Ekle'),
                  onPressed: () {
                    if (_habitNameController.text.isNotEmpty &&
                        _startDate != null) {
                      final User? currentUser =
                          FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        Navigator.of(context).pop(
                          Habit(
                            name: _habitNameController.text,
                            startDate: _startDate!,
                            color: _color,
                            userId: currentUser.uid,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      await DatabaseHelper.instance.insert(result.toMap());
      loadHabits();
    }
  }

  void _removeHabit(int index) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    Habit removedHabit = habits.removeAt(index);
    if (removedHabit.id != null) {
      await DatabaseHelper.instance.delete(removedHabit.id!, currentUserId);
    }
    loadHabits();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removedHabit.name} silindi'),
        action: SnackBarAction(
          label: 'Geri Al',
          onPressed: () async {
            await DatabaseHelper.instance.insert(removedHabit.toMap());
            loadHabits();
          },
        ),
      ),
    );
  }

  Route createRoute(Widget page) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: habits.isEmpty
          ? Center(
              child: Text("Lütfen yeni bir alışkanlık ekleyiniz"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      final habit = habits[index];
                      final duration =
                          DateTime.now().difference(habit.startDate).inDays;
                      final color = habit.color;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Dismissible(
                            key: UniqueKey(),
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.endToStart) {
                                _removeHabit(index);
                              } else {
                                await _showEditHabitDialog(index);
                              }
                            },
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.edit, color: Colors.green),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                            direction: DismissDirection.horizontal,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(HabitDetailPage(habit, color)),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          color: color,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(habit.name,
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(25.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text('$duration gün',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class Habit {
  int? id;
  String name;
  DateTime startDate;
  Color color;
  String userId;

  Habit({
    this.id,
    required this.name,
    required this.startDate,
    required this.color,
    required this.userId,
  });

  Habit.fromMap(Map<String, dynamic> map)
      : id = map[DatabaseHelper.columnId],
        name = map[DatabaseHelper.columnName],
        startDate = DateTime.parse(map[DatabaseHelper.columnDateTime]),
        color = Color(map[DatabaseHelper.columnColor]),
        userId = map[DatabaseHelper.columnUserId];

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnDateTime: startDate.toIso8601String(),
      DatabaseHelper.columnColor: color.value,
      DatabaseHelper.columnUserId: userId,
    };
  }
}
