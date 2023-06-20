import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notlarim_db_helper.dart';
import 'not_alma_sayfasi.dart';

class Notlarim extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;

  @override
  _NotlarimState createState() => _NotlarimState();
}

class _NotlarimState extends State<Notlarim> {
  late List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final user = FirebaseAuth.instance.currentUser;
    var updatedNotes = await DatabaseHelper.instance.queryAllRows(user!.uid);
    setState(() {
      notes = updatedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: notes.isEmpty
            ? Center(
                child: Text(
                  'Lütfen yeni bir not ekleyiniz',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 1),
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red,width: 5)),
                      child: ListTile(
                        title: Text(notes[index]['note'],style: TextStyle(color: Colors.black),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                String? editedNote = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Note_Yazma_Sayfasi(note: notes[index]),
                                  ),
                                );
                                if (editedNote != null &&
                                    editedNote.isNotEmpty) {
                                  Map<String, dynamic> updatedNote = Map.from(
                                      notes[
                                          index]); // Notu bir map olarak kopyala
                                  updatedNote['note'] =
                                      editedNote; // Düzenlenen notu yeni map'e ata
                                  await DatabaseHelper.instance.update(
                                      updatedNote); // Yeni map'i veritabanına güncelle
                                  loadNotes();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                String currentUserId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                await DatabaseHelper.instance
                                    .delete(notes[index]['_id'], currentUserId);
                                loadNotes();
                              },
                            ),
                          ],
                        ),
                      ));
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String newNote = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Note_Yazma_Sayfasi()),
            );
            if (newNote != null && newNote.isNotEmpty) {
              String currentUserId = FirebaseAuth.instance.currentUser!.uid;
              await DatabaseHelper.instance
                  .insert({'note': newNote, 'userId': currentUserId});
              loadNotes();
            }
          },
          child: Icon(Icons.add),
        ));
  }
}
