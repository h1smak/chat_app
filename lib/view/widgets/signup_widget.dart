// ignore_for_file: unused_import
import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/global.dart';
import 'package:firebase_chat_app/view/widgets/login_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../service/firebase_firestore_service.dart';
import '../../service/firebase_storage_service.dart';
import '../../service/media_service.dart';
import '../../service/notification_service.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Uint8List? file;
  static final notifications = NotificationsService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                GestureDetector(
                  onTap: () async {
                    final pickedImage = await MediaService.pickImage();
                    setState(() => file = pickedImage!);
                  },
                  child: file != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(file!),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: mainColor,
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
                TextFormField(
                  controller: nameController,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => email != null && email.isEmpty
                      ? 'Name cannot be empty.'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min. 6 characters'
                      : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      passwordController.text != confirmPasswordController.text
                          ? 'Passwords do not match'
                          : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: Icon(Icons.arrow_forward,
                        size: 32,
                        color: Theme.of(context).colorScheme.onSecondary),
                    label: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    onPressed: signUp),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20),
                    text: 'Already have an account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigate(context, LoginWidget());
                          },
                        text: 'Log In',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    if (file == null) {
      const snackBar =
          SnackBar(content: Text('Please select a profile picture'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    Future<void> showLoadingDialog(BuildContext context) async {
      Completer<void> completer = Completer<void>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
            completer
                .complete(); // Complete the Future when the dialog is dismissed
          });

          return const Center(child: CircularProgressIndicator());
        },
      );

      return completer.future; // Return the Future from the function
    }

    try {
      await showLoadingDialog(context);
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final image = await FirebaseStorageService.uploadImage(
          file!, '${user.user!.uid}/profile/${user.user!.uid}');

      await FirebaseFirestoreService.createUser(
        image: image,
        email: user.user!.email!,
        uid: user.user!.uid,
        name: nameController.text,
      );

      navigate(context, MyHomePage());

      await notifications.requestPermission();
      await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Password is too weak',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        );} else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'Account already exists',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          );
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text(
                'The email is not correct',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          );
        }    
      }
    }
  }
