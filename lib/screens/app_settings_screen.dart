import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// Import your preferred icon package or use Flutter's built-in icons

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  // Use your own theme management mechanism or remove these if not needed
  ThemeData theme = ThemeData.light(); 
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        // ... (your app bar customization)
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.language), // Replace with your icon
            title: Text('Language'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Show your custom language selection dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Select Language'),
                  // ... (add language selection options)
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
                // Update your theme here if you have a custom theme
              });
            },
          ),
          // Add more settings options here
          Divider(),
          ListTile(
            leading: Icon(Icons.info), // Replace with your icon
            title: Text('Documentation'),
            onTap: () => _launchURL('https://flutkit.coderthemes.com/index.html'), // Replace with your documentation URL
          ),
          ListTile(
            leading: Icon(Icons.update), // Replace with your icon
            title: Text('Changelog'),
            onTap: () => _launchURL('https://flutkit.coderthemes.com/changelogs.html'), // Replace with your changelog URL
          ),
          ElevatedButton(
            onPressed: () => _launchURL('https://1.envato.market/flutkit'), // Replace with your purchase URL
            child: Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  // Helper function to launch URLs
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $uri';
    }
  }

  // ... (add changeDirection function if needed)
}
