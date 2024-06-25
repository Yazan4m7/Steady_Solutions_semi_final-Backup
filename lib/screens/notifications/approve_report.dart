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
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/notifications_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/models/work_orders/achievement_report.dart';
import 'package:steady_solutions/models/work_orders/control_item_model.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/screens/notifications/notifications_screen.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ViewReport extends StatefulWidget {

  int forId1;
  int reportId;
  int notificationedTypeId;


  ViewReport(      {Key? key, required this.reportId, required this.notificationedTypeId,required this.forId1})
      : super(key: key);

  @override
  State<ViewReport> createState() => _ViewReportState();
}

class _ViewReportState extends State<ViewReport> with TickerProviderStateMixin {
  final WorkOrdersController _workOrderController =
      Get.find<WorkOrdersController>();
  final NotificationsController _notificationController =
      Get.find<NotificationsController>();
  Rx<AchievementReport> report = AchievementReport().obs;
  late AnimationController controller;
  String reponseMsg = "";
  @override
  void initState() {
    getReport();
    super.initState();
  }

  void getReport() async {
    print("report id is ${widget.reportId}");
    report.value =
        await _workOrderController.getAchievementReport(widget.reportId);
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
    final spinkit = SpinKitDoubleBounce(
        color: kPrimaryColor1Green, size: 50.0, controller: controller);
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF4e7ca2)),
          title: Text("${AppLocalizations.of(context).view_report}",
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
                      "Report : #${report.value.cMReportID}",style: Theme.of(context).textTheme.titleMedium,
                    )],),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 35.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        border: Border.all(color:primery_dark_blue_color,
                        width: 4.w ),
                        //color: Colors.white,
                        borderRadius: BorderRadius.circular(40.r),),
                      //color: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.r),
                      
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                             
                              ReportRow(
                                  title: AppLocalizations.of(context).fault_status,
                                  value: nullOrEmptyHandler(
                                      report.value.faultStatus.toString()),
                                  isEven: true),
                              ReportRow(
                                title: AppLocalizations.of(context).cm_report_id,
                                value: nullOrEmptyHandler(
                                    report.value.cMReportID?.toString()),
                                isEven: false,
                              ),
                              ReportRow(
                                title: AppLocalizations.of(context).job_no,
                                value:
                                    nullOrEmptyHandler(report.value.jobNO?.toString()),
                                isEven: true,
                              ),
                              ReportRow(
                                title: AppLocalizations.of(context).equip_name,
                                value: nullOrEmptyHandler(
                                    report.value.equipName?.toString()),
                                isEven: false,
                              ),
                              ReportRow(
                                  title: AppLocalizations.of(context).failure_date_time,
                                  value: nullOrEmptyHandler(
                                      report.value.failureDateTime?.toString()),
                                  isEven: true),
                              ReportRow(
                                title: AppLocalizations.of(context).caller,
                                value: nullOrEmptyHandler(
                                    report.value.callerName.toString()),
                                isEven: false,
                              ),
                              ReportRow(
                                title: AppLocalizations.of(context).failure_status,
                                value: nullOrEmptyHandler(
                                    report.value.faultStatus.toString()),
                                isEven: true,
                              ),
                              ReportRow(
                                title: AppLocalizations.of(context).remedy,
                                value:
                                    nullOrEmptyHandler(report.value.remedy?.toString()),
                                isEven: false,
                              ),
                            
                              ReportRow(
                                title: AppLocalizations.of(context)
                                    .reason_for_not_closing_job,
                                value: nullOrEmptyHandler(
                                    report.value.reasonForNotClosingJob?.toString()),
                                isEven: true,
                              ),
                             
                              ReportRow(
                                title: AppLocalizations.of(context)
                                    .action_taken_to_close_pending_job,
                                value: nullOrEmptyHandler(report
                                    .value.actionTakenToClosePendingJob
                                    ?.toString()),
                                isEven: false,
                              ),
                             
                              ReportRow(
                                title: AppLocalizations.of(context).travel_time,
                                value: nullOrEmptyHandler(
                                    report.value.travelTime?.toString()),
                                isEven: true,
                              ),
                             
                              ReportRow(
                                title: AppLocalizations.of(context).repaired_date,
                                value: nullOrEmptyHandler(
                                    report.value.repairDate?.toString()),
                                isEven: false,
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
            if (widget.reportId == 0 || widget.notificationedTypeId == 0) {
              Get.dialog(
                AlertDialog(
                  title: const Text('Error'),
                  content:
                      const Text("Report ID or Notification ID is missing"),
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
              reponseMsg=  await _notificationController.sendApproveOrEval(
                  reportId: widget.forId1,
                  repairDate: report.value.repairDate ?? "",
                  NotificationTypeId: widget.notificationedTypeId);

                  _handleRespnse(reponseMsg);
          },
          style: kPrimeryBtnNoPaddingStyle(context),
          child: Text(
            AppLocalizations.of(context).approve,
            style: GoogleFonts.nunitoSans(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w600,
                fontSize: screenSize.width * .04),
          ),
        ),
        ElevatedButton(
          onPressed: () async{
            // Notific id and report id is required by the ap
            if (widget.reportId == 0 || widget.notificationedTypeId == 0) {
              Get.dialog(
                AlertDialog(
                  title: const Text('Error'),
                  content:
                      const Text("Report ID or Notification ID is missing"),
                  actions: [
                    TextButton(
                      onPressed: ()  {
                        Get.back();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            } else
            print (report.value.repairDate);print (report.value.repairDate?.toString());
             reponseMsg=  await _notificationController.sendApproveOrEval(
                  reportId: widget.reportId,
                  repairDate:  report.value.repairDate?.toString() ??" XX" ,
                  NotificationTypeId: widget.notificationedTypeId);
                   _handleRespnse(reponseMsg);
          },
          style: kPrimeryBtnNoPaddingStyle(context).copyWith(backgroundColor: WidgetStateProperty .all<Color>(Color.fromARGB(255, 6, 52, 121))),
          child: Text(
            AppLocalizations.of(context).send_evaluation,
            style: GoogleFonts.nunitoSans(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w600,
                fontSize: screenSize.width * .04),
          ),
        )
      ],
    );
  }
  _handleRespnse(String responseMsg) {
    if (responseMsg.toLowerCase() == "success".toLowerCase()) { Dialogs.materialDialog(
                            color: Colors.white,
                            msg: AppLocalizations.of(context).approved_successfully,
                            title: AppLocalizations.of(context).success,
                            lottieBuilder: Lottie.asset(
                              kMainSuccessIconPath,
                              fit: BoxFit.contain,
                              repeat: false
                            
                            ),
                            // customView: Container(
                            //     child: Text(
                            //         "${AppLocalizations.of(context).approved_successfully}"),
                            //         ),
                            // customViewPosition:
                            //     CustomViewPosition.BEFORE_ACTION,
                            context: context,
                            actions: [
                              IconsButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  NotificationsScreen()));
                                },
                                text: AppLocalizations.of(context).close,
                                iconData: Icons.done,
                                color: Colors.blue,
                                textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                iconColor: Colors.white,
                              ),
                            ]);
      // _notificationController.markNotificationAsSeen(
      //         widget.forId1.toString(),
      //         widget.reportId.toString(),
      //         widget.notificationedTypeId.toString());
                  }
     
    else
 {
      Dialogs.materialDialog(
                            color: Colors.white,
                            msg: responseMsg,
                            title: AppLocalizations.of(context).failed,
                            lottieBuilder: Lottie.asset(
                              kMainSuccessIconPath,
                              fit: BoxFit.contain,
                              repeat: false
                            ),
                            // customView: Container(
                            //     child: Text(
                            //         "$responseMsg"),
                            //         ),
                            // customViewPosition:
                            //     CustomViewPosition.BEFORE_ACTION,
                            context: context,
                            actions: [
                              IconsButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                text: AppLocalizations.of(context).close,
                                iconData: Icons.done,
                                color: Colors.blue,
                                textStyle:  Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white,),
                                iconColor: Colors.white,
                              ),
                            ]);
    }

  
  
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
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text(value,style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
