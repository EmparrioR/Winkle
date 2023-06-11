import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'login/giris.dart';

class Hesabim extends StatefulWidget {
  const Hesabim({Key? key}) : super(key: key);

  @override
  State<Hesabim> createState() => _HesabimState();
}

class _HesabimState extends State<Hesabim> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureUserData;
  Uint8List? imageBytes;
  String? _downloadURL;

  @override
  void initState() {
    super.initState();
    futureUserData = _fetchUserInfo();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('Users').doc(user.uid).get();
      return snapshot;
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageBytes = File(pickedFile.path).readAsBytesSync();
      });
      uploadFile();
    } else {
      print('No image selected.');
    }
  }

  Future uploadFile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('Users').doc(user.uid).get();
      Map<String, dynamic> data = snapshot.data()!;
      String? oldPhotoReference = data['photoReference'];

      // Delete the old file
      if (oldPhotoReference != null) {
        try {
          await FirebaseStorage.instance.ref(oldPhotoReference).delete();
        } catch (e) {
          // If error, catch and print
          print(e);
        }
      }

      // Upload the new file
      String fileName = 'profilePic_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile/${user.uid}/$fileName');

      UploadTask uploadTask = storageReference.putData(imageBytes!);
      await uploadTask.whenComplete(() => null);

      String downloadURL = await storageReference.getDownloadURL();

      setState(() {
        _downloadURL = downloadURL;

        // Update user data in Firestore
        _firestore.collection('Users').doc(user.uid).update({
          'photoUrl': _downloadURL,
          'photoReference': 'profile/${user.uid}/$fileName'
        });
      });
    }
  }

  ImageProvider<Object> _loadImage(String? photoUrl, Uint8List? imageBytes) {
    if (imageBytes != null) {
      return MemoryImage(imageBytes);
    } else if (photoUrl != null) {
      return NetworkImage(photoUrl);
    } else {
      return AssetImage("assets/account.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: futureUserData,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // loading spinner
            } else if (snapshot.hasError) {
              return Text('Something went wrong :(');
            } else {
              var data = snapshot.data!.data()!;
              var username = data['username'];
              var email = data['email'];
              var photoUrl = (_auth.currentUser?.photoURL ?? data['photoUrl']) as String?;

              return Column(
                children: [
                  SizedBox(height: 50.0),
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.white,
                      backgroundImage: _loadImage(photoUrl, imageBytes),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    username,
                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    email,
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
                          child: Container(
                            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 15,
                            ),
                          ))
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await _auth.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Giris()),
                        );
                      } catch (e) {
                        print('Error signing out: $e');
                      }
                    },
                    child: Text("Çıkış Yap",
                        style: TextStyle(color: Colors.red, fontSize: 15)),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
