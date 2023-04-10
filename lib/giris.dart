import 'package:flutter/material.dart';
import 'ana_sayfa.dart';

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/app_icon.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'WINKLE',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 60.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',

                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 25.0),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'İptal',
                    style: TextStyle(color: Colors.red, fontSize: 20.0),
                  ),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                  style: TextButton.styleFrom(),
                ),
                ElevatedButton(
                  child: const Text(
                    'Giriş',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnaSayfa()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 150),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(children: <TextSpan>[
                TextSpan(text: 'from ', style: TextStyle(color: Colors.red)),
                TextSpan(
                    text: 'Alperen Atar',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
