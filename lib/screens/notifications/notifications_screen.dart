<<<<<<< HEAD
=======
import 'dart:developer';

>>>>>>> 045059f (First Testing Version)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/notifications_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:steady_solutions/models/notification_item.dart';
import 'package:steady_solutions/models/work_orders/WorkOrderDetails.dart';
import 'package:steady_solutions/screens/notifications/approve_report.dart';
import 'package:steady_solutions/screens/notifications/work_oreder_details.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  final NotificationsController _notificationsController =
      NotificationsController();
  late AnimationController controller;
  @override
  void initState() {
    _notificationsController.fetchNotifications();
    _notificationsController.saveSeenNotifications();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    final spinkit = SpinKitDoubleBounce(color: kPrimaryColor1Green, size: 50.0);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF4e7ca2)),
        title: Text("Notifications"),
        backgroundColor: Colors.white,
      ),
      // extendBodyBehindAppBar: true,
      body: Obx(
        () => _notificationsController.isLoading.value == true
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: spinkit,
                  ),
                  SizedBox(height: 20.h),
                  Text("Please wait..")
                ],
              ))
            : Container(
                //color: Colors.white,
                child: ListView.builder(
                  itemCount: _notificationsController.notificationsList.length,
                  itemBuilder: (context, index) {
                    final entry = _notificationsController
                        .notificationsList.entries
                        .elementAt(index);
                    return NotificationTile(notification: entry.value);
                  },
                ),
              ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  NotificationTile({
    required this.notification,
  });
  final NotificationsController _notificationsController =
      NotificationsController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 27.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 222, 222, 222).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 8), // changes position of shadow
            ),
          ],
          shape: BoxShape.rectangle,
          // borderRadius: BorderRadius.circular(10),
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: [
          //     Colors.white.withOpacity(0.5),
          //     getBackgroundColor(notification.notificationTypeID) ,
          //   ],
          // ),
        ),
        child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: getIconColor(notification.notificationTypeID)
                    .withOpacity(0.2), // Softer background for icon
                //  borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                getIcon(notification.notificationTypeID),
                color: getIconColor(notification.notificationTypeID),
                size: 28,
              ),
            ),
            title: Text(
              notification.notificationTypeDesc ?? "N/A",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.msgNotes ?? "-"),
                Text(
                    "${convertToHoursAgo(notification.notificationDate!)} h ago"),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: notification.isSeen ? Colors.black : Colors.grey,
              ),
              onPressed: () {
<<<<<<< HEAD
=======
                log("Notification id : ${notification.notificationTypeID}");
>>>>>>> 045059f (First Testing Version)
                if (notification.notificationTypeID == null) {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Error'),
                      content: const Text("Notification ID is missing"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                } else

<<<<<<< HEAD
                //////////// CLOSE CM JOB
                if (notification.notificationTypeID == 1) {
=======
                //////////// CLOSE CM JOB [2 Buttons ]
                if ([1,7].contains(notification.notificationTypeID)) {
>>>>>>> 045059f (First Testing Version)
                  notification.isSeen = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewReport(
                          forId1: notification.forID1!,
                          passedParDate: notification.passedParDate!,
                          reportId: notification.forID1!,
                          notificationedTypeId:
                              notification.notificationTypeID!),
                    ),
                  );
                }
<<<<<<< HEAD
                ///////////// CREATE WORK ORDER
                else if (notification.notificationTypeID == 22) {
=======
                 ///////////// CREATE WORK ORDER [1 Buttons ]
                else if ([5,9].contains(notification.notificationTypeID) ) {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkOrderDetailsScreen(
                          workOrderId: notification.forID1!,
                          passedPar1: notification.passedPar1.toString(),),
                    ),
                  );
                }
                ///////////// CREATE WORK ORDER
                else if ([22].contains(notification.notificationTypeID) ) {
                  
>>>>>>> 045059f (First Testing Version)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkOrderDetailsScreen(
                          workOrderId: notification.forID1!,
                          passedPar1: notification.passedPar1.toString(),),
                    ),
                  );
                }
                /////// APPROVE EVALUATTION
<<<<<<< HEAD
                else if (notification.notificationTypeID == 5) {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewReport(
                          forId1: notification.forID1!,
                          passedParDate: notification.passedParDate!,
                          reportId: notification.forID1!,
                          notificationedTypeId:
                              notification.notificationTypeID!),
                    ),
                  );
                  
                } else {
=======
               else if ([22].contains(notification.notificationTypeID) ) {
>>>>>>> 045059f (First Testing Version)
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Error'),
                      content: Text(
<<<<<<< HEAD
                          "Notification ID  ${notification.notificationTypeID} is not recognized"),
=======
                          "Notification ID ${notification.notificationTypeID} from the server is not recognized"),
>>>>>>> 045059f (First Testing Version)
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
                ;
              },
              iconSize: 30,
              splashRadius: 24,
              tooltip: notification.isSeen ? 'Mark as unread' : 'Mark as read',
              padding: EdgeInsets.zero,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              constraints: BoxConstraints(),
              enableFeedback: true,
              focusColor: Colors.transparent,
              autofocus: false,
              focusNode: FocusNode(),
              style: ButtonStyle(
                // shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                //   RoundedRectangleBorder(
                //     side: BorderSide(
                //       color:
                //           notification.isSeen ? Colors.black : Colors.grey,
                //       width: 2,
                //     ),
                //     //borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.blue;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.blue.withOpacity(0.8);
                    }
                    return notification.isSeen
                        ? Colors.transparent
                        : Colors.white;
                  },
                ),
              ),
            )

            // Display count if available
            ),
      ),
    );
  }

  convertToHoursAgo(String date) {
    try {
      // Reverse the format of date in string "15-05-2024 22:23:01" to "2024-05-15 22:23:01"
      List<String> parts = date.split(' ');
      List<String> dateParts = parts[0].split('/');
      date = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]} ${parts[1]}';
      return DateTime.now().difference(DateTime.parse(date)).inHours.toString();
    } catch (e) {
      // print(e);
      return '0';
    }
  }

  IconData getIcon(NotificationTypeID) {
    switch (NotificationTypeID) {
      case 1:
        return Icons.thumb_up;
      case 7:
        return Icons.notifications;
      case 5:
        return Icons.add_shopping_cart_outlined;
      case 9:
        return Icons.delivery_dining_outlined;
      default:
        return Icons.error;
    }
  }

  Color getIconColor(NotificationTypeID) {
    switch (NotificationTypeID) {
      case 1:
        return Colors.red;
      case 7:
        return Colors.purple;
      case 5:
        return Colors.green;
      case 9:
        return Colors.blueGrey;
      default:
        return Colors.blue;
    }
  }

  Color getBackgroundColor(NotificationTypeID) {
    switch (NotificationTypeID) {
      // achievment id ForID1 with 2 buts
      case 1:
        return const Color.fromARGB(255, 246, 152, 145);
      case 7:
        return const Color.fromARGB(255, 243, 177, 255);

      // one approve button
      case 5:
        return const Color.fromARGB(255, 168, 255, 171);
      case 9:
        return Colors.blueGrey;
      default:
        return const Color.fromARGB(255, 149, 204, 248);
    }
  }
}
