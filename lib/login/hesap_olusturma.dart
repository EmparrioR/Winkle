import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/login/giris.dart';

class HesapOlusturma extends StatefulWidget {
  const HesapOlusturma({Key? key}) : super(key: key);

  @override
  State<HesapOlusturma> createState() => _HesapOlusturmaState();
}

class _HesapOlusturmaState extends State<HesapOlusturma> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isWaitingForEmailVerification = false;
  bool _isVerificationSuccess = false;
  Timer? _verificationCheckTimer;

  void signUp(String email, String password, String username) async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      setState(() {
        _isWaitingForEmailVerification = true;
        _isLoading = false;
      });

      checkEmailVerified(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkEmailVerified(User user) async {
    _verificationCheckTimer =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      await user.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        timer.cancel();

        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'username': _usernameController.text,
          'email': _emailController.text,
        });

        setState(() {
          _isVerificationSuccess = true;
          _isWaitingForEmailVerification = false;
        });

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Giris()),
          );
        });
      }
    });
  }

  void iptalEt() async {
    _verificationCheckTimer?.cancel();

    await FirebaseAuth.instance.currentUser?.delete();

    setState(() {
      _isWaitingForEmailVerification = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isWaitingForEmailVerification) {
          iptalEt();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Center(
          child: _isLoading
              ? CircularProgressIndicator()
              : _isWaitingForEmailVerification
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Email onayı bekleniyor...'),
                        SizedBox(height: 20),
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: iptalEt,
                          child: Text('İptal Et'),
                        ),
                      ],
                    )
                  : _isVerificationSuccess
                      ? AnimatedSwitcher(
                          duration: Duration(seconds: 2),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Icon(Icons.check_circle,
                              color: Colors.green,
                              size: 75,
                              key: ValueKey<int>(1)),
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            children: <Widget>[
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'E-Mail Giriniz ',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Kullanıcı Adı Oluşturunuz ',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Şifre Oluşturunuz ',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: 25),
                              FloatingActionButton(
                                child: const Text(
                                  '➡️',
                                  style: TextStyle(fontSize: 30.0),
                                ),
                                onPressed: () {
                                  signUp(
                                    _emailController.text,
                                    _passwordController.text,
                                    _usernameController.text,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}
