import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void navigate(BuildContext context, Widget d) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => d));
  }

  void replace(BuildContext context, Widget d) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return d;
        },
      ),
    );
  }

  void pop(context) => Navigator.pop(context);

  void updateStories(String? uid, String newStorie) {
  FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get().then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs[0];
      
      List<String> currentStories = List<String>.from(userDoc['stories'] ?? []);

      currentStories.add(newStorie);

      userDoc.reference.update({
        'story': true,
        'stories': currentStories,
      });
    } else {
    }
  });
}

void updateProfilePhotoInFirestore(String? uid, String? avatar) {
  FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get().then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs[0];
      userDoc.reference.update({
        'image': avatar,
      });
    } else {
      // Пользователь с указанным uid не найден.
    }
  });
}

void updateUserInFirestore(String? uid, String name, String status) {
  FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).get().then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs[0];
      userDoc.reference.update({
        'name': name,
        'status': status,

      });
    } else {
      // Пользователь с указанным uid не найден.
    }
  });
}