import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'not_alma_sayfasi.dart';



class Notlarim extends StatefulWidget {
  @override
  _NotlarimState createState() => _NotlarimState();
}

class _NotlarimState extends State<Notlarim> {
  List<String> notes = [];


  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notes.isEmpty
          ? Center(
        child: Text('Lütfen yeni bir not ekleyiniz'),
      )
          : ListView.separated(
        itemCount: notes.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    String editedNote = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Note_Yazma_Sayfasi(note: notes[index]),
                      ),
                    );
                    if (editedNote != null) {
                      setState(() {
                        notes[index] = editedNote;
                      });
                      SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                      prefs.setStringList('notes', notes);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                    List<String> notes =
                        prefs.getStringList('notes') ?? [];
                    notes.removeAt(index);
                    await prefs.setStringList('notes', notes);
                    setState(() {
                      this.notes = notes;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Note_Yazma_Sayfasi()),
          );
          if (newNote != null) {
            setState(() {
              notes.add(newNote);
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setStringList('notes', notes);
          }
        },
        child: Icon(Icons.add),
      ),

    );
  }
}