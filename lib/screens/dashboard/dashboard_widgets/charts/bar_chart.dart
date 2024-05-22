import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steady_solutions/models/dashboard/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarChart extends StatefulWidget {
  const BarChart({super.key});

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  @override
    TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: 'hi', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackerBarChart();
  }

  /// Returns the bar chart .
  SfCartesianChart _buildTrackerBarChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Inventory Part Consumbtion By Current Year',textStyle: Theme.of(context).textTheme.labelSmall,),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
          majorGridLines: MajorGridLines(width: 0),
          title: AxisTitle(text:  'Hours'),
          minimum: 0,
          maximum: 10,
          majorTickLines: MajorTickLines(size: 0)),
      series: _getTrackerBarSeries(),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  /// Returns the lsit of chart series
  /// which need to render on the bar chart .
  List<BarSeries<ChartData, String>> _getTrackerBarSeries() {
    return <BarSeries<ChartData, String>>[
      BarSeries<ChartData, String>(
        dataSource: <ChartData>[
           ChartData(x: '-0.4', y: 0),
           ChartData(x: '-0.2', y: 0),
          ChartData(x: '0', y: 10),
        ],
        borderRadius: BorderRadius.circular(15),
        trackColor: const Color.fromRGBO(198, 201, 207, 1),

        /// If we enable this property as true,
        /// then we can show the track of series.
        isTrackVisible: true,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
        xValueMapper: (ChartData sales, _) => sales.x as String,
        yValueMapper: (ChartData sales, _) => sales.y,
      ),
    ];
  }

}