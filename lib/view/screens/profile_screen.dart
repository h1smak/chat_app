import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/controllers/camera.dart';
import 'package:firebase_chat_app/firestore_models/user_data.dart';
import 'package:firebase_chat_app/global.dart';
import 'package:firebase_chat_app/main.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  var _textStatus = TextEditingController();
  var _textName = TextEditingController();

  Stream<UserData> getFirebaseDataStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .where("uid", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs[0].data();
        return UserData.fromMap(data);
      } else {
        return UserData(image: '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Form(
          key: formKey,
          child: StreamBuilder<UserData>(
            stream:
                getFirebaseDataStream(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Loading Information'));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error'));
              }
              if (!snapshot.hasData) {
                return Center(child: Text('No data available'));
              }
              UserData? user = snapshot.data;
              _textName.text = user?.name ?? '';
              _textStatus.text = user?.status ?? '';
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => {
                        Camera.profile(onUpload: (url) async {
                          updateProfilePhotoInFirestore(user!.uid, url);
                        }).showModal(context),
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.blue,
                        child: user?.image != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  user!.image!,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 100,
                                height: 100,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 55),
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                        ),
                        controller: _textName,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 55),
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                          hintText: 'Enter your status',
                        ),
                        maxLength: 30,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        controller: _textStatus,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () async {
                          update();
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            navigate(context, const MyHomePage());
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void update() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      FirebaseAuth.instance.currentUser?.updateDisplayName(_textName.text);
      updateUserInFirestore(FirebaseAuth.instance.currentUser!.uid,
          _textName.text, _textStatus.text);
      navigate(
        context,
        MyHomePage(),
      );
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
