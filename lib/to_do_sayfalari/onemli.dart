import 'package:flutter/material.dart';
import 'to_do.dart';

class Onemli extends StatefulWidget {
  @override
  _OnemliState createState() => _OnemliState();
}

class _OnemliState extends State<Onemli> {
  final _fieldController = TextEditingController();

  List<Todo> todos = [];

  String newTodo = '';
  String editTodo = '';

  void addTodo(int index) {
    setState(() {
      todos.add(Todo(
        title: newTodo,
        isDone: false,
      ));
      newTodo = '';
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void editTodoDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
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
                  backgroundColor: Colors.red,
                ),
                child: Text('Kaydet'),
                onPressed: () {
                  editTodoItem(index, editTodo);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void editTodoItem(int index, String newTitle) {
    setState(() {
      todos[index].title = newTitle;
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
        title: Text('Önemli', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.red,
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: NetworkImage(
                "https://images.unsplash.com/photo-1517607908060-9a66da662869?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
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
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _fieldController.clear();
                      addTodo(0);
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
