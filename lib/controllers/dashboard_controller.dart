import 'package:flutter/foundation.dart';
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

RxMap<String,DashboardWidgetModel> dashboardWidgets =  <String,DashboardWidgetModel>{}.obs;  

RxMap<String, bool> loading = <String,bool>{
    'PM': false,
    'CM': false,
  }.obs;

  Rx<DashboardWidgetModel> pmPerformance = DashboardWidgetModel().obs;  
  Rx<DashboardWidgetModel> cmPerformance = DashboardWidgetModel().obs;

  @override
  onReady () {
    //dashboardWidgets = storageBox.read('') ?? <String,DashboardWidgetModel>{}.obs;
    
    //fetchCMPerformance(1);
    //fetchCMPerformance(2);
    super.onReady();
  }

  // Function to fetch data for a specific ID
  Future<void> fetchCMPerformance(int type) async { // 1= PM , 2= CM
  if(type == 1) {loading['PM'] = true;}
  if(type == 2) {loading['CM'] = true;}
    // ignore: unused_local_variable
    Rx<bool> isLoading = true.obs;
        final Map<String, String> params = {
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
      String url = type == 1 ? "http://${storageBox.read('api_url')}$getPMPerformanceChartEndPoint" 
      : "http://${storageBox.read('api_url')}$getCMPerformanceChartEndPoint"; 
      print(Uri.parse(url)
              .replace(queryParameters: params));
      final response = await http.get(
          Uri.parse(url)
              .replace(queryParameters: params));
              
              print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if(type == 1) {
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
        Get.snackbar("Error 011", "Server resposned with status code ${response.statusCode}");
      }
      print("FALSE3");
       loading['PM'] = false;
    loading['CM'] = false;
    } catch (e) {
      if(kDebugMode) {
        rethrow;
      } else {
        Get.to(const HomeScreen());
      }
      
    }
    //storageBox.write("dashboardWidgets", dashboardWidgets);
   
  }
}