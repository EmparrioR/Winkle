import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/to_do_sayfalari/to_do_db_helper.dart';
import 'dart:math';
import 'to_do.dart';

abstract class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);

  String getBackgroundImageURL();
  String getAppBarTitle();
  String getTableName();
  Color getAppBarColor();
  Color getDialogColor();

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState extends State<BasePage> with SingleTickerProviderStateMixin {
  final _fieldController = TextEditingController();
  List<Todo> todos = [];
  String newTodo = '';
  String editTodo = '';
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    createTableIfNotExists();
    fetchTodos();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  Future<void> createTableIfNotExists() async {
    final db = await DatabaseHelper.instance.database;
    await DatabaseHelper.instance.createTable(widget.getTableName(), db!);
  }

  Future<void> fetchTodos() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      todos = await DatabaseHelper.instance.queryRowsByUserId(user.uid, widget.getTableName());
      setState(() {});
    }
  }

  Future<void> addTodo() async {
    _animationController?.forward(from: 0.0);
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final todo = Todo(
        title: newTodo,
        isDone: false,
        userId: user.uid,
      );

      setState(() {
        todos.add(todo);
        newTodo = '';
      });

      await DatabaseHelper.instance.insert(todo, widget.getTableName());
    }
  }

  Future<void> deleteTodo(int index) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final todoList = await DatabaseHelper.instance.queryRowsByUserId(user.uid, widget.getTableName());

      if (index >= 0 && index < todoList.length) {
        final todo = todoList[index];

        await DatabaseHelper.instance.delete(todo.id!, widget.getTableName());

        setState(() {
          todos.removeAt(index);
        });
      }
    }
  }



  void editTodoDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Düzenle'),
          content: TextFormField(
            initialValue: todos[index].title,
            onChanged: (value) {
              setState(() {
                editTodo = value;
              });
            },
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.getDialogColor(),
              ),
              child: Text('Kaydet'),
              onPressed: () {
                editTodoItem(index, editTodo);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> editTodoItem(int index, String newTitle) async {
    setState(() {
      todos[index].title = newTitle;
    });

    await DatabaseHelper.instance.update(todos[index], widget.getTableName());
  }

  Future<void> toggleDone(int index) async {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
    });

    await DatabaseHelper.instance.update(todos[index], widget.getTableName());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.getAppBarTitle(), style: TextStyle(color: Colors.black)),
        backgroundColor: widget.getAppBarColor(),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.15), BlendMode.dstATop),
            image: NetworkImage(widget.getBackgroundImageURL()),
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
                    title: Text(
                      todos[index].title,
                      style: TextStyle(
                        decoration: todos[index].isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fieldController,
                      decoration: InputDecoration(
                        hintText: 'Bir Görev Ekle',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          newTodo = value;
                        });
                      },
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationController!,
                    builder: (_, __) {
                      return Transform.rotate(
                        angle: _animationController!.value * 2.0 * pi,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _fieldController.clear();
                            addTodo();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
