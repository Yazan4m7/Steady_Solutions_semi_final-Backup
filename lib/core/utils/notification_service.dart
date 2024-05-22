// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   Future initialize() async {
//     _firebaseMessaging.requestNotificationPermissions(
//       const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
//     );

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//   }

//   void subscribeToTopic(String topic) {
//     _firebaseMessaging.subscribeToTopic(topic);
//   }

//   void unsubscribeFromTopic(String topic) {
//     _firebaseMessaging.unsubscribeFromTopic(topic);
//   }

//   Future<String> getToken() async {
//     return await _firebaseMessaging.getToken();
//   }

//   void checkNotificationPermission() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission();
//     print('User granted permission: ${settings.authorizationStatus}');
//   }
// }
// // This function will handle the incoming messages when the app is in the background
// Future<void> _backgroundMessageHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

// // This function will be used to initialize the background message handler
// Future<void> initializeBackgroundMessageHandler() async {
//   FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
// }

// // This function will be used to check if the notification service is working properly
// Future<bool> isNotificationServiceWorking() async {
//   try {
//     String token = await _firebaseMessaging.getToken();
//     if (token != null) {
//       return true;
//     } else {
//       return false;
//     }
//   } catch (e) {
//     return false;
//   }
// }

// // This function will handle the incoming messages when the app is in the foreground
// Future<void> _foregroundMessageHandler(RemoteMessage message) async {
//   print("Handling a foreground message: ${message.messageId}");
// }

// // This function will be used to initialize the foreground message handler
// Future<void> initializeForegroundMessageHandler() async {
//   FirebaseMessaging.onMessage.listen(_foregroundMessageHandler);
// }

// // This function will handle the incoming messages when the app is terminated
// Future<void> _terminatedMessageHandler(RemoteMessage message) async {
//   print("Handling a terminated message: ${message.messageId}");
// }

// // This function will be used to initialize the terminated message handler
// Future<void> initializeTerminatedMessageHandler() async {
//   FirebaseMessaging.onMessageOpenedApp.listen(_terminatedMessageHandler);
// }

// // This function will delete the instance ID and the token associated with it
// Future<void> deleteInstanceID() async {
//   await _firebaseMessaging.deleteToken();
// }