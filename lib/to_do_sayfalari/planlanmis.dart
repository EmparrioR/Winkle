import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'to_do.dart';

class Planlanmis extends StatefulWidget {
  @override
  _PlanlanmisState createState() => _PlanlanmisState();
}

class _PlanlanmisState extends State<Planlanmis> {
  List<Todo> todos = [];

  String newTodo = '';
  String editTodo = '';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Yeni Görev Ekle'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      newTodo = value;
                    },
                    decoration: InputDecoration(hintText: 'Görev adı girin'),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                        });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null && picked != selectedTime)
                        setState(() {
                          selectedTime = picked;
                        });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  this.setState(() {
                    todos.add(
                      Todo(
                        title: newTodo,
                        date: selectedDate,
                        time: selectedTime,
                        isDone: false,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Ekle'),
              ),
            ],
          );
        });
      },
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void editTodoDialog(int index) {
    DateTime selectedDate = todos[index].date!;
    TimeOfDay selectedTime = todos[index].time!;
    String editTodo = todos[index].title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Görevi Düzenle'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextFormField(
                    initialValue: todos[index].title,
                    onChanged: (value) {
                      editTodo = value;
                    },
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != selectedDate)
                        setState(() {
                          selectedDate = picked;
                        });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null && picked != selectedTime)
                        setState(() {
                          selectedTime = picked;
                        });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        selectedTime.format(context),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  this.setState(() {
                    todos[index] = Todo(
                      title: editTodo,
                      date: selectedDate,
                      time: selectedTime,
                      isDone: todos[index].isDone,
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Düzenle'),
              ),
            ],
          );
        });
      },
    );
  }

  void editTodoItem(int index, String newTitle) {
    setState(() {
      todos[index].title = newTitle;
      todos[index].date = selectedDate;
      todos[index].time = selectedTime;
    });
  }

  void toggleDone(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Planlanmış', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: NetworkImage(
                "https://images.unsplash.com/photo-1606768666853-403c90a981ad?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Checkbox(
                      value: todos[index].isDone,
                      onChanged: (bool? value) {
                        toggleDone(index);
                      },
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: todos[index].title + '\n',
                            style: TextStyle(
                              color: Colors.red, // Title text color
                              fontSize: 20.0, // Title text size
                              decoration: todos[index].isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          TextSpan(
                            text: (todos[index].date != null
                                ? DateFormat('dd/MM/yyyy').format(todos[index].date!)
                                : '') +
                                ' - ' +
                                (todos[index].time != null
                                    ? todos[index].time!.format(context)
                                    : ''),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              decoration: todos[index].isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            editTodoDialog(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteTodo(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodo();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
