import 'package:flutter/material.dart';
class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Notifications")),
      body: ListView(
        children: [
          NotificationTile(
            title: "Close CM Job EQ",
            hoursAgo: 9241,
            icon: Icons.notifications,
            iconColor: Colors.red,
            count: 1,
          ),
          NotificationTile(
            title: "Close PM Job",
            hoursAgo: 5982,
            icon: Icons.notifications,
            iconColor: Colors.red,
            count: 2,
          ),
          NotificationTile(
            title: "Approve CM EQ",
            hoursAgo: 9241,
            icon: Icons.thumb_up,
            iconColor: Colors.purple,
            count: 1,
          ),
          // ... (Add more notification tiles)
        ],
      ),
    );
  }
}




class NotificationTile extends StatelessWidget {
  final String title;
  final int hoursAgo;
  final IconData icon;
  final Color iconColor;
  final int count; // Add a count for notifications

  const NotificationTile({
    required this.title,
    required this.hoursAgo,
    required this.icon,
    required this.iconColor,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2, // Add a subtle shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15), // Softer background for icon
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text("$hoursAgo h ago"),
        trailing: count > 0 ? Chip(label: Text('$count')) : null, // Display count if available
      ),
    );
  }
}

