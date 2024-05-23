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

class _DashboardState extends State<Dashboard>{
  final TooltipBehavior? _tooltipBehavior = TooltipBehavior(enable: true);
  final DashboardController _dashboardsController =
      Get.find<DashboardController>();
  @override
  initState() {
    super.initState();
  }

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
    AppSizes sizes = AppSizes(context);
    // if(_dashboardsController.dashboardWidgets.isEmpty){
    //   return Center(child: Text("Select an option from the drawer"));
    // }
    return SingleChildScrollView(
        padding: sizes.defaultPadding,
        child: Obx(
          () => _dashboardsController.dashboardWidgets.isEmpty ? Center(child: Text("Select an option from the drawer")): StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            //shrinkWrap: true,

            children: _dashboardsController.dashboardWidgets.keys.map((key) {
              print("Key: $key");
              return StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                
                child: key == "PM"
                    ? SfCircularChart(
                      
                        title:  ChartTitle(text: 'PM Performance',textStyle : Theme.of(context).textTheme.labelSmall,alignment: ChartAlignment.near),
                        legend: const Legend(
                          isVisible: false,
                          position: LegendPosition.bottom,
                          // ...
                        ),
                          annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Container( // Your custom center widget
                                  child: Text(
                                    _dashboardsController
                                        .dashboardWidgets["PM"]!.text ??"", 
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
                                    x: "Failed",
                                    y: _dashboardsController
                                        .dashboardWidgets["PM"]!.x,
                                        color: Color.fromARGB(255, 11, 115, 149)),
                                ChartData(
                                    x: "Success",
                                    y: _dashboardsController
                                        .dashboardWidgets["PM"]!.y,
                                        color: Color.fromARGB(255, 128, 184, 204))
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              pointColorMapper: (datum, index) =>   datum.color,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true, // Show data labels
                                labelPosition: ChartDataLabelPosition.inside,
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )
                          ])

                    // CircularChart(chartData:[
                    //  ChartData(text:"hi",x:"test",y: _dashboardsController.dashboardWidgets.value["PM"]!.x)
                    // ,ChartData(x:"test",y:_dashboardsController.dashboardWidgets.value["PM"]!.y)])

                    :  key == "CM" ? SfCircularChart(
                      
                        title:  ChartTitle(text: 'CM Performance',textStyle : Theme.of(context).textTheme.labelSmall,alignment: ChartAlignment.near),
                        legend: const Legend(
                          isVisible: false,
                          position: LegendPosition.bottom,
                          // ...
                        ),
                          annotations: <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Container( // Your custom center widget
                                  child: Text(
                                    _dashboardsController
                                        .dashboardWidgets["CM"]!.text ??"", 
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
                                    x: "Failed",
                                    y: _dashboardsController
                                        .dashboardWidgets["CM"]!.x,
                                        color: Color.fromARGB(255, 11, 115, 149)),
                                ChartData(
                                    x: "Success",
                                    y: _dashboardsController
                                        .dashboardWidgets["CM"]!.y,
                                        color: Color.fromARGB(255, 128, 184, 204))
                              ],
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              pointColorMapper: (datum, index) =>   datum.color,
                              dataLabelSettings: const DataLabelSettings(
                                isVisible: true, // Show data labels
                                labelPosition: ChartDataLabelPosition.inside,
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )
                          ])

                    // CircularChart(chartData:[
                    //  ChartData(text:"hi",x:"test",y: _dashboardsController.dashboardWidgets.value["PM"]!.x)
                    // ,ChartData(x:"test",y:_dashboardsController.dashboardWidgets.value["PM"]!.y)])

                     : const SizedBox(
                        child: Text("</>"),
                      ),
              );
            }).toList(),

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
