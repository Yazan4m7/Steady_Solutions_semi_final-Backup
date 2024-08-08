import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/pm_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/models/pending_work_order.dart';
import 'package:steady_solutions/models/pm/pending_pm_work_order.dart';
import 'package:steady_solutions/screens/cm_pending_list/pending_wo_table_data_structure.dart';
import 'package:steady_solutions/screens/work_orders/achievment_report.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'pm_pending_wo_table_data_structure.dart';

class PendingPMWorkOrdersList extends StatefulWidget {
  const PendingPMWorkOrdersList({Key? key}) : super(key: key);

  @override
  State<PendingPMWorkOrdersList> createState() => _PendingPMWorkOrdersListState();
}

class _PendingPMWorkOrdersListState extends State<PendingPMWorkOrdersList> {
  final WorkOrdersController _workOrderController =
      Get.find<WorkOrdersController>();
  final AuthController _authController = Get.find<AuthController>();
  final PMController _pmController =
      Get.find<PMController>();

  // Data to be sent to the server

  /// List after structuring it for the data grid
  Rx<PendingPMWorkOrderDataSource> _woListDataSource =
      PendingPMWorkOrderDataSource(woList: []).obs;

  void structureDataForDataGrid() async {
    _pmController.pendingPMWorkOrders = RxList<PendingPMWorkOrder>();
    await _pmController.fetchPMList();
    _woListDataSource.value = PendingPMWorkOrderDataSource(
        woList: _pmController.pendingPMWorkOrders);

    /// Remove below in production
    // _workOrderController.fetchPendingOrders();
    // _woListDataSource.value =
    //     PendingWorkOrderDataSource(woList: generateRandomWorkOrders());
  }

  StreamSubscription<bool>? lisenter;
  @override
  void initState() {
   // if (mounted) {
      if (lisenter != null) 
        lisenter = _pmController.isLoading.listen((value) {
          print("listner : $value");
          if (value) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
        });
   //}

    structureDataForDataGrid();
    super.initState();
  }

