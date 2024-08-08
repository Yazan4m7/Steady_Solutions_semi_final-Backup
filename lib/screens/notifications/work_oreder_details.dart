import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/achievement_report_controller.dart';
import 'package:steady_solutions/controllers/notifications_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/models/work_orders/WorkOrderDetails.dart';
import 'package:steady_solutions/models/work_orders/achievement_report.dart';

import 'package:steady_solutions/screens/notifications/notifications_screen.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkOrderDetailsScreen extends StatefulWidget {
  int workOrderId;
  String passedPar1;
  WorkOrderDetailsScreen({Key? key, required this.workOrderId,required this.passedPar1})
      : super(key: key);

  @override
  State<WorkOrderDetailsScreen> createState() => _WorkOrderDetailsScreenState();
}

class _WorkOrderDetailsScreenState extends State<WorkOrderDetailsScreen>
    with TickerProviderStateMixin {
  final WorkOrdersController _workOrderController =
      Get.find<WorkOrdersController>();
  final NotificationsController _notificationController =
      Get.find<NotificationsController>();
        final AchievementReportsController _reportsController =
      Get.find<AchievementReportsController>();
  Rx<WorkOrderDetails> woDetails = WorkOrderDetails().obs;
  late AnimationController controller;
  String reponseMsg = "";
  @override
  void initState() {
    getWorkOrderDetails();
    super.initState();
  }

  void getWorkOrderDetails() async {

     print("wo id is ${widget.workOrderId}");

     print("Work order detail screen : wo id is ${widget.workOrderId}");

    woDetails.value =
        await _reportsController.getWODetailsForNotification(widget.workOrderId.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Notification opened work order details ");
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    final spinkit = SpinKitDoubleBounce(
        color: kPrimaryColor1Green, size: 50.0, controller: controller);
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF4e7ca2)),
          title: Text("${AppLocalizations.of(context).work_orders_details}",
              style: GoogleFonts.nunitoSans(
                  color: kPrimeryColor2NavyDark, fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => _workOrderController.isLoading.value == true
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
                : Column(
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(
                      " ${AppLocalizations.of(context).job_no} # ${widget.workOrderId}",style: Theme.of(context).textTheme.titleMedium,
                    )],),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 35.w, vertical: 20.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: primery_dark_blue_color, width: 4.w),
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        //color: Colors.white,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.r),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                 ReportRow(
                                title:
                                    AppLocalizations.of(context).control_no,
                                value: nullOrEmptyHandler(
                                    woDetails.value.controlNo?.toString()),
                                isEven: false,
                              ),
                                ReportRow(
                                title: AppLocalizations.of(context).equip_name,
                                value: nullOrEmptyHandler(
                                    woDetails.value.equipName?.toString()),
                                isEven: false,
                              ),
                                    ReportRow(
                                  title: AppLocalizations.of(context)
                                      .failure_date_time,
                                  value: nullOrEmptyHandler(
                                      woDetails.value.failureDateTime?.toString()),
                                  isEven: true),
                              ReportRow(
                                  title:
                                      AppLocalizations.of(context).fault_status,
                                  value: nullOrEmptyHandler(
                                      woDetails.value.faultStatus.toString()),
                                  isEven: true),
                           
                              ReportRow(
                                title: AppLocalizations.of(context).caller,
                                value: nullOrEmptyHandler(
                                    woDetails.value.callerName?.toString()),
                                isEven: true,
                              ),
                            
                        ],
                          ),
                        ),
                      ),
                      _confirmationsButtons(context)
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  String nullOrEmptyHandler(String? value) {
    if (value == null || value.isEmpty || value == "") {
      return "Not set";
    } else {
      return value;
    }
  }

  Widget _confirmationsButtons(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            _notificationController.markNotificationAsSeen(
              ForID1: widget.workOrderId.toString(),
              PassedPar1: widget.passedPar1,
              NotificationTypeID: "22",

            );
          Get.back();
          Get.off(NotificationsScreen());
          
          },
          style: kPrimeryBtnNoPaddingStyle(context),
          child: Text(
            AppLocalizations.of(context).close,
            style: GoogleFonts.nunitoSans(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w600,
                fontSize: screenSize.width * .04),
          ),
        ),
     ],
    );
  }

}

class ReportRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isEven; // Flag for alternating colors

  const ReportRow({
    Key? key,
    required this.title,
    required this.value,
    required this.isEven,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: isEven ? Colors.grey[200] : Colors.grey[300],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[400]!,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
