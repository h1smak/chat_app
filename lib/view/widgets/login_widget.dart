// ignore_for_file: unused_import
import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/global.dart';
import 'package:firebase_chat_app/view/screens/chats_screen.dart';
import 'package:firebase_chat_app/view/widgets/signup_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../service/firebase_firestore_service.dart';
import '../../service/notification_service.dart';
import '../screens/auth/forgot_password_page.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static final notifications = NotificationsService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
                const FlutterLogo(size: 120),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
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
                  textInputAction: TextInputAction.done,
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.lock_open,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSecondary),
                  label: Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                  onPressed: signIn,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  )),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20),
                    text: 'No account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigate(context, SignUpWidget());
                          },
                        text: 'Sign Up',
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

  Future signIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      navigate(context, MyHomePage());

      await FirebaseFirestoreService.updateUserData(
        {'lastActive': DateTime.now()},
      );

      await notifications.requestPermission();
      await notifications.getToken();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              'Email or password are incorrect',
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
