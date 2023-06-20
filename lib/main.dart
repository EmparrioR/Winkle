import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/giris_ve_kayit/giris.dart';
import 'ana_sayfa.dart';
import 'ayarlar/themeNotifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.currentTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              // Kullanıcı oturum açmamış, Giriş sayfasını göster
              return Giris();
            }
            // Kullanıcı oturum açmış, AnaSayfa'yı göster
            return AnaSayfa();
          }
          // Asenkron işlem henüz tamamlanmadıysa bir yükleniyor göstergesi göster
          return CircularProgressIndicator();
        },
      ),
    );
  }
}