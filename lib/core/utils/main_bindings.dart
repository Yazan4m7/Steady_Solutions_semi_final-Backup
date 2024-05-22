import 'package:get/get.dart';
import 'package:steady_solutions/controllers/achievement_report_controller.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/assets_management_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/controllers/pm_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/core/services/local_storage.dart';

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

    
  }
}
