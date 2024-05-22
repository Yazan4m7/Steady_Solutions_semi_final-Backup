import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:steady_solutions/models/dashboard/chart_data.dart';

class DashboardWidgetModel{


// label
  double? x;

// value
  double? y;
  

  // Another label (for pie chart, etc.)
  String? text;

  DashboardWidgetModel({this.x, this.y, this.text});


  DashboardWidgetModel.fromJson(Map<String, dynamic> json) {
    x = double.parse(json['success'][0].toString());
    y = double.parse(json['success'][1].toString());
    text = json['Rate'].toString();
  }
  
// List<ChartData> chartDataFromJson() {



//   // Map each element in 'success' to a ChartData object
//   return  [ChartData(
//       x: 'Success ${this.x}', // Label the slices as "Success 1", "Success 2", etc.
//       y: this.y,  // The numerical value from the JSON
//       //text: entry.value.toString(), // Optional: display the value as text
//      // color: Colors.primaries[index % Colors.primaries.length], // Optional: assign colors based on the index
//     )];
  
//   // Map<String, dynamic> toJson() {
//   //   final Map<String, dynamic> data = new Map<String, dynamic>();
//   //   data['success'] = this.success;
//   //   data['Rate'] = this.rate;
//   //   return data;
//   // }
// }
}