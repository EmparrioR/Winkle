import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themeNotifier.dart';

class Ayarlar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
      ),
      body: ListView(children: <Widget>[
        SwitchListTile(
          title: Text("Dark Mode"),
          value: themeNotifier.isDarkMode,
          onChanged: (value) async {
            themeNotifier.toggleTheme();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isDarkMode', value);
          },
        ),
      ]),
    );
  }
}