  @override
  void dispose() {
    lisenter?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    Map<String, double> maxColumnWidths = {
      'jobNO': 220.w,
      'equipName': 450.w,
      'controlNo': 320.w,
      'dateOfJob': 300.w,
      'categoryName': 350.w,
      'reportID': 290.w,
      'statusDesc2': 290.w,
      'reasonForNotClosingJob': 390.w
    };
    TextStyle headerTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Colors.white, fontSize: 36.sp, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Obx(
                ()=>_pmController.isLoading.value ? Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white, child: Container(
                     height: MediaQuery.of(context).size.height,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      SpinKitWaveSpinner(color: secondary_dark_blue, size:100.0,),
                      Text("Please wait",style: TextStyle(color:secondary_dark_blue),)
                    ],
                  ),),) : Container(
                    color: Colors.blueGrey,
                    child: Stack(
                      children: [
                        Positioned(
                            child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Get.back(),
                        )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .pending_pm_work_orders_list,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.bold))),
                            Container(
                              child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                      AppLocalizations.of(context)
                                          .double_check_to_sort_click_to_generate_report,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold))),
                            ),
                             Container(
                              child: Center(
                                  child: Obx(()=>
                                     Text(
                                      textAlign: TextAlign.center,
                                        "Total : ${_woListDataSource.value.dataGridRows.length.toString()}",
                                            
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            Obx(
              ()=> _pmController.isLoading.value ? Container(child: Center(child: LinearProgressIndicator(minHeight: 30.h,color: secondary_dark_blue,)),) : Expanded(
                flex: 20,
                child: SfDataGridTheme(
                  data: const SfDataGridThemeData(
                    
                      //sortIcon: SizedBox(width: 0, height: 0),
                      gridLineColor: Color(0xFF3E3E3E),
                      gridLineStrokeWidth: 1.0,
                      filterIconColor: Colors.blueGrey,
                      filterIconHoverColor: Colors.purple,
                      sortIconColor: Colors.blueGrey,
                      sortIcon: SizedBox(),
                      headerColor: Color(0xFF383838),
                      headerHoverColor: Colors.yellow),
                  child: Obx(
                    () => Container(
                      color: Colors.white,
                      child: SfDataGrid(
                    
                          //frozenColumnsCount: 1,
                    
                          // defaultColumnWidth: 150.0.w,
                          sortingGestureType: SortingGestureType.doubleTap,
                          headerRowHeight:
                              MediaQuery.of(context).size.width / 9,
                          allowFiltering: true,
                          allowSorting: true,
                          source: _woListDataSource.value,
                          onSelectionChanged: (List<DataGridRow> column,
                              List<DataGridRow> row) {
                                  showCupertinoDialog (
                                   
                                  context: context,
                                  builder: (BuildContext context)  {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)
                                                .work_orders_details 
                                          ,
                                        style: dialogTitleTextStyle),
                                    content: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                       
                                        children: [
                                          SizedBox(
                                            height: 40.h,
                                          ),
                                          Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            AppLocalizations.of(
                                                                    context)
                                                                .job_no,
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                        Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(0)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                                    Text(
                                                            "${AppLocalizations.of(context).equip_name}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                        Text(
                                                          
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(1)
                                                                .value,
                                                                textAlign: TextAlign.center,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                     
                                                        Text(
                                                            "${AppLocalizations.of(context).control_number}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                        Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(2)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                                   Text(
                                                            "${AppLocalizations.of(context).date}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                        Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(3)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                                 Text(
                                                            "${AppLocalizations.of(context).category}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                                 Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(4)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                                Text(
                                                            "${AppLocalizations.of(context).report_id}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                        Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(5)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                     
                                                    
                                                        Text(
                                                            "${AppLocalizations.of(context).status_desc}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                        Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(6)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                       
                                                                Text(
                                                            "${AppLocalizations.of(context).reason_for_not_closing_job}:",
                                                            style:
                                                                dialogValueTitlesDetailsTextStyle),
                                                                Text(
                                                            column[0]
                                                                .getCells()
                                                                .elementAt(7)
                                                                .value,
                                                            style:
                                                                dialogInnerDetailsTextStyle),
                                                       
                                                      ]),
                                                ),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [])
                                              ]),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                style: kSmallBtnStyle(context).copyWith(
                                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                                                horizontal: MediaQuery.of(context).size.width * .03,
                                                vertical: MediaQuery.of(context).size.height * .01)
                                                )),
                                                onPressed: () {
                                                  if (_authController
                                                      .checkedIn.value)
                                                    Get.to(() =>
                                                        NewAchievementReportFrom(
                                                            jobNum:
                                                                "${column[0].getCells().elementAt(0).value}"));
                                                  else {
                                                    Get.back();
                                                  }
                                                },
                                                child: Text(_authController
                                                        .checkedIn.value
                                                    ? AppLocalizations.of(context)
                                                        .generate_achiev_report
                                                    : " Youre not checked in"),
                                              ),
                                              ElevatedButton(
                                                style: kSmallSecondaryBtnStyle(
                                                    context).copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.white60),
                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                            .close ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                
                      });
                          },
                          selectionMode: SelectionMode.single,
                          allowMultiColumnSorting: true,
                          columnWidthMode: ColumnWidthMode.fitByColumnName,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          showColumnHeaderIconOnHover: true,
                          columns: [
                            GridColumn(
                                maximumWidth: maxColumnWidths['jobNO']!,
                                filterIconPosition:
                                    ColumnHeaderIconPosition.start,
                                columnName: 'jobNO',
                                label: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).job_no,
                                      // overflow: TextOverflow.clip,
                                    ))),
                            GridColumn(
                                maximumWidth:
                                    maxColumnWidths['equipName']!,
                                columnName: 'equipName',
                                label: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context)
                                          .asset_name,
                                    ))),
                            GridColumn(
                                maximumWidth: maxColumnWidths['controlNo']!,
                                columnName: 'controlNo',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).asset_number,
                                    ))),
                            GridColumn(
                                maximumWidth:
                                    maxColumnWidths['dateOfJob']!,
                                columnName: 'dateOfJob',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).date,
                                    ))),
                            GridColumn(
                                maximumWidth:
                                    maxColumnWidths['categoryName']!,
                                columnName: 'categoryName',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).category,
                                    ))),
                            GridColumn(
                                maximumWidth: maxColumnWidths['reportID']!,
                                columnName: 'reportID',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).report_id,
                                    ))),
                                     GridColumn(
                                maximumWidth: maxColumnWidths['statusDesc2']!,
                                columnName: 'statusDesc2',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).status_desc,
                                    ))),
                                     GridColumn(
                                maximumWidth: maxColumnWidths['reasonForNotClosingJob']!,
                                columnName: 'reasonForNotClosingJob',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).reason_for_not_closing_job,
                                    ))),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
