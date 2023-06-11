import 'package:flutter/material.dart';
import 'package:todo/login/hesap_olusturma.dart';
import '../ana_sayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addUserToFirestore(UserCredential userCredential) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  final userSnapshot = await users.doc(userCredential.user?.uid).get();

  if (!userSnapshot.exists) {
    users.doc(userCredential.user?.uid).set({
      'username': userCredential.user?.displayName,
      'email': userCredential.user?.email,
      'photoUrl': userCredential.user?.photoURL,
    });
  }
}

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  await googleSignIn.signOut();

  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser == null) {
    return null;
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  await addUserToFirestore(userCredential);

  return userCredential;
}

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  _GirisState createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  final _emailController = TextEditingController();
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
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Kullanıcı E-Mail',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HesapOlusturma()),
                    );
                  },
                  child: const Text("Hesap Oluşturun"),
                ),
                Row(
                  children: <Widget>[
                    TextButton(
                      child: const Text(
                        'İptal',
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        _emailController.clear();
                        _passwordController.clear();
                      },
                      style: TextButton.styleFrom(),
                    ),
                    ElevatedButton(
                      child: const Text(
                        'Giriş',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AnaSayfa()),
                          );
                        } on FirebaseAuthException catch (e) {
                          String message = "Geçersiz Kullanıcı Adı veya Şifre";
                          final snackBar = SnackBar(content: Text(message));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5.0,
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                elevation: 5
              ),
              child: Text('Google ile Giriş Yap'),
              onPressed: () async {
                try {
                  final userCredential = await signInWithGoogle();

                  if (userCredential != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AnaSayfa()),
                    );
                  } else {
                    print('Google girişi iptal edildi.');
                  }
                } catch (e) {
                  print('Google ile giriş yaparken hata: $e');
                }
              },
            ),
            SizedBox(height: 125),
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
