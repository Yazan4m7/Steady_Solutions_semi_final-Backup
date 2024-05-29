import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:steady_solutions/models/dashboard/chart_data.dart';
import 'package:steady_solutions/screens/dashboard/dashboard_widgets/charts/bar_chart.dart';
import 'package:steady_solutions/screens/dashboard/dashboard_widgets/categories_grid/categories_grid.dart';
import 'package:steady_solutions/screens/dashboard/dashboard_widgets/charts/circular_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  Dashboard({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TooltipBehavior? _tooltipBehavior = TooltipBehavior(enable: true);
  static final  DashboardController _dashboardsController =
      Get.find<DashboardController>();
  @override
  initState() {
    _dashboardsController.loadSelectedWidgets();
    super.initState();
  }

final Map<DashboardWidgets, Widget Function(BuildContext)> widgetBuilders = {
  DashboardWidgets.CMPerformanceChart: (context) => CMPerformanceChart(context),
    DashboardWidgets.PMPerformanceChart : (context) => PMPerformanceChart(context),
  DashboardWidgets.MTTRIndicator : (context) => MTTRContainer(context),
  DashboardWidgets.MTBFIndicator : (context) => MTBFContainer(context),
  DashboardWidgets.AvgDownTimeIndicator : (context) => AvgDownTimeContainer(context),


  // DashboardWidgets.WOByCategoryChart : (context) => CMPerformanceChart(context),
  // DashboardWidgets.WOByYearTable : (context) => CMPerformanceChart(context),
  // DashboardWidgets.PartsConsumptionChart : (context) => CMPerformanceChart(context),
  // DashboardWidgets.workingEquipmentIndicator : (context) => CMPerformanceChart(context),
};

  @override
  Widget build(BuildContext context) {
     
    List<String> elements = readDashboardElementsList();
    final currentCount = (MediaQuery.of(context).size.width ~/ 250).toInt();
    crossAxisCount:
    (MediaQuery.of(context).size.width ~/ 250).toInt();
    late String _selectedTooltipPosition;
    late TooltipPosition _tooltipPosition;
    late double duration;
    final minCount = 4;
    final List<ChartData> chartData = [
      ChartData(x: 'David', y: 25, color: const Color.fromRGBO(9, 0, 136, 1)),
      ChartData(x: 'Steve', y: 38, color: const Color.fromRGBO(147, 0, 119, 1)),
      ChartData(x: 'Jack', y: 34, color: const Color.fromRGBO(228, 0, 124, 1)),
      ChartData(
          x: 'Others', y: 52, color: const Color.fromRGBO(255, 189, 57, 1))
    ];
     print("build selectedWidgetsCopy ${_dashboardsController.selectedWidgets}");
    List selectedWidgetsCopy = _dashboardsController.selectedWidgets;
      print("build selectedWidgetsCopy $selectedWidgetsCopy");
     
    return SingleChildScrollView(
        //padding: sizes.defaultPadding,
        child: Obx(
            () {
              selectedWidgetsCopy = _dashboardsController.selectedWidgets.toList();
              print("build selectedWidgetsCopy $selectedWidgetsCopy");
               _dashboardsController.saveSelectedWidgets();
              Future.delayed(Duration(seconds: 2), () {
                
              });
              return selectedWidgetsCopy.isEmpty
                  ? Center(child: Text("Select an option from the drawer"))
                  : StaggeredGrid.count(
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: selectedWidgetsCopy.map((widgetType) {
                        print("widType $widgetType");
                        return widgetBuilders[widgetType]!(context);
                      }).toList(),
                    );
            },

              //           [

              // StaggeredGridTile.count(
              //   crossAxisCellCount: 2,
              //   mainAxisCellCount: 2,
              //   child: CircularChart(chartData: chartData,),
              // ),

              // StaggeredGridTile.count(
              //   crossAxisCellCount: 2,
              //   mainAxisCellCount: 2,
              //   child: SfCircularChart(
              //                     series: <CircularSeries>[
              //                         // Renders doughnut chart
              //                         DoughnutSeries<ChartData, String>(
              //                             dataSource: chartData,
              //                             pointColorMapper:(ChartData data,  _) => data.color,
              //                             xValueMapper: (ChartData data, _) => data.x,
              //                             yValueMapper: (ChartData data, _) => data.y
              //                         )
              //                     ]
              //                 ),
              // ),

              //   StaggeredGridTile.count(
              //     crossAxisCellCount:2,
              //     mainAxisCellCount: 2,
              //     child:  SfCartesianChart(
              //     plotAreaBorderWidth: 0,
              //     title: ChartTitle(
              //         text: 'Work Orders By Current Year',textStyle: Theme.of(context).textTheme.labelSmall),
              //     primaryXAxis: const CategoryAxis(
              //       majorGridLines: MajorGridLines(width: 0),
              //     ),
              //     primaryYAxis: const NumericAxis(
              //         axisLine: AxisLine(width: 0),
              //         labelFormat: '{value}%',
              //         majorTickLines: MajorTickLines(size: 0)),
              //     series: _getDefaultColumnSeries(),
              //     tooltipBehavior: _tooltipBehavior,
              //   ),
              //   ),

              //   StaggeredGridTile.count(
              //     crossAxisCellCount: 2,
              //     mainAxisCellCount: 2,
              //     child: SfCircularChart(
              //     title: ChartTitle(
              //         text: 'PM Performance'),
              //     legend: Legend(
              //         isVisible:  true,
              //         overflowMode: LegendItemOverflowMode.wrap),
              //     series: _getPieSeries(),

              //     /// To enabe the tooltip and its behaviour.
              //     tooltipBehavior: TooltipBehavior(
              //       enable: true,
              //       tooltipPosition: TooltipPosition.pointer,
              //       duration: 2 * 1000,
              //     ),
              //   ),
              //   ),

              //   StaggeredGridTile.count(
              //       crossAxisCellCount: 4, mainAxisCellCount: 2, child: BarChart()),

              //   StaggeredGridTile.count(
              //     crossAxisCellCount: 4,
              //     mainAxisCellCount: 4,
              //     child: StylingDataGrid(),
              //   ),
              // ],
            ),
    
    );
  }

  static StaggeredGridTile CMPerformanceChart(BuildContext context) {
       print("cm container");
    //  if (_dashboardsController.dashboardWidgets["CM"]== null)
    // _dashboardsController.fetchCMPerformance(2);
  //    _dashboardsController.toggleWidgetSelection(DashboardWidgets.PMPerformanceChart);
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: SfCircularChart(
            title: ChartTitle(
                text: 'CM Performance',
                textStyle: Theme.of(context).textTheme.labelSmall,
                alignment: ChartAlignment.near),
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
                      y: _dashboardsController.dashboardWidgets["CM"]?.x ??  0.00,
                      color: Color.fromARGB(255, 11, 115, 149)),
                  ChartData(
                      x: "Done",
                      y: _dashboardsController.dashboardWidgets["CM"]?.y ??  0.00,
                      color: Color.fromARGB(255, 128, 184, 204))
                ],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                pointColorMapper: (datum, index) => datum.color,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true, // Show data labels
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ]),
      ),
    );
  }

  static StaggeredGridTile PMPerformanceChart(BuildContext context) {
    print("pm container");
    print("pm data :  ${_dashboardsController.dashboardWidgets["PM"]}");
    // if (_dashboardsController.dashboardWidgets["PM"]== null)
    // _dashboardsController.fetchCMPerformance(1);
   //_dashboardsController.toggleWidgetSelection(DashboardWidgets.CMPerformanceChart);
    return StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Obx(()=>
           SfCircularChart(
            title: ChartTitle(
              text: 'PM Performance',
              textStyle: Theme.of(context).textTheme.labelSmall,
              alignment: ChartAlignment.near,
            ),
            legend: const Legend(
              isVisible: false,
              position: LegendPosition.bottom,
            ),
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Container(
                  child: Text(
                    "${_dashboardsController.dashboardWidgets["PM"]?.text}%"?? "",
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
                    y: _dashboardsController.dashboardWidgets["PM"]?.x ?? 0.00,
                    color: Color.fromARGB(255, 11, 115, 149),
                  ),
                  ChartData(
                    x: "Done",
                    y: _dashboardsController.dashboardWidgets["PM"]?.y ?? 0.00,
                    color: Color.fromARGB(255, 128, 184, 204),
                  ),
                ],
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                pointColorMapper: (datum, index) => datum.color,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.inside,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
        ),
      );
   
 
  }

  static StaggeredGridTile MTTRContainer(BuildContext context) {
    //      if (_dashboardsController.dashboardWidgets["MTTR"]== null)
    // _dashboardsController.fetchMTTR();
    return StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Column(
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
                    Obx(()=>
                       Text(
                        _dashboardsController.MTTR.value,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  static StaggeredGridTile MTBFContainer(BuildContext context) {
    //   if (_dashboardsController.dashboardWidgets["MTBF"]== null)
    // _dashboardsController.fetchMTBF();
    return StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 1,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                    Obx(()=>
                       Text(
                        _dashboardsController.MTBF.value,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  static StaggeredGridTile AvgDownTimeContainer(BuildContext context) {
    print("returning Avg down time container");
    return StaggeredGridTile.count(
        crossAxisCellCount: 2,
        mainAxisCellCount: 2,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dashboardsController.avgDownTime["avg"]!,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
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
          ),
        ));
  }

  List<PieSeries<ChartData, String>> _getPieSeries() {
    return <PieSeries<ChartData, String>>[
      PieSeries<ChartData, String>(
          dataSource: <ChartData>[
            ChartData(x: 'Argentina', y: 505370, text: '45%'),
            ChartData(x: 'Belgium', y: 551500, text: '53.7%'),
            ChartData(x: 'Cuba', y: 312685, text: '59.6%'),
            // ChartData(x: 'Dominican Republic', y: 350000, text: '72.5%'),
            // ChartData(x: 'Egypt', y: 301000, text: '85.8%'),
            // ChartData(x: 'Kazakhstan', y: 300000, text: '90.5%'),
            // ChartData(x: 'Somalia', y: 357022, text: '95.6%')
          ],
          xValueMapper: (ChartData data, _) => data.x as String,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) => data.x as String,
          startAngle: 100,
          endAngle: 50,
          //pointRadiusMapper: (ChartData data, _) => data.text,
          dataLabelSettings: const DataLabelSettings(
              isVisible: true, labelPosition: ChartDataLabelPosition.outside))
    ];
  }

  List<ColumnSeries<ChartData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        dataSource: <ChartData>[
          // ChartData(x: 'China', y: 0.541),
          ChartData(
              x: '${DateTime.now().month.toString().padLeft(2, '0')}',
              y: 0.541),
          ChartData(x: 'Brazil', y: 0.818),
          // ChartData(x: 'Bolivia', y:1.51),
          //ChartData(x:'Mexico',   y: 1.302),
          //ChartData(x: 'Egypt',   y: 2.017),
          // ChartData(x:'Mongolia', y:1.683),
        ],
        xValueMapper: (ChartData sales, _) => sales.x as String,
        yValueMapper: (ChartData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }
}
