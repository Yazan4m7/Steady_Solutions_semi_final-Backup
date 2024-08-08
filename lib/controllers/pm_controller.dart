import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/pm/calendar_item.dart';
import 'package:steady_solutions/models/pm/pending_pm_work_order.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/screens/pm/oldcalendar.dart';

class PMController extends GetxController {
RxMap<String, CalendarItem> calendarItems = RxMap();
Rx<bool> isLoading = false.obs;
RxList<PendingPMWorkOrder> pendingPMWorkOrders = <PendingPMWorkOrder>[].obs;
@override
onReady(){
 
}

Future<void> fetchCalendarItems() async {
  calendarItems = RxMap();
// Your code here
// print("xxxxxxxxxx");
isLoading.value = true;
  try {
final Map<String, String> params = {
'start': '01-01-2024',
'end': '30-08-2024',
'UserID': storageBox.read("id").toString(),
'EquipmentTypeID': storageBox.read("role").toString(),
};

final response = await http.get(
    Uri.parse("https://${storageBox.read('api_url')}$getCalendarEndPoint")
        .replace(queryParameters: params));

        print(Uri.parse("https://${storageBox.read('api_url')}$getCalendarEndPoint")
        .replace(queryParameters: params));
 
List temp = jsonDecode(response.body);

temp.forEach((item) {
// print("add");
calendarItems[item["title"]] = CalendarItem.fromJson(item);
});
 } catch (e) {
    if(kDebugMode)
     rethrow;
     else {
      Get.to(HomeScreen());
    }

   }
print(calendarItems.length);

print(calendarItems.toString());
print(calendarItems.runtimeType);
isLoading.value = false;
}

Future<void> fetchPMList() async {
 isLoading.value = true;
  try {
final Map<String, String> params = {

'UserID': storageBox.read("id").toString(),
'EquipmentTypeID': storageBox.read("role").toString(),
};

final response = await http.get(
    Uri.parse("https://${storageBox.read('api_url')}$getPendingPMListEndPoint")
        .replace(queryParameters: params));

        print(Uri.parse("https://${storageBox.read('api_url')}$getPendingPMListEndPoint")
        .replace(queryParameters: params));
  print("Get calender response : " + response.body);
List temp = jsonDecode(response.body);
    //List temp = jsonDecode(response.body)['data'];
    for (var item in temp) {
      pendingPMWorkOrders.add(PendingPMWorkOrder.fromJson(item));
    }
  }catch (e) {
    if(kDebugMode)
     rethrow;
     else {
      print(e.toString());
      isLoading.value = false;
      Get.defaultDialog(
        barrierDismissible: false,
        middleText: "Error",
        middleTextStyle: TextStyle(fontSize: 18),
        title: "Error",
        content: Text("Something went wrong. Please try again later."),
        actions: [
          TextButton(
            child: Text("Close"),
            onPressed: () {
              Get.back();
              Get.offAll(HomeScreen());
            },
          )
        ],
      );
      Get.to(HomeScreen());
    }

}
 isLoading.value = false;
}
}