import 'dart:developer';

import 'package:get/get.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/assets_management/installed_base.dart';

import 'package:steady_solutions/models/pm/manufacturer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/models/department.dart';
class AssetsManagementController extends GetxController  {
  RxMap<String, InstalledBase> installedBase = <String, InstalledBase>{}.obs;
  // temporary map to store the data fetched from the API
    RxMap<String, InstalledBase> tempInstalledBaseMap = <String, InstalledBase>{}.obs;
  RxMap<String, Department> departments = <String, Department>{}.obs;
  RxMap<String, Manufacturer> manufacturers = <String, Manufacturer>{}.obs;
  Rx<bool> isLoading = false.obs;
  Rx<bool> isInstalledBaseListEmpty = false.obs;
  final ApiAddressController _apiController = Get.find<ApiAddressController>(); 
  Rx<String> total = "-".obs;
  Future<void> fetchFilterData() async {
    isLoading.value = true;
    List temp;
    Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
    var response;
    log("departments $departments manufacturers $manufacturers");
    if(departments.isEmpty) {
      // Fetch departments and manufacturers only if they are empty (to avoid fetching them multiple times
     response = await http.get(
        Uri.parse("https://${storageBox.read('api_url')}$getAllDepartmentsEndPoint")
            .replace(queryParameters: params));
    
     temp = jsonDecode(response.body);
    temp.forEach((item) {
      departments[item["Value"]] = Department.fromJson(item);
    });
    }
 if(manufacturers.isEmpty) {
   response = await http.get(
        Uri.parse("https://${storageBox.read('api_url')}$getAllManufacturersEndPoint")
            .replace(queryParameters: params));

    temp = jsonDecode(response.body);
    for (var item in temp) {
      manufacturers[item["Value"]] = Manufacturer.fromJson(item);
    }
   
  }
   isLoading.value = false;
 }
  Future<void> fetchDataAndInsertIntoMap(
      [String? manafacturer, String? department]) async {
    //Flag 0 --> all ,Flag 1-->By Manf,Flag 2-->By Department
 
   total.value = "-"; 
   
    installedBase.value = <String, InstalledBase>{}.obs;
    isLoading.value = true;
    
    String flag = "0";
    if(manafacturer != null) {
      flag= "1";
    }
    if(department != null) {
      flag= "2";
    }
log("installed base flag : $flag");
     print(
       "fetching installed base with : department : $department , manafacturer : $manafacturer ID : ${department ?? manafacturer ?? '0'}");
    // Fetch data from API or local file
    final Map<String, String> params = {
      'EquipmentTypeID': storageBox.read("role").toString(),
      'UserID': storageBox.read("id").toString(),
      'Flag': flag,
      'ID': department ?? manafacturer ?? '0',
    };
    print(Uri.parse(
        "https://${storageBox.read('api_url')}$getInstalledBaseEndPoint",
      ).replace(queryParameters: params));
    // print(params.toString());
    final response = await http.get(
      Uri.parse(
        "https://${storageBox.read('api_url')}$getInstalledBaseEndPoint",
      ).replace(queryParameters: params),
    );
     print("Get Installed Base response : " + response.body);
    if (response.statusCode == 200) {
      // Loop through the assets and insert them into the map
      List data = json.decode(response.body)["EquipList"];
       print( data.length.toString() + " assets");
      int index=0;
      data.forEach(
        (item) => tempInstalledBaseMap["${index++}"] = InstalledBase.fromJson(item),
      );
    }
      log(installedBase.length.toString() + " assets");
        log(installedBase.length.toString() + "temp assets");
    installedBase = tempInstalledBaseMap;
     log(installedBase.length.toString() + " assets");
     total.value = installedBase.length.toString(); 
    if(installedBase.isEmpty) isInstalledBaseListEmpty.value = true;
    isLoading.value = false;
  }
}
