import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'giris_ve_kayit/giris.dart';
import 'package:permission_handler/permission_handler.dart';

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

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

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
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Users').doc(user.uid).get();
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
      String fileName =
          'profilePic_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile/${user.uid}/$fileName');

      if (imageBytes != null) {
        UploadTask uploadTask = storageReference.putData(imageBytes!);
        await uploadTask.whenComplete(() => null);

        String downloadURL = await storageReference.getDownloadURL();

        // Update user data in Firestore
        await _firestore.collection('Users').doc(user.uid).update({
          'photoUrl': downloadURL,
          'photoReference': 'profile/${user.uid}/$fileName'
        });

        if (mounted) {
          setState(() {});
        }
      }
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
      backgroundColor: Colors.orange,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: futureUserData,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // loading spinner
              } else if (snapshot.hasError) {
                return Text('Something went wrong :(');
              } else if (snapshot.hasData && snapshot.data!.data() != null) {
                var data = snapshot.data!.data()!;
                var username = data['username'] as String?;
                var email = data['email'] as String?;
                var photoUrl = (_auth.currentUser?.photoURL ?? data['photoUrl'])
                    as String?;

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
                      username ?? 'No username',
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      email ?? 'No email',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 160.0),
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
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Divider(
                            color: Colors.black,
                            height: 15,
                          ),
                        ))
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                  "Hesabınızı Silmek İstediğinizden Emin Misiniz ?"),
                              actions: [
                                TextButton(
                                  child: Text("İptal Et"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Evet"),
                                  onPressed: () async {
                                    try {
                                      User? user = _auth.currentUser;
                                      if (user != null) {
                                        // Firestore'dan kullanıcının bilgilerini alma
                                        DocumentSnapshot<Map<String, dynamic>>
                                            snapshot = await _firestore
                                                .collection('Users')
                                                .doc(user.uid)
                                                .get();
                                        Map<String, dynamic> data =
                                            snapshot.data()!;

                                        // Firebase Storage'dan kullanıcının tüm dosyalarını silme
                                        ListResult result =
                                            await FirebaseStorage.instance
                                                .ref('profile/${user.uid}')
                                                .listAll();
                                        for (Reference ref in result.items) {
                                          await ref.delete();
                                        }

                                        // Firestore'dan kullanıcının bilgilerini silme
                                        await _firestore
                                            .collection('Users')
                                            .doc(user.uid)
                                            .delete();

                                        // FirebaseAuth'dan kullanıcının hesabını silme
                                        User? currentUser = FirebaseAuth.instance.currentUser;
                                        if (currentUser != null) {
                                          await currentUser.delete();
                                        }
                                        // Yönlendirme
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => Giris()),
                                        );
                                      }
                                    } catch (e) {
                                      print('Error deleting account: $e');
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("Hesap Sil",
                          style: TextStyle(color: Colors.red, fontSize: 15)),
                    ),
                  ],
                );
              } else {
                return Text('Unexpected state: ${snapshot.connectionState}');
              }
            },
          ),
        ),
      ),
    );
  }
}
