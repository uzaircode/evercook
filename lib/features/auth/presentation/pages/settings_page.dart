import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const SettingsPage());
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Feedback'),
            onTap: () async {
              await launchUrl(
                Uri.parse('mailto:nikuzairsc@gmail.com?subject=Feedback'),
              );
            },
          ),
        ],
      ),
    );
  }
}
