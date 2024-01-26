import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/global.dart';
import 'package:firebase_chat_app/theme/theme_provider.dart';
import 'package:firebase_chat_app/view/screens/profile_screen.dart';
import 'package:firebase_chat_app/view/widgets/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsItem extends StatelessWidget {
  const SettingsItem({
    Key? key,
    required this.title,
    required this.color,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: color,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => ListView(
          children: [
            SettingsItem(
            color: Colors.blue,
            icon: Icons.person,
            title: 'Account',
            onTap: () {
              navigate(context, ProfileScreen());
            },
          ),
            SwitchListTile(
              value: themeProvider.isDarkModeEnabled,
              onChanged: (newValue) {
                themeProvider.toggleDarkMode(newValue);
              },
              title: Text('Dark Mode'),
              secondary: Icon(Icons.dark_mode_outlined, color: Color.fromARGB(255, 255, 174, 34)),
            ),
            SettingsItem(
            color: Colors.redAccent,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              FirebaseAuth.instance.signOut();
              replace(context, const LoginWidget());
            },
          ),
          ],
        ),
      ),
    );
  }
}

