import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/notification.dart';

class NotificationsController extends GetxController {
  final notifications = <String, Notification>{}.obs;
  
  Future<void> fetchNotifications() async {
    try {
      final apiUrl = "http://${storageBox.read('api_url')}$getCalendarEndPoint";
      final response = await http.get(Uri.parse(apiUrl));
      final data = jsonDecode(response.body);

      // Convert data to Notification model and add to the map
      final notificationsMap = <String, Notification>{};
      data.forEach((item) {
        final notification = Notification.fromJson(item);
        notificationsMap[notification.iD.toString()] = notification;
      });

      // Update the observable map
      notifications.assignAll(notificationsMap);
    } catch (e) {
      // Handle error
    }
  }
  

  bool checkNotificationSeen(String notificationId, bool isSeen) {
    isSeen = false;
    // Update the isSeen property of the notification
    if (notifications.containsKey(notificationId)) {
     return notifications[notificationId]!.isSeen!;
    }
    return isSeen;
  }

  void removeNotification(String notificationId) {
    // Remove the notification from the map
    notifications.remove(notificationId);
  }
    void unSeenNotificationIds() {
    // Remove the notification from the map
    notifications.entries.where((element) => element.value.isSeen == false).map((e) => e.key).toList();
  }
}