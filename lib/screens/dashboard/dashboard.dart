import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/core/data/app_sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/gps_mixin.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/charts_models.dart';
import 'package:steady_solutions/models/dashboard/chart_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:steady_solutions/controllers/notifications_controller.dart';
import 'package:card_swiper/card_swiper.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TooltipBehavior? _tooltipBehavior = TooltipBehavior(enable: true);
  static final DashboardController _dashboardsController =
      Get.find<DashboardController>();
  NotificationsController _notificationsController =
      Get.find<NotificationsController>();
  @override
  initState() {
    _notificationsController.fetchNotifications();
    _dashboardsController.loadSelectedWidgets();
    if (DashboardController.isDataLoaded.value)
      _dashboardsController.fetchChartsData();
    super.initState();
  }

  final Map<DashboardWidgets, Widget Function(BuildContext)> widgetBuilders = {
    DashboardWidgets.CMPerformanceChart: (context) =>
        CMPerformanceChart(context),
    DashboardWidgets.PMPerformanceChart: (context) =>
        PMPerformanceChart(context),
    DashboardWidgets.MTTRIndicator: (context) => MTTRContainer(context),
    DashboardWidgets.MTBFIndicator: (context) => MTBFContainer(context),
    DashboardWidgets.AvgDownTimeIndicator: (context) =>
        AvgDownTimeContainer(context),
    DashboardWidgets.WOByCategoryChart: (context) => WOByCategory(context),
    DashboardWidgets.WOByYearTable: (context) => WOByYearChart(context),
    DashboardWidgets.PartsConsumptionChart: (context) =>
        fetchPartsConsumption(context),
    DashboardWidgets.workingEquipmentIndicator: (context) =>
        workingEquipmentIndicator(context),
    DashboardWidgets.equipByClassChart: (context) => fetchEquipByClass(context),
  };
  List pmPerformanceCharts = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.yellow,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    // List selectedWidgetsCopy = _dashboardsController.selectedWidgets;
    List cmPerformanceCharts = [
      TitledChartContainer(
          child: CMPerformanceChart(context), title: "Performance"),
      TitledChartContainer(child: MTBFContainer(context), title: "MTBF"),
      TitledChartContainer(child: MTTRContainer(context), title: "MTTR"),
      TitledChartContainer(
          child: AvgDownTimeContainer(context), title: "Avg Down Time"),
      TitledChartContainer(
          child: WOByCategory(context), title: "W.O. By Category"),
      TitledChartContainer(
          child: WOByYearChart(context), title: "W.O. By Year"),
    ];
    List assetManagementCharts = [
      TitledChartContainer(
          child: workingEquipmentIndicator(context),
          title: "Working Equipemtn"),
      TitledChartContainer(
          child: fetchEquipByClass(context), title: "Equipment By Class"),
    ];
    List pmCharts = [
      TitledChartContainer(
          child: PMPerformanceChart(context), title: "Performance"),
    ];
    List stockManagementCharts = [
      TitledChartContainer(
          child: fetchPartsConsumption(context), title: "Parts Consum. /year"),
    ];
