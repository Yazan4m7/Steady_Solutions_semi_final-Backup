import 'dart:ui';

import 'package:flutter/material.dart';

class CalendarItem {
  String title;
  String cDesc;
  String start;
  String endDate;
  int statusID;
  int pMReportID;
  int companyID;
  String url;

  CalendarItem(
      {    required this.title,
    required this.cDesc,
    required this.start,
    required this.endDate,
    required this.statusID,
    required this.pMReportID,
    required this.companyID,
    required this.url,
    
      });



  factory CalendarItem.fromJson(Map<String, dynamic> json) {
    return CalendarItem(
      title: json['title'] ?? "n/a",
      cDesc: json['CDesc'] ?? "n/a",
      start: json['start'] ?? "n/a",
      endDate: json['endDate'] ?? "n/a",
      statusID: json['StatusID'] ?? "n/a",
      pMReportID: json['PMReportID'] ?? "n/a",
      companyID: json['CompanyID'] ?? "n/a",
      url: json['Url']  ?? "n/a",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['CDesc'] = this.cDesc;
    data['start'] = this.start;
    data['endDate'] = this.endDate;
    data['StatusID'] = this.statusID;
    data['PMReportID'] = this.pMReportID;
    data['CompanyID'] = this.companyID;
    data['Url'] = this.url;
    
    return data;
  }


}