import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/models/pending_work_order.dart';
import 'package:steady_solutions/screens/cm_pending_list/pending_wo_table_data_structure.dart';
import 'package:steady_solutions/screens/work_orders/achievment_report.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PendingOrdersList extends StatefulWidget {
  const PendingOrdersList({Key? key}) : super(key: key);

  @override
  State<PendingOrdersList> createState() => _PendingOrdersListState();
}

class _PendingOrdersListState extends State<PendingOrdersList> {
  final WorkOrdersController _workOrderController =
      Get.find<WorkOrdersController>();
  final AuthController _authController = Get.find<AuthController>();

  // Data to be sent to the server

  /// List after structuring it for the data grid
  Rx<PendingWorkOrderDataSource> _woListDataSource =
      PendingWorkOrderDataSource(woList: []).obs;

  void structureDataForDataGrid() async {
    _workOrderController.pendingWorkOrders = RxList<PendingWorkOrder>();
    await _workOrderController.fetchPendingOrders();
    _woListDataSource.value = PendingWorkOrderDataSource(
        woList: _workOrderController.pendingWorkOrders);

    /// Remove below in production
    // _workOrderController.fetchPendingOrders();
    // _woListDataSource.value =
    //     PendingWorkOrderDataSource(woList: generateRandomWorkOrders());
  }

  StreamSubscription<bool>? lisenter;
  @override
  void initState() {
    if (mounted) {
      if (lisenter != null) if (lisenter!.isPaused)
        lisenter = _workOrderController.isLoading.listen((value) {
          if (value) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
        });
    }

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
      'jobNumber': 320.w,
      'departmentDesc': 320.w,
      'controlNumber': 320.w,
      'failureDateTime': 300.w,
      'statusDesc': 450.w,
      'isUrgent': 290.w
    };
    TextStyle headerTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Colors.white, fontSize: 36.sp, fontWeight: FontWeight.bold);

    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          //ignored progress for the moment
          return const Center(
            child: SpinKitCubeGrid(
              color: Colors.red,
              size: 50.0,
            ),
          );
        },
        overlayColor: Colors.yellow.withOpacity(0.8),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
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
                                        .pending_work_orders_list,
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
              Expanded(
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
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)
                                                .work_orders_details ??
                                            '',
                                        style: dialogTitleTextStyle),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 40.h,
                                        ),
                                        Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
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
                                                        "${AppLocalizations.of(context).department}:",
                                                        style:
                                                            dialogValueTitlesDetailsTextStyle),
                                                    Text(
                                                        column[0]
                                                            .getCells()
                                                            .elementAt(1)
                                                            .value,
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
                                                        "${AppLocalizations.of(context).failure_date}:",
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
                                                        "${AppLocalizations.of(context).failure_time}:",
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
                                                        "${AppLocalizations.of(context).urgent}:",
                                                        style:
                                                            dialogValueTitlesDetailsTextStyle),
                                                    Text(
                                                        column[0]
                                                            .getCells()
                                                            .elementAt(5)
                                                            .value,
                                                        style:
                                                            dialogInnerDetailsTextStyle),
                                                  ]),
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
                                    actions: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              style: kSmallBtnStyle(context),
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
                                                  context),
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                          .close ??
                                                      ''),
                                            ),
                                          ],
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
                                maximumWidth: maxColumnWidths['jobNumber']!,
                                filterIconPosition:
                                    ColumnHeaderIconPosition.start,
                                columnName: 'jobNumber',
                                label: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).wo,
                                      // overflow: TextOverflow.clip,
                                    ))),
                            GridColumn(
                                maximumWidth:
                                    maxColumnWidths['departmentDesc']!,
                                columnName: 'departmentDesc',
                                label: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context)
                                          .department_subzone_1,
                                    ))),
                            GridColumn(
                                maximumWidth: maxColumnWidths['controlNumber']!,
                                columnName: 'controlNumber',
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
                                    maxColumnWidths['failureDateTime']!,
                                columnName: 'failureDateTime',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).f_date,
                                    ))),
                            GridColumn(
                                maximumWidth:
                                    maxColumnWidths['failureDateTime']!,
                                columnName: 'failureDateTime',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).f_time,
                                    ))),
                            GridColumn(
                                maximumWidth: maxColumnWidths['isUrgent']!,
                                columnName: 'isUrgent',
                                label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      style: headerTextStyle,
                                      AppLocalizations.of(context).urgent,
                                    ))),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
