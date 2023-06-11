import 'package:flutter/material.dart';
import 'package:todo/notlarim.dart';
import 'package:todo/ayarlar/ayarlar_ana_sayfa.dart';
import 'package:todo/hesabim.dart';
import 'to_do_sayfalari/planlanmis.dart';
import 'to_do_sayfalari/bugun.dart';
import 'to_do_sayfalari/gorevler.dart';
import 'to_do_sayfalari/rutinlerim.dart';
import 'to_do_sayfalari/onemli.dart';
import 'package:todo/ate_sayfalari/aliskanlik_takip_edici.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 0;
  final _pageController = PageController();

  List<String> pageTitles = ["Winkle", "Notlarım", "ATE", "Hesabım"];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
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
          pageTitles[_selectedIndex],
          style: TextStyle(color: Colors.white),
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
            alignment: Alignment.center,
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Bugun()));
                  },
                  child: Container(
                    child: Text(
                      "☀ Bugün",
                      style: TextStyle(fontSize: 24.0, color: Colors.green),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Onemli()));
                  },
                  child: Container(
                    child: Text(
                      "⭐ Önemli",
                      style: TextStyle(fontSize: 24.0, color: Colors.red),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Planlanmis()));
                  },
                  child: Container(
                    child: Text(
                      "🛩️ Planlanmış",
                      style: TextStyle(fontSize: 24.0, color: Colors.blue),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Gorevler()));
                  },
                  child: Container(
                    child: Text(
                      "🧾 Görevler",
                      style: TextStyle(fontSize: 24.0, color: Colors.purple),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Rutinlerim()));
                  },
                  child: Container(
                    child: Text(
                      "🧘‍♂ Rutinlerim",
                      style: TextStyle(fontSize: 24.0, color: Colors.orange),
                    ),
                    padding: EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
          Notlarim(),
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
          BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: 'ATE'),
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
}
