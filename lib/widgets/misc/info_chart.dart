// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:steady_solutions/core/data/app_sizes.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// class InfoChart extends StatelessWidget {
//   InfoChart({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<PieChartSectionData> pieChartData = [
//       PieChartSectionData(
//         value: 25,
//        // color: pieChart1,
//         showTitle: false,
//         radius: 25,
//       ),
//       PieChartSectionData(
//         value: 20,
//        // color: pieChart2,
//         showTitle: false,
//         radius: 23,
//       ),
//       PieChartSectionData(
//         value: 10,
//        // color: pieChart3,
//         showTitle: false,
//         radius: 20,
//       ),
//       PieChartSectionData(
//         value: 15,
//        // color: pieChart4,
//         showTitle: false,
//         radius: 17,
//       ),
//       PieChartSectionData(
//         value: 70,
//       //  color: pieChart1.withOpacity(0.1),
//         showTitle: false,
//         radius: 15,
//       ),
//     ];

//     AppSizes sizes = AppSizes(context);
//     return SizedBox(
//       height: 200,
//       child: Stack(
//         children: [
//           PieChart(
//             PieChartData(
//               startDegreeOffset: -90,
//               sectionsSpace: 0,
//               centerSpaceRadius: 70,
//               sections: pieChartData,
//             ),
//           ),
//           Positioned.fill(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.sp.center,
//             children: [
//               SizedBox(
//                 height: sizes.defaultPaddingValue,
//               ),
//               Text(
//                 "64.0",
//                 style: Theme.of(context).textTheme.headline4!.copyWith(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       height: 0.5,
//                     ),
//               ),
//               Text(
//                 "of 199",
//               ),
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }
