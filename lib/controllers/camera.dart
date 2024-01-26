import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Camera {
  final ImagePicker _picker = ImagePicker();
  var imageFile;
  final onUpload;
  String? location;

  Camera({this.onUpload});

  Camera.profile({this.onUpload}) {
    location = 'profile';
  }

  Camera.stories({this.onUpload}) {
    location = 'stories';
  }

  Camera.messages({this.onUpload}) {
    location = 'messages';
  }

  void _takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    imageFile = File(image!.path);
    _uploadFile();
  }

  void _takeImageFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    imageFile = File(image!.path);
    _uploadFile();
  }

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString;
  }

  _uploadFile() {
    if (imageFile == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    var fileName = '${generateRandomString(7)}.jpg';
    var path =
        '${FirebaseAuth.instance.currentUser?.uid}/${location}/${fileName}';
    final imagesRef = storageRef.child(path);

    imagesRef.putFile(imageFile).snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.success:
          imagesRef.getDownloadURL().then((url) => onUpload(url));
          break;
        case TaskState.paused:
        case TaskState.running:
        case TaskState.canceled:
        case TaskState.error:
      }
    });
  }

  void showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Gallery'),
              onTap: () {
                _takeImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () {
                _takeImageFromCamera();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Cancel'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
