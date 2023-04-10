import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ayarlar/themeNotifier.dart';
import 'giris.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(isDarkMode ? ThemeData.dark() : ThemeData.light(), isDarkMode),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.currentTheme,
      debugShowCheckedModeBanner: false,
      title: 'To-Do-App',
      home: Giris(),
    );
  }
}


