import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/pm/calendar_item.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/screens/pm/oldcalendar.dart';

class PMController extends GetxController {
RxMap<String, CalendarItem> calendarItems = RxMap();
Rx<bool> isLoading = false.obs;

@override
onReady(){
 
}

Future<void> fetchCalendarItems() async {
// Your code here
// print("xxxxxxxxxx");
isLoading.value = true;
  try {
final Map<String, String> params = {
'start': '01-01-2024',
'end': '30-08-2024',
'companyID': '150',
'UserID': storageBox.read("id").toString(),
'EquipmentTypeID': storageBox.read("role").toString(),
};

final response = await http.get(
    Uri.parse("https://${storageBox.read('api_url')}$getCalendarEndPoint")
        .replace(queryParameters: params));
 // print("Get calender response : " + response.body);
List temp = jsonDecode(response.body);
//TODO Test
// String response =
// '[{"title":"7","StatusID":3,"PMReportID":0,"CompanyID":150,"start":"2024-01-17","endDate":"2024-01-17","Url":null,"CDesc":"1634C24"},'
// '{"title":"8","CDesc":"1634C24","start":"2024-07-17","endDate":"2024-07-17","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null}'
// ',{"title":"47","CDesc":"0040LAB","start":"2024-01-19","endDate":"2024-01-19","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null},'
// '{"title":"48","CDesc":"0040LAB","start":"2024-07-19","endDate":"2024-07-19","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null},'
// '{"title":"699","CDesc":"0039LAB","start":"2024-05-03","endDate":"2024-05-03","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null},{"title":"66","CDesc":"0039LAB","start":"2024-05-03","endDate":"2024-05-03","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null}'
// ',{"title":"67","CDesc":"0039LAB","start":"2024-06-03","endDate":"2024-06-03","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null},{"title":"68","CDesc":"0039LAB","start":"2024-07-03","endDate":"2024-07-03","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null},{"title":"69","CDesc":"0039LAB","start":"2024-08-03","endDate":"2024-08-03","StatusID":3,"PMReportID":0,"CompanyID":150,"Url":null}]';

// print("Get calender response : " + temp.toString());
temp.forEach((item) {
// print("add");
calendarItems[item["start"]] = CalendarItem.fromJson(item);
});
 } catch (e) {
    if(kDebugMode)
     rethrow;
     else {
      Get.to(HomeScreen());
    }

   }

// print(calendarItems.toString());
// print(calendarItems.runtimeType);
isLoading.value = false;
}

// loopThroughKeys();
// int count =0;
//   for (var item in calendarItems.values) {
//     // print("loop");
//       if (item.start == "2024-01-17") {
//         count++;
//       }

//       // print("COOOOOUNT" + count.toString());
//   // Your code here
// }
//   }
// void loopThroughKeys() {
//   // print("lenggg ${calendarItems.length}");
//   for (final key in calendarItems.keys) {
//     CalendarItem item = calendarItems["2024-01-17"]!; // Access value using key  safety
//     // print("Key: $key, Value: ${item}");
//   }
// }
}
