import 'package:flutter/material.dart';
import 'package:todo/notlarim/notlarim.dart';
import 'package:todo/ayarlar/ayarlar_ana_sayfa.dart';
import 'package:todo/hesabim.dart';
import 'to_do_sayfalari/planlanmis/planlanmis.dart';

import 'to_do_sayfalari/bugun.dart';
import 'to_do_sayfalari/gorevler.dart';
import 'to_do_sayfalari/rutinlerim.dart';
import 'to_do_sayfalari/onemli.dart';
import 'package:todo/ate_sayfalari/aliskanlik_takip_edici.dart';
import 'adim_sayar/adim_sayar.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 0;
  final _pageController = PageController();
  List<String> pageTitles = [
    "Winkle",
    "Notlarım",
    "Adım Sayar",
    "ATE",
    "Hesabım"
  ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
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
      transitionDuration: Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context, createRoute(Ayarlar()));
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).unselectedWidgetColor,
            ),
          ),
        ],
        title: Text(
          pageTitles[_selectedIndex],
          style: TextStyle(color: Theme.of(context).unselectedWidgetColor),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.green
            ),
            alignment: Alignment.center,
            child: ListView(
              padding: EdgeInsets.all(8),
              children: <Widget>[
                buildCard("☀ Bugün", Colors.green, () {
                  Navigator.push(context, createRoute(Bugun()));
                }),
                buildCard("⭐ Önemli", Colors.red, () {
                  Navigator.push(context, createRoute(Onemli()));
                }),
                buildCard("🛩️ Planlanmış", Colors.blue, () {
                  Navigator.push(context, createRoute(Planlanmis()));
                }),
                buildCard("🧾 Görevler", Colors.purple, () {
                  Navigator.push(context, createRoute(Gorevler()));
                }),
                buildCard("🧘‍♂ Rutinlerim", Colors.orange, () {
                  Navigator.push(context, createRoute(Rutinlerim()));
                }),
              ],
            ),
          ),
          Notlarim(),
          AdimSayar(),
          Aliskanlik_Takip_Edici(),
          Hesabim(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_sharp), label: 'Notlarım'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run), label: 'Adım Sayar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility), label: 'ATE'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hesabım'),
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

  Card buildCard(String text, Color color, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(

          ),
          padding: EdgeInsets.all(30),
          child: Text(
            text,
            style: TextStyle(fontSize: 24.0, color: color),
          ),
        ),
      ),
    );
  }
}
