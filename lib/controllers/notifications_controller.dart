import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/notification_item.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
class NotificationsController extends GetxController {
  RxMap<String, NotificationItem> notificationsList =
      <String, NotificationItem>{}.obs;
  final ApiAddressController _apiController = Get.find<ApiAddressController>();
  final seenNotifications = <String>[].obs;
  RxBool isLoading = false.obs;
   RxInt unSeenNotificationsCount = 0.obs;
  bool  snackbarShown = false;

  onReady() {

    //  loadSeenNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;

    try {
      final Map<String, String> params = {
        'UserID': storageBox.read("id").toString(),
        'EquipmentTypeID': storageBox.read("role").toString(),
      };
      await Future.delayed(Duration(seconds: 2));
      final apiUrl =
          "http://${storageBox.read('api_url')}$getNotificationsEndPoint";
      print(Uri.parse(apiUrl).replace(queryParameters: params));
      final response =
          await http.get(Uri.parse(apiUrl).replace(queryParameters: params));
      final data = jsonDecode(response.body)["NotificationsList"];
      print("notifications respoinse : ${data} ");
      // Convert data to Notification model and add to the map

      data.forEach((item) {
       
        notificationsList[item["ID"].toString()] =
            NotificationItem.fromJson(item);
      });
    } catch (e) {
      if (kDebugMode) rethrow;
      // Handle error
    }
    print("fetch notifications : ${notificationsList.length}");
    isLoading.value = false;
    loadSeenNotifications();
    setUnSeenNotificationsCount();
  }

  void saveSeenNotifications() {
    storageBox.write('seenNotifications', seenNotifications);
  }

  void loadSeenNotifications() {
    List<dynamic>? seenNotifications = storageBox.read('seenNotifications');
    print("seenNotifications: $seenNotifications");
    if (seenNotifications != null) {
     
      for (var i = 0; i < seenNotifications.length; i++) {
        if (notificationsList[i] != null) notificationsList[i]?.isSeen = true;
      }
      
    }
  }

  bool checkNotificationSeen(String notificationId, bool isSeen) {
    isSeen = false;
    // Update the isSeen property of the notification
    if (notificationsList.containsKey(notificationId)) {
      return notificationsList[notificationId]!.isSeen!;
    }
    return isSeen;
  }

  void removeNotification(String notificationId) {
    // Remove the notification from the map
    notificationsList.remove(notificationId);
  }

  setUnSeenNotificationsCount() {
    int previousCount = unSeenNotificationsCount.value;
   unSeenNotificationsCount.value = notificationsList.entries
        .where((element) => element.value.isSeen == false)
        .map((e) => e.key)
        .toList()
        .length;
    //     if(unSeenNotificationsCount.value > 0 && previousCount != unSeenNotificationsCount.value && snackbarShown == false) {
    //  Future.delayed(Duration(seconds :1), () {
    //    Get.snackbar("Alert",
    //         "You have new ${unSeenNotificationsCount.value} Notifications");
    // });
    //     }
    print(" unseen count : current ${unSeenNotificationsCount.value} previous ${previousCount}");
  }


  Future<String> sendApproveOrEval ({required int reportId, required String repairDate,required int NotificationTypeId}) async{
 String responseMsg = "No connection made";
      final response = await http.post(
        Uri.parse(
          "http://${storageBox.read('api_url')}$sendApprovOrEvalEndPoint",
        ),
        body: {
          'CMReportID': reportId.toString(),
          'EquipmentTypeID':storageBox.read("role").toString(),
          'RepairDate': repairDate.toString(),
          'NotificationTypeID': NotificationTypeId.toString(),
          'UserID':  storageBox.read("id").toString(), 
          
      },
    );
    // Rest of the code...
    try{
      print(response.body);
    var json = jsonDecode(response.body);
    
   
    if(response.statusCode == 200){
    if (json["success"] == true) {
      responseMsg = "success" ;;
    } else {
      responseMsg = json["Message"];
    }
    }
    else{
      responseMsg = "Connection Failed.";
    }
    }catch(e){
      if(kDebugMode)
       rethrow;
       responseMsg = "Fatal Error Occoured, Err.192";
      
       
    }
    return responseMsg;
  }


}
