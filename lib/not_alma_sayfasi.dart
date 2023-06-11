import 'package:flutter/material.dart';

class Note_Yazma_Sayfasi extends StatefulWidget {
  final String? note;

  Note_Yazma_Sayfasi({this.note});

  @override
  _Note_Yazma_SayfasiState createState() => _Note_Yazma_SayfasiState();
}

class _Note_Yazma_SayfasiState extends State<Note_Yazma_Sayfasi> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();

    String note = widget.note ?? '';
    _textEditingController = TextEditingController(text: note);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          autofocus: true,
          controller: _textEditingController,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _textEditingController.text);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}