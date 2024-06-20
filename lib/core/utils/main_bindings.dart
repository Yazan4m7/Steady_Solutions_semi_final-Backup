import 'package:get/get.dart';
import 'package:steady_solutions/controllers/achievement_report_controller.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/assets_management_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/controllers/notifications_controller.dart';
import 'package:steady_solutions/controllers/pm_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:http/http.dart' as http;
class MainBindings implements Bindings {

  @override
  void dependencies() {
    Get.put<ApiAddressController>(ApiAddressController());
    Get.put<AuthController>(AuthController());
    Get.put<DashboardController>(DashboardController());
    Get.put<WorkOrdersController>(WorkOrdersController());
    Get.put<AchievementReportsController>(AchievementReportsController());
    Get.put<AssetsManagementController>(AssetsManagementController());
    Get.put<PMController>(PMController());
    Get.put<NotificationsController>(NotificationsController());
    
  }


  void overloadAPI()async {
    final Map<String, String> params = {
      'EquipmentTypeID': '2',
      'UserID':'1',
      'Flag': '0',
      'ID':  '0',
    };
    print(params.toString());
    http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );

     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     http.get(
      Uri.parse(
        "http://oms-livedemo.com$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
  }
}
