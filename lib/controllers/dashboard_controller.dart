import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/dashboard/dashboard_widget.dart';
import 'package:steady_solutions/models/dashboards/pm_cm_performance.dart';
import 'dart:convert';

import 'package:steady_solutions/screens/home_screen.dart';

class DashboardController extends GetxController {
  RxMap<String, dynamic> dashboardWidgets = <String, dynamic>{}.obs;
  final selectedWidgets = <DashboardWidgets>[].obs;

  RxMap<String, bool> loading = <String, bool>{
    'PM': false,
    'CM': false,
    "MTTR": false,
    "MTBF": false,
    "AvgDownTime": false,
  }.obs;
  RxMap<String, String> avgDownTime = <String, String>{
    'avg': "00:00",
    "min": "00:00",
    "max": "00:00",
  }.obs;
  RxMap<String, String> WOByYear = <String, String>{
    "Jan": "14",
    "Feb": "21",
    "Mar": "18",
    "Apr": "16",
    "May": "21",
    "Jun": "6",
    "Jul": "6",
    "Aug": "12",
    "Sep": "14",
    "Oct": "28",
    "Nov": "15",
    "Dec": "23"
  }.obs;
  Rx<DashboardWidgetModel> pmPerformance = DashboardWidgetModel().obs;
  Rx<DashboardWidgetModel> cmPerformance = DashboardWidgetModel().obs;
  Rx<String> MTTR = "".obs;
  Rx<String> MTBF = "".obs;

  @override
  onInit() {
 
    super.onInit();
    _fetchChartsData();
  }

  void _fetchChartsData() async{
    await fetchCMPerformance(1);
    await fetchCMPerformance(2);
    await fetchMTTR();
    await fetchMTBF();
    await fetchAvgDownTime();
  //   await fetchWObyCategory();
  //   await fetchPartsConsumption();
  //   await workingEquipment();
  //  await equipByClass();
  }

  void toggleWidgetSelection(DashboardWidgets type) {
    if (selectedWidgets.contains(type)) {
      selectedWidgets.remove(type);
    } else {
      selectedWidgets.add(type);
    }
    saveSelectedWidgets();
  }
    void addSelectedWidget(DashboardWidgets type) {

      selectedWidgets.add(type);
    
    saveSelectedWidgets();
  }

  void saveSelectedWidgets() {
    List<String> widgetNames =
        selectedWidgets.map((widget) => widget.name).toList();
        print("saved $widgetNames");
    storageBox.write('selectedWidgets', widgetNames);
  }

  void loadSelectedWidgets() {
    List<dynamic>? widgetNames = storageBox.read('selectedWidgets');
    print("widgetNames: $widgetNames");
    if (widgetNames != null) {
      selectedWidgets.value = widgetNames
          .map((name) =>
              DashboardWidgets.values.firstWhere((e) => e.name == name))
          .toList();
    }
    print(selectedWidgets);
  }

