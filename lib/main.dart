import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/firestore_models/user_data.dart';
import 'package:firebase_chat_app/provider/firebase_provider.dart';
import 'package:firebase_chat_app/service/firebase_firestore_service.dart';
import 'package:firebase_chat_app/service/notification_service.dart';
import 'package:firebase_chat_app/theme/theme.dart';
import 'package:firebase_chat_app/theme/theme_provider.dart';
import 'package:firebase_chat_app/view/screens/settings_screen.dart';
import 'package:firebase_chat_app/view/widgets/people.dart';
import 'package:firebase_chat_app/view/widgets/signup_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firestore_model/firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';
import 'view/screens/auth/verify_email_page.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirestoreModel.injectAll([UserData()]);

  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FirebaseProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkModeEnabled ? darkMode : lightMode,
          home: MainPage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late int _currentIndex;
  late List<Widget> _screens;
  final notificationService = NotificationsService();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _screens = [
      VerifyEmailPage(),
      PeopleScreen(),
      SettingsScreen(),
    ];
    WidgetsBinding.instance.addObserver(this);
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();

    notificationService.firebaseNotification(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FirebaseFirestoreService.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        FirebaseFirestoreService.updateUserData({'isOnline': false});
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Chats',
            icon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            label: 'People',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
          future: getCurrentUser(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return const SignUpWidget();
            }
          }),
    );
  }
}
