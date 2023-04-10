import 'package:flutter/material.dart';
import 'package:todo/notlarim.dart';
import 'ana_sayfa.dart';
import 'ayarlar/ayarlar_ana_sayfa.dart';
import 'takvim.dart';

class Hesabim extends StatefulWidget {
  const Hesabim({Key? key}) : super(key: key);

  @override
  State<Hesabim> createState() => _HesabimState();
}

class _HesabimState extends State<Hesabim> {
  String _name = 'Alperen Atar';
  String _email = 'alperenatar@example.com';
  String _phoneNumber = '+1 (555) 555-5555';

  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex == 0){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
      }
      else if(_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notlarim()),
        );
      }
      else if(_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Takvim()),
        );
      }
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
        title: Text(
          'Hesabım',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50.0),
            CircleAvatar(
              radius: 100.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              _name,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              _email,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              _phoneNumber,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 160.0),
            TextButton(
              onPressed: null,
              child: Text("Hesap Ekle",
                  style: TextStyle(color: Colors.red, fontSize: 15)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: new Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Divider(
                    color: Colors.black,
                    height: 15,
                  ),
                ))
              ],
            ),
            TextButton(
              onPressed: null,
              child: Text("Hesapları Yönet",
                  style: TextStyle(color: Colors.red, fontSize: 15)),
            ),
          ],
        ),
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
            icon: Icon(Icons.edit_note_sharp),
            label: 'Notlarım',
          ),
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
