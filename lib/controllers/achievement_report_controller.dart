import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/job_for_achievement.dart';
import 'package:steady_solutions/models/work_orders/WorkOrderDetails.dart';

class AchievementReportsController extends GetxController {
  static AchievementReportsController get instance => Get.find();
  final AuthController _authController = Get.find<AuthController>();

  RxMap<String, ControlItemFromAchievement> controlItems =
      <String, ControlItemFromAchievement>{}.obs;
  Rx<ControlItemFromAchievement> selectedControlItem =
      ControlItemFromAchievement().obs;
  Rx<bool> isLoading = false.obs;

  Future<WorkOrderDetails> getWODetailsForNotification(String jobNumber) async {
    // print("wo number : $jobNumber");
    WorkOrderDetails woDetails;
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'JobNo': jobNumber,
    };

    try {
      final response = await http.get(
          Uri.parse("https://${storageBox.read('api_url')}$getWOJobInfoEndPoint")
              .replace(queryParameters: params));
              print(Uri.parse("https://${storageBox.read('api_url')}$getWOJobInfoEndPoint")
              .replace(queryParameters: params));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print("wo response: $data");
        woDetails = WorkOrderDetails.fromJson(data);
        print("1");
      } else {
          print("2");
        woDetails = WorkOrderDetails(
          equipName: "N/A",
          faultStatus:"N/A",
        );
      }
      return woDetails;
    } catch (e) {
        print("3");
      woDetails = WorkOrderDetails(
        equipName: "N/A",
        faultStatus: "N/A",

      );
      return woDetails;
    }
  }

  Future<void> getWOJobINfo(String jobNumber) async {
    // print("wo number : $jobNumber");
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'JobNo': jobNumber,
    };

    try {
      final response = await http.get(
          Uri.parse("https://${storageBox.read('api_url')}$getWOJobInfoEndPoint")
              .replace(queryParameters: params));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print("wo response: $data");
        selectedControlItem.value = ControlItemFromAchievement.fromJson(data);
      } else {
        selectedControlItem.value = ControlItemFromAchievement(
          equipName: "N/A",
          failureDate: "N/A",
          faultStatus:"N/A",
          caller: "N/A",
        );
      }
    } catch (e) {
      selectedControlItem.value = ControlItemFromAchievement(
        equipName: "N/A",
        failureDate: "N/A",
        faultStatus: "N/A",
        caller:"N/A",
      );
    }
  }

  Future<String> createAchievementReport({
    required String jobNumber,
       required TimeOfDay travelTime,
    required String remedy,
       String repairDate="",
      TimeOfDay? startTime,
      TimeOfDay? endTime,
   
    required String reasonForNotClosingJob,
    required String actionTakenToClosePendingJob,
  }) async {
    print(repairDate);
    print(startTime);
     print(endTime);
     
    final response = await http.post(
        Uri.parse(
          "https://${storageBox.read('api_url')}$createAchievementReportEndPoint",
        ),
        body: {
          'JobNo': jobNumber,
          'UserID': storageBox.read("id").toString(),
          'EquipmentTypeID': storageBox.read("role").toString(),

          /// MAIGHT CHANGE  :
          //'StartDate': repairDate,
          //'EndDate': repairDate,


          'StartTime': formatTimeOfDay(startTime ?? TimeOfDay(hour: 0, minute: 0)),
          'EndTime': formatTimeOfDay(endTime ?? TimeOfDay(hour: 0, minute: 0)), 
          'TravelTime':formatTimeOfDay(travelTime),
          'Remedy': remedy,
          'CMReportID': '0',
          'ShowSendEvalOrApprove': '0',
          'RepairDate': repairDate,
          'ReasonForNotClosingJob': reasonForNotClosingJob,
          'ActionTakenToClosePendingJob': actionTakenToClosePendingJob,
      },
    );
    // Rest of the code...
    try{
       print("Generate acheivment report response : ${response.body}");
    var json = jsonDecode(response.body);
    
    String responseMsg = "No connection made";
    if(response.statusCode == 200){
    if (json["success"] == true) {
       return json['CMReportID'].toString();
    } else {
      return json["Message"];
    }
    }
    else{
      return "connection_failed";
    }
    }catch(e){
      if(kDebugMode)
     rethrow;
      return "connection_failed";
       
    }
  }
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final format = DateFormat.Hm(); 
    return format.format(dt);
  } 
}