// MTTRContainer
// MTBFContainer
// AvgDownTimeContainer
// WOByCategory
// WOByYearChart
// workingEquipmentIndicator
// fetchPartsConsumption
// fetchEquipByClass
    // if (DashboardController.isDataLoaded.value)
    //   _dashboardsController.fetchChartsData();
    return SingleChildScrollView(
      //padding: sizes.defaultPadding,
      child: Obx(
        () {
          // selectedWidgetsCopy = _dashboardsController.selectedWidgets.toList();
          _dashboardsController.saveSelectedWidgets();
          return Column(children: [
            Row(
              mainAxisAlignment:  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(
                      "Welcome To Steady App!",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 100.sp),
                    ),
                  ),
                ),
                // IconButton(
                //     onPressed: () {}, icon: Icon(Icons.access_alarms_rounded,color: Colors.white,))
              ],
            ),
            SizedBox(height: 50.h,),
            Container(
            
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 3 * 0.2,
                      child: Row(
                        children: [
                          Text(
                            " CM Performance",
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )),
                 
                   
                     Expanded(
                       child: Swiper(
                        itemBuilder: (context, index) {
                          // final image = images[index];
                          return cmPerformanceCharts[index];
                        },
                        indicatorLayout: PageIndicatorLayout.COLOR,
                        // itemHeight: 100,
                        // itemWidth: 400,
                        autoplay: false,
                        itemCount: cmPerformanceCharts.length,
                        pagination: const SwiperPagination(
                            builder: SwiperPagination.rect),
                        control: const SwiperControl(size: 0),
                        outer: true,
                        fade: .0,
                        viewportFraction: 0.7,
                        scale: 0.9,
                                           ),
                     ),
                  
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              // padding: EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height / 3 * 0.2,
                      child: Row(
                        children: [
                          Text(
                            
                            " Stock Management",
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height / 3 * 0.7,
                    child: Swiper(
                      itemBuilder: (context, index) {
                        // final image = images[index];
                        return cmPerformanceCharts[index];
                      },
                      indicatorLayout: PageIndicatorLayout.COLOR,
                      // itemHeight: 100,
                      // itemWidth: 400,
                      autoplay: false,
                      itemCount: cmPerformanceCharts.length,
                      pagination: const SwiperPagination(
                          builder: SwiperPagination.rect),
                      control: const SwiperControl(size: 0),
                      outer: true,
                      fade: .0,
                      viewportFraction: 0.7,
                      scale: 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }

  static CMPerformanceChart(BuildContext context) {
    print("cm container");
    return Obx( ()=> _dashboardsController.dashboardWidgets["CM"] ==null ? SpinKitThreeBounce( color: Colors.blue, size: 50.w, ) : SfCircularChart(
          // title: ChartTitle(
          //     text: 'CM Performance',
          //     textStyle: Theme.of(context).textTheme.bodySmall,
          //     alignment: ChartAlignment.near),
          legend: const Legend(
            isVisible: false,
            position: LegendPosition.bottom,
            // ...
          ),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Container(
                // Your custom center widget
                child: Text(
                  "${_dashboardsController.dashboardWidgets["CM"]?.text ?? "0"}%",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          tooltipBehavior: TooltipBehavior(
            color: Colors.blueAccent,
            enable: true,
            duration: 500,
            // ...
          ),
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
              dataSource: [
                ChartData(
                    //text: "hi",
                    x: "Pending",
                    y: _dashboardsController.dashboardWidgets["CM"]?.x ?? 0.00,
                    color: Color.fromARGB(255, 11, 115, 149)),
                ChartData(
                    x: "Done",
                    y: _dashboardsController.dashboardWidgets["CM"]?.y ?? 0.00,
                    color: Color.fromARGB(255, 128, 184, 204))
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (datum, index) => datum.color,
              dataLabelSettings: DataLabelSettings(
                isVisible: true, // Show data labels
                labelPosition: ChartDataLabelPosition.inside,
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              ),
            )
          ]),
    );
  }

  static PMPerformanceChart(BuildContext context) {
    print("pm container");
    print("pm data :  ${_dashboardsController.dashboardWidgets["PM"]}");
    // if (_dashboardsController.dashboardWidgets["PM"]== null)
    // _dashboardsController.fetchCMPerformance(1);
    //_dashboardsController.toggleWidgetSelection(DashboardWidgets.CMPerformanceChart);
    return Obx(() => SfCircularChart(
          // title: ChartTitle(
          //   textStyle: Theme.of(context).textTheme.labelSmall,
          //   alignment: ChartAlignment.near,
          // ),
          legend: const Legend(
            isVisible: false,
            position: LegendPosition.bottom,
          ),
          annotations: <CircularChartAnnotation>[
            CircularChartAnnotation(
              widget: Container(
                child: Text(
                  "${_dashboardsController.dashboardWidgets["PM"]?.text}%",
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          tooltipBehavior: TooltipBehavior(
            color: Colors.blueAccent,
            enable: true,
            duration: 500,
          ),
          series: <CircularSeries>[
            DoughnutSeries<ChartData, String>(
              dataSource: [
                ChartData(
                  x: "Pending",
                  y: _dashboardsController.dashboardWidgets["PM"]?.x,
                  color: Color.fromARGB(255, 11, 115, 149),
                ),
                ChartData(
                  x: "Done",
                  y: _dashboardsController.dashboardWidgets["PM"]?.y,
                  color: Color.fromARGB(255, 128, 184, 204),
                ),
              ],
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (datum, index) => datum.color,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.inside,
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              ),
            ),
          ],
        ));
  }

  static MTTRContainer(BuildContext context) {
    //      if (_dashboardsController.dashboardWidgets["MTTR"]== null)
    // _dashboardsController.fetchMTTR();
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Obx(
          ()=> _dashboardsController.MTTR.value.isEmpty ?  SpinKitThreeBounce( color: Colors.blue, size: 50.w, )  : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "MTTR [H]",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.monitor_heart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Obx(() => Text(
                        _dashboardsController.MTTR.value,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ))
                ],
              ),
            ],
          ),
        ) ,
      ),
    );
  }

  static MTBFContainer(BuildContext context) {
    //   if (_dashboardsController.dashboardWidgets["MTBF"]== null)
    // _dashboardsController.fetchMTBF();
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MTBF [D]",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Obx(() => Text(
                    _dashboardsController.MTBF.value,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  static AvgDownTimeContainer(BuildContext context) {
    print("returning Avg down time container");
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Avg Down Time [D]",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  child: Obx(()=>
                    _dashboardsController.avgDownTime["avg"]!.isEmpty ?  SpinKitThreeBounce( color: Colors.blue, size: 50.w, )  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dashboardsController.avgDownTime["avg"]!,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.timer_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Min",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.green[700]),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            Text(
                              _dashboardsController.avgDownTime["min"]!,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Max",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: Colors.red),
                            ),
                            SizedBox(
                              width: 30.w,
                            ),
                            Text(
                              _dashboardsController.avgDownTime["max"]!,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  static WOByCategory(BuildContext context) {
    return SingleChildScrollView(
      child: SfCartesianChart(
        // title: ChartTitle(
        //     text: 'WO/Category',
        //     textStyle: Theme.of(context).textTheme.labelLarge,
        //     alignment: ChartAlignment.center),
        primaryXAxis: CategoryAxis(
          labelPosition: ChartDataLabelPosition.outside,
          labelIntersectAction: AxisLabelIntersectAction.rotate45,
          labelStyle: Theme.of(context).textTheme.labelSmall,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 100,
          interval: 25,
          majorGridLines: MajorGridLines(width: 1), // Hide major grid lines
        ),
        // isTransposed: true,
        series: <ColumnSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: _dashboardsController.byCategoryChartData != null
                ? _dashboardsController.byCategoryChartData!
                : [],
            xValueMapper: (ChartData data, _) => data.category, // Use category
            yValueMapper: (ChartData data, _) => data.jobCount, // Use job count
            dataLabelSettings: DataLabelSettings(isVisible: true),
            color: const Color.fromARGB(255, 38, 166, 79),
            borderRadius: BorderRadius.circular(0),
            width: 0.5,
          )
        ],
      ),
    );
  }

  static WOByYearChart(BuildContext context) {
    int total = 0;
    _dashboardsController.woByYearChartData.forEach((element) {
      total += element.WOCount!;
    });
    return SfCartesianChart(
      // title: ChartTitle(
      //     text: 'WO/Year',
      //     textStyle: Theme.of(context).textTheme.labelLarge,
      //     alignment: ChartAlignment.center),
      primaryXAxis: CategoryAxis(
        labelPosition: ChartDataLabelPosition.outside,
        labelIntersectAction: AxisLabelIntersectAction.rotate45,
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        maximum: 25,
        interval: 5,

        majorGridLines: MajorGridLines(width: 0), // Hide major grid lines
        labelFormat: '{value}',
      ),
      // isTransposed: true,
      series: <ColumnSeries<WOByYearChartData, String>>[
        ColumnSeries<WOByYearChartData, String>(
          dataSource: _dashboardsController.woByYearChartData,
          xValueMapper: (WOByYearChartData data, _) => data.monthName,
          yValueMapper: (WOByYearChartData data, _) => data.WOCount,
          dataLabelMapper: (WOByYearChartData data, _) =>
              "${data.WOCount} / ${(data.WOCount / total * 100).toStringAsFixed(0)}%",
          color: Color.fromARGB(255, 22, 36, 83),
          borderRadius: BorderRadius.circular(3),
          width: 0.5,
          dataLabelSettings: DataLabelSettings(
            isVisible: false,
          ),
        )
      ],
    );
  }

  static workingEquipmentIndicator(BuildContext context) {
    print("returning working eqcontainer");
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Working Equipment",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dashboardsController
                                      .workingEquipmentData["Working"] ??
                                  "...",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.timer_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Count all",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.green[700]),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Text(
                            _dashboardsController
                                    .workingEquipmentData["Working"] ??
                                "Loading..",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Condem count",
                            style: Theme.of(context).textTheme.labelMedium!,
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          Expanded(
                            child: _dashboardsController
                                        .workingEquipmentData["Condem"] ==
                                    null
                                ? Text("Loading...")
                                : Row(
                                    children: [
                                      Text(
                                        _dashboardsController
                                            .workingEquipmentData["Condem"]!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Text(
                                        _dashboardsController
                                            .workingEquipmentData["Condem"]!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  static fetchPartsConsumption(BuildContext context) {
    List<CartesianSeries<dynamic, dynamic>> list =
        <LineSeries<PartsConsumptionChartData, num>>[
      LineSeries<PartsConsumptionChartData, num>(
          dataSource: _dashboardsController.partsConsumptionChartData,
          xValueMapper: (PartsConsumptionChartData sales, _) => sales.costPrice,
          yValueMapper: (PartsConsumptionChartData sales, _) => sales.quantity,
          name: 'Quantity',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<PartsConsumptionChartData, num>(
          dataSource: _dashboardsController.partsConsumptionChartData,
          name: 'Cost Price',
          xValueMapper: (PartsConsumptionChartData sales, _) => sales.costPrice,
          yValueMapper: (PartsConsumptionChartData sales, _) => sales.costPrice,
          markerSettings: const MarkerSettings(isVisible: true))
    ];

    SfCartesianChart chart = SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
          text: 'Inventory Part Consumbtion',
          textStyle: Theme.of(context).textTheme.labelMedium),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: const NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 2,
          majorGridLines: MajorGridLines(width: 0)),
      primaryYAxis: const NumericAxis(
          labelFormat: '{value}%',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: list,
      tooltipBehavior: TooltipBehavior(enable: true),
    );

    return chart;
  }

  static fetchEquipByClass(BuildContext context) {
    var series1 = <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
          explode: true,
          dataSource: _dashboardsController.e_by_class,
          xValueMapper: (ChartSampleData data, _) => data.x as String,
          yValueMapper: (ChartSampleData data, _) => data.y,
          dataLabelMapper: (ChartSampleData data, _) => data.x,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            labelAlignment: ChartDataLabelAlignment.outer,
            useSeriesColor: true,
            showCumulativeValues: true,
            showZeroValue: false,
            borderColor: CupertinoColors.black,
            borderWidth: 1.0,
            overflowMode: OverflowMode.shift,
          ))
    ];
    return SfCircularChart(
      title: ChartTitle(
          text: 'Equipment By Class',
          textStyle: Theme.of(context).textTheme.labelLarge,
          alignment: ChartAlignment.center),
      series: series1,
      legend: Legend(
        padding: 10,
        isVisible: true,
        position: LegendPosition.auto,
        alignment: ChartAlignment.near,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
    );
  }
}

class TitledChartContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const TitledChartContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Child Widget
        // child,
    
        // Gradient Shadow Container
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              //   color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // gradient: LinearGradient(
              //   begin: Alignment.bottomCenter,
              //   end: Alignment.center,
              //   colors: [
              //     Color.fromARGB(255, 0, 0, 0).withOpacity(0.6), // Adjust opacity as needed
              //     Colors.transparent,
              //   ],
              // ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, left: 8.0, right: 8.0, bottom: 18.0),
              child: child,
            ),
          ),
        ),
    
        // Title Text
        Positioned(
          bottom: 10,
          left: 16,
          child: Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: primery_blue_grey_color,
                  )),
        ),
      ],
    );
  }
}
