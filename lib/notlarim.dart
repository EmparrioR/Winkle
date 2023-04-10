import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'not_alma_sayfasi.dart';
import 'ana_sayfa.dart';
import 'hesabim.dart';
import 'takvim.dart';
import 'package:todo/ayarlar/ayarlar_ana_sayfa.dart';

class Notlarim extends StatefulWidget {
  @override
  _NotlarimState createState() => _NotlarimState();
}

class _NotlarimState extends State<Notlarim> {
  List<String> notes = [];

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
      } else if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Takvim()),
        );
      } else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Hesabim()),
        );
      }
    });
  }

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Ayarlar()));
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              )),
        ],
        title: Text('Notlarım'),
      ),
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_sharp), label: 'Notlarım'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Takvim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hesabım',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedFontSize: 20,
        unselectedFontSize: 15,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
