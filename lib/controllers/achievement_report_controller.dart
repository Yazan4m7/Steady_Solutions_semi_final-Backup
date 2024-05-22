import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/job_for_achievement.dart';

class AchievementReportsController extends GetxController {
  static AchievementReportsController get instance => Get.find();
  final AuthController _authController = Get.find<AuthController>();

  RxMap<String, ControlItemFromAchievement> controlItems =
      <String, ControlItemFromAchievement>{}.obs;
  Rx<ControlItemFromAchievement> selectedControlItem =
      ControlItemFromAchievement().obs;
  Rx<bool> isLoading = false.obs;

  Future<void> getWOJobINfo(String jobNumber) async {
    print("wo number");
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'JobNo': jobNumber,
    };

    try {
      final response = await http.get(
          Uri.parse("http://${storageBox.read('api_url')}$getWOJobInfoEndPoint")
              .replace(queryParameters: params));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("wo response: $data");
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
       required String travelTime,
    required String remedy,
       String repairDate="",
      String? startTime,
      String? endTime,
   
    required String reasonForNotClosingJob,
    required String actionTakenToClosePendingJob,
  }) async {
    final response = await http.post(
        Uri.parse(
          "http://${storageBox.read('api_url')}$createAchievementReportEndPoint",
        ),
        body: {
          'JobNo': jobNumber,
          'UserID': storageBox.read("id").toString(),
          'EquipmentTypeID': storageBox.read("role").toString(),

          /// MAIGHT CHANGE  :
          'StartDate': repairDate,
          'EndDate': repairDate,


          'StartTime': startTime,
          'EndTime': endTime, 
          'TravelTime': travelTime,
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
    var json = jsonDecode(response.body);
    String responseMsg = "No connection made";
    if(response.statusCode == 200){
    if (json["success"] == true) {
       return json['CMReportID'].toString();
    } else {
      return "failed_to_create_report";
    }
    }
    else{
      return "connection_failed";
    }
    }catch(e){
  //rethrow;
      return "connection_failed";
       
    }
  }
}