  // Function to fetch data for a specific ID
  Future<void> fetchCMPerformance(int type) async {
  
    // 1= PM , 2= CM
    if (type == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      loading['PM'] = true;
      });
    
     
    }
    if (type == 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
      loading['CM'] = true;
       });
       
    }
    // ignore: unused_local_variable
    Rx<bool> isLoading = true.obs;
    final Map<String, String> params = {
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
      String url = type == 1
          ? "http://${storageBox.read('api_url')}$getPMPerformanceChartEndPoint"
          : "http://${storageBox.read('api_url')}$getCMPerformanceChartEndPoint";
      print(Uri.parse(url).replace(queryParameters: params));
      final response =
          await http.get(Uri.parse(url).replace(queryParameters: params));

      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (type == 1) {
          pmPerformance.value = DashboardWidgetModel.fromJson(data);
          dashboardWidgets["PM"] = pmPerformance.value;
        } else {
          cmPerformance.value = DashboardWidgetModel.fromJson(data);
          dashboardWidgets["CM"] = cmPerformance.value;
        }
        DashboardWidgetModel value = DashboardWidgetModel.fromJson(data);
        print("FALSE");
        loading['PM'] = false;
        loading['CM'] = false;
      } else {
        print("FALSE2");
        loading['PM'] = false;
        loading['CM'] = false;
        Get.snackbar("Error 010",
            "Server resposned with status code ${response.statusCode}");
      }
      print("FALSE3");
      loading['PM'] = false;
      loading['CM'] = false;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.to(HomeScreen());
      }
    }
     if (type == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      loading['PM'] = false;
    
      });
    
        
    }
    if (type == 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
      loading['CM'] = false;
   
       });
        
    }
    //storageBox.write("dashboardWidgets", dashboardWidgets);
  }

  Future<void> fetchMTTR() async {
         WidgetsBinding.instance.addPostFrameCallback((_) {
    loading['MTTR'] = true;
 });
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
      final response = await http.get(
          Uri.parse("http://${storageBox.read('api_url')}$getMTTREndPoint")
              .replace(queryParameters: params));

      print(" MTTR Response : " + response.body);
      if (response.statusCode == 200) {
        final String time = jsonDecode(response.body)["MTTRVal"];
        MTTR.value = time;
        dashboardWidgets["MTTR"] = time;
      } else {
        loading['MTTR'] = false;
        Get.snackbar("Error 011",
            "Server resposned with status code ${response.statusCode}");
      }

      loading['MTTR'] = false;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 011", "(MTTR) Exep. in MTTR data fetching");
        Get.to(HomeScreen());
      }
    }
    // Future.delayed(Duration(seconds: 2), () {
    //  dashboardWidgets["MTTR"]  = "2";
    //   loading['MTTR'] = false;
    // });
    //storageBox.write("dashboardWidgets", dashboardWidgets)
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  // toggleWidgetSelection(DashboardWidgets.MTTRIndicator); // Or your update logic
  //   });
  }

  Future<void> fetchMTBF() async {
    // 1= PM , 2= CM
         WidgetsBinding.instance.addPostFrameCallback((_) {
    loading['MTBF'] = true;
 });
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
      print(Uri.parse("http://${storageBox.read('api_url')}$getMTBFEndPoint")
          .replace(queryParameters: params));
      final response = await http.get(
          Uri.parse("http://${storageBox.read('api_url')}$getMTBFEndPoint")
              .replace(queryParameters: params));

      print(" MTBF Response : " + response.body);
      if (response.statusCode == 200) {
        final String time = jsonDecode(response.body)["MTBFVal"];
        MTBF.value = time;
        dashboardWidgets["MTBF"] = time;
      } else {
        loading['MTBF'] = false;
        Get.snackbar("Error 012",
            "Server resposned with status code ${response.statusCode}");
      }

      loading['MTBF'] = false;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 012", "(MTBF) Exep. in MTBF data fetching");
        Get.to(HomeScreen());
      }
    }
    // Future.delayed(Duration(seconds: 2), () {
    //  dashboardWidgets["MTBF"]  = "3";
    //   loading['MTBF'] = false;
    // });
    //storageBox.write("dashboardWidgets", dashboardWidgets);
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      // toggleWidgetSelection(DashboardWidgets.MTBFIndicator);
      // });
  }

  Future<void> fetchAvgDownTime() async {
    print("fetching AvgDownTime");
         WidgetsBinding.instance.addPostFrameCallback((_) {
    loading['AvgDownTime'] = true;
 });
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
      print(Uri.parse(
              "http://${storageBox.read('api_url')}$getAvgDownTimeEndPoint")
          .replace(queryParameters: params));
      final response = await http.get(Uri.parse(
              "http://${storageBox.read('api_url')}$getAvgDownTimeEndPoint")
          .replace(queryParameters: params));

      print(" getAvgDownTime Response : " + response.body);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        avgDownTime["avg"] = json["DownTimeVal"];
        avgDownTime["min"] = json["MinDownTimeVal"];
        avgDownTime["max"] = json["MaxDownTimeVal"];
        print(avgDownTime["avg"].toString() +
            " " +
            avgDownTime["min"].toString() +
            " " +
            avgDownTime["max"].toString());
        dashboardWidgets["AvgDownTime"] = true;
      } else {
        loading['AvgDownTime'] = false;
        Get.snackbar("Error 013",
            "Server resposned with status code ${response.statusCode}");
      }

      loading['AvgDownTime'] = false;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 013", "(AVG DOWN TIME) Exep. in AVGDT data fetching");
        Get.to(HomeScreen());
      }
    }
    ;
    //  toggleWidgetSelection(DashboardWidgets.AvgDownTimeIndicator);
    //storageBox.write("dashboardWidgets", dashboardWidgets);
  }

  Future<void> fetchWObyCategory() async {
 
  }

  Future<void> fetchPartsConsumption() async {
    
  }

  Future<void> workingEquipment() async {
 
       toggleWidgetSelection(DashboardWidgets.workingEquipmentIndicator);
  }

  Future<void> equipByClass() async {
   
       toggleWidgetSelection(DashboardWidgets.equipByClassChart);
  }
}
