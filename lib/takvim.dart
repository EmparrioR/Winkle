import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'notlarim.dart';
import 'ayarlar/ayarlar_ana_sayfa.dart';
import 'ana_sayfa.dart';
import 'hesabim.dart';

class Takvim extends StatefulWidget {
  Takvim({Key? key}) : super(key: key);

  @override
  _TakvimState createState() => _TakvimState();
}

class _TakvimState extends State<Takvim> {

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
      } else if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notlarim()),
        );
      }
      else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Hesabim()),
        );
      }
    });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
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
        title: Text("Takvim"),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2021, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onDaySelected: _onDaySelected,
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
