
 import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/charts_models.dart';
import 'package:steady_solutions/models/dashboard/chart_data.dart';
import 'package:steady_solutions/models/dashboard/dashboard_widget.dart';
import 'package:steady_solutions/models/dashboard/doughnut_chart_dat.dart';
import 'package:steady_solutions/models/dashboards/pm_cm_performance.dart';
import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/screens/dashboard/dashboard.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;

import 'package:steady_solutions/screens/home_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    'avg':"",
    "min": "",
    "max": "",
  }.obs;
   RxMap<String, String> workingEquipmentData = <String, String>{
  }.obs;
  List<ChartSampleData> e_by_class = <ChartSampleData>[
    ];
  Rx<DashboardWidgetModel> pmPerformance = DashboardWidgetModel().obs;
  Rx<DashboardWidgetModel> cmPerformance = DashboardWidgetModel().obs;
  Rx<String> MTTR = "".obs;
  Rx<String> MTBF = "".obs;
  RxList<PartsConsumptionChartData> partsConsumptionChartData = <PartsConsumptionChartData>[].obs;
  List<ChartData> chartData = [];

  final List<WOByYearChartData> woByYearChartData = [
  ];



   RxList<ChartData>? byCategoryChartData = <ChartData>[].obs;
  @override
  onInit() {
 
    super.onInit();
    fetchChartsData();
      

    
  }
   static RxBool isDataLoaded = false.obs;

  void fetchChartsData() async{
    if (storageBox.read('api_url') != null && !isDataLoaded.value && storageBox.read("id") != null) {
    await fetchCMPerformance(1);
    // await Future.delayed(Duration(seconds: 1));
    await fetchCMPerformance(2);
   //  await Future.delayed(Duration(seconds: 1));
    await fetchMTTR();
   //  await Future.delayed(Duration(seconds: 1));
    await fetchMTBF();
   //  await Future.delayed(Duration(seconds: 1));
    await fetchAvgDownTime();
   //  await Future.delayed(Duration(seconds: 1));
    await fetchWObyYear();
   //  await Future.delayed(Duration(seconds: 1));
    await fetchWObyCategory();
   //  await Future.delayed(Duration(seconds: 1));
    await fetchPartsConsumption();
   //  await Future.delayed(Duration(seconds: 1));
    await workingEquipment();
    // await Future.delayed(Duration(seconds: 1));
    await equipByClass();
  
    isDataLoaded = true.obs;
    }
  
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
  
  
    // ignore: unused_local_variable
    Rx<bool> isLoading = true.obs;
    final Map<String, String> params = {
       'UserID': storageBox.read("id").toString(),
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
        print("Cannot connect to API-----------------------");
        //rethrow;
      } else {
        Get.to(ApiAddressScreen());
      }
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
  try {
  final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
      String url = "http://${storageBox.read('api_url')}$getWOByCategoryEndPoint";
      print(Uri.parse(url).replace(queryParameters: params));
      final response =
          await http.get(Uri.parse(url).replace(queryParameters: params));

      print("WO BY Category Response : " + response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
       
        final List<String> categories = List<String>.from(jsonData['IChartCategoryName']);
        final List<int> jobCounts = List<int>.from(jsonData['IChartJobNOCount']);
        final List<double> performances = List<double>.from(jsonData['IChartPerformance']);

        if (categories.length != jobCounts.length || jobCounts.length != performances.length) {
          throw ArgumentError('Lists in JSON have different lengths');
        }

        
        for (int i = 0; i < categories.length; i++) {
          print("add");
          byCategoryChartData!.add(ChartData(category: categories[i], jobCount:jobCounts[i],performance: performances[i]));
          }


        dashboardWidgets["wo_by_category"] = byCategoryChartData;
      } else {
      //  print("FALSE2");R

      }
     
    }
    catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 193", "(WO BY Cat) Exep.data fetching");
       // Get.to(HomeScreen());
      }
    }
  }
 Future<void> fetchWObyYear() async {
 try {
  final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
      String url = "http://${storageBox.read('api_url')}$getWOByYearEndPoint";
      print(Uri.parse(url).replace(queryParameters: params));
      final response =
          await http.get(Uri.parse(url).replace(queryParameters: params));

      print("WO BY YEAR Response : " + response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
         
          List<String> monthNames = List<String>.from(data['IMonthName']);
           List<int> monthdata = List<int>.from(data['IYearData']);
         



           
          print("add");
          for (int i = 0; i < monthNames.length; i++) {
            woByYearChartData.add(WOByYearChartData(monthNumber: i, WOCount: monthdata[i],monthName: monthNames[i]));
          }
          
    
      } else {
      //  print("FALSE2");

      }
     
    }
    catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 010", "(WO BY YEAR) Exep.data fetching");
       // Get.to(HomeScreen());
      }
    }
  }
  Future<void> fetchPartsConsumption() async {
    
     final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
    
      final response = await http.get(
          Uri.parse("http://${storageBox.read('api_url')}$getPartsConsumptionEndPoint")
              .replace(queryParameters: params));

      print("fetchPartsConsumption Response : " + response.body);
     
   
      if (response.statusCode == 200) {
         final Map<String, dynamic> jsonData = jsonDecode(response.body);
            List<int> quantites = List<int>.from(jsonData['InventoryPartConsumbtionData1']);
       List<int> costPrices = List<int>.from(jsonData['InventoryPartConsumbtionData2']);
       List<String> monthNames = [
         "Jan",
         "Feb",
         "Mar",
         "Apr",
         "May",
         "Jun",
         "Jul",
         "Aug",
         "Sep",
         "Oct",
         "Nov",
         "Dec"
       ];
          for (int i = 0; i < quantites.length; i++) {
          partsConsumptionChartData.add(PartsConsumptionChartData(quantity: quantites[i], costPrice:costPrices[i],montNumber: i, monthName: monthNames[i]));
          }

      } else {
        // loading['MTBF'] = false;
        Get.snackbar("Error 066",
            "PartsConsumption |  Server resposned with status code ${response.statusCode}");
      }

      // loading['MTBF'] = false;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 066", "(PartsConsumption) Exep. in data fetching");
       // Get.to(HomeScreen());
      }
    }


  }

  Future<void> workingEquipment() async {
     final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    try {
      print(Uri.parse("http://${storageBox.read('api_url')}$getWorkingEquipmentEndPoint")
          .replace(queryParameters: params));
      final response = await http.get(
          Uri.parse("http://${storageBox.read('api_url')}$getWorkingEquipmentEndPoint")
              .replace(queryParameters: params));

      print(" Working equip Response : " + response.body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        workingEquipmentData["Working"]=data["Working"];
        workingEquipmentData["Condem"]=data["Condem"];
        workingEquipmentData["CondemPercent"]=data["CondemPercent"];
      } else {
        // loading['MTBF'] = false;
        Get.snackbar("Error 066",
            "Server resposned with status code ${response.statusCode}");
      }

      // loading['MTBF'] = false;
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error 066", "(Working equip) Exep. in data fetching");
       // Get.to(HomeScreen());
      }
    }
  }

  Future<void> equipByClass() async {
   final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
       try {
      print(Uri.parse("http://${storageBox.read('api_url')}$getEquipmentByClassEndPoint")
          .replace(queryParameters: params));
      final response = await http.get(
          Uri.parse("http://${storageBox.read('api_url')}$getEquipmentByClassEndPoint")
              .replace(queryParameters: params));

      print(" equipByClass Response : " + response.body);
      if (response.statusCode == 200) {
         final Map<String, dynamic> jsonData = jsonDecode(response.body);
          final List<dynamic> pieDataList = jsonData['success'];

            e_by_class = pieDataList.map((item) {
              return ChartSampleData(
                x: item['name'],
                y: item['value'],
                text: item['parent'],
              );
            }).toList();
            e_by_class = e_by_class.where((item) => item.x != '0.0').toList();
                } else {
        // loading['MTBF'] = false;
        Get.snackbar("Error 066",
            "equipByClass resposned with status code ${response.statusCode}");
      }}
      catch(e){
        if(kDebugMode) {
          rethrow;
      }

    } 


  }
}
class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}