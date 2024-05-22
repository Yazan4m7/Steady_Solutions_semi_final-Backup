import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/DTOs/create_wo_DTO.dart';
import 'package:steady_solutions/models/work_orders/room.dart';
import 'package:steady_solutions/models/work_orders/service_info.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/models/work_orders/call_type.dart';
import 'package:steady_solutions/models/work_orders/category.dart';
import 'package:steady_solutions/models/work_orders/control_item_model.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/pending_work_order.dart';
class WorkOrdersController extends GetxController {
  int? lastWorkOrderJobId;
  RxMap<int, WorkOrder> workOrders = <int, WorkOrder>{}.obs;
  final ApiAddressController _apiController = Get.find<ApiAddressController>(); 
  RxMap<String, Site> siteNames = <String, Site>{}.obs;
  RxMap<String, CallType> callTypes = <String, CallType>{}.obs;
  RxMap<String, Category> categories = <String, Category>{}.obs;
  RxMap<String, Department> departments = <String, Department>{}.obs;
  RxMap<String, Room> rooms = <String, Room>{}.obs;
  Rx<ControlItem> controlItem = ControlItem().obs;
  Rx<ServiceInfo> serviceInfo = ServiceInfo().obs;
  Rx<String> equipName = "".obs;
  Rx<String> serialNumber = "".obs;
  Rx<WorkOrder> currentNewWorkOrder = WorkOrder().obs;
  RxList<PendingWorkOrder> pendingWorkOrders = <PendingWorkOrder>[].obs;
  Rx<bool> isLoading = false.obs;

    void clearData(){
        siteNames = <String, Site>{}.obs;
        callTypes = <String, CallType>{}.obs;
        categories = <String, Category>{}.obs;
        departments = <String, Department>{}.obs;
        rooms = <String, Room>{}.obs;
        controlItem = ControlItem().obs;
        serviceInfo = ServiceInfo().obs;
        equipName = "".obs;
        serialNumber = "".obs;
        isLoading = false.obs;
    }


  Future<void> fetchPendingOrders() async {
    
    isLoading.value = true;
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(), /// todo CHANGE
      'flag': '2' //today=0 ,week=1,month=2
    };
    final response = await http.get(
        Uri.parse("http://${_apiController.apiAddress.value}$getPendingOrdersEndPoint")
            .replace(queryParameters: params));
             print("Get pending orders response : " + response.body);
    List temp = jsonDecode(response.body)['data'];
    for (var item in temp) {
      pendingWorkOrders.add(PendingWorkOrder.fromJson(item));
    }

    isLoading.value = false;
    // return pendingWorkOrders;
  }

  // Future<void> fetchWorkOrdersOptions() async {
//
  Future<void> getRoomsList({required String departmentId}) async {
    print("deparm id : $departmentId");
     print(storageBox.read("role").toString());
    
    final Map<String, String> params = {
      'DepID': departmentId,
      'EquipmentTypeID':  storageBox.read("role").toString(),
      'UserID': storageBox.read("id").toString() ,
    };
    
    //Get Id from QR code
    try {
      final response = await http.get(
          Uri.parse("http://${_apiController.apiAddress.value}$getRoomsListEndPoint")
              .replace(queryParameters: params));
       print("Get rooms response : " + response.body);
      jsonDecode(response.body).forEach((item) {
        rooms[item["Text"]] = Room.fromJson(item);
      });
    } catch (e) {
      rooms["No Rooms Found"] = Room(text: "None", value: "0");
    }
  
  }

  Future<void> getServiceInfo(
      {required String categoryId, required String departmentId}) async {
    final Map<String, String> params = {
      'CategoryID': categoryId,
      'DepartmentID': departmentId,
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
    final response = await http.get(
      Uri.parse("http://${_apiController.apiAddress.value}${getInfoServiceEndPoint}")
          .replace(queryParameters: params),
    );
    print("Get Service info response : " + response.body);
    if (response.statusCode == 200 ) {

      // SI Found
  
      //SI Found
      serviceInfo.value = ServiceInfo.fromJson(jsonDecode(response.body));
      

    } else {
      // Connection error
      serviceInfo.value = ServiceInfo(
          Id: '0', controlNo: "Not found", serviceDesc: "Not found");
    }
    debugPrint("Service info : $serviceInfo");
  }

  Future<void> getDepartments({required String siteId}) async {
    //debugPrintnt("Get departments");
    //debugPrintnt("site id : $siteId");
    final Map<String, String> params = {
      'SiteID': siteId,
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
    final response = await http.get(
        Uri.parse("http://${_apiController.apiAddress.value}$getDepartmentsEndpoint")
            .replace(queryParameters: params));
             print("Get departments response : " + response.body);
    List temp = jsonDecode(response.body)["Departments"];
    //debugPrintnt(temp.length.toString() + " departments");
    temp.forEach((item) {
      departments[item["Text"]] = Department.fromJson(item);
    });
  }

  Future<void> getControlItem(
      {String equipmentID = "0", String controlNum = ""}) async {
        print(equipmentID);
    final Map<String, String> params = {
      'type': "1",
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'EquipmentID': equipmentID,
      'ControlNo': controlNum
    };
    //Get Id from QR code
    final response = await http.get(
        Uri.parse("http://${_apiController.apiAddress}$getControlInfoEndpoint")
            .replace(queryParameters: params));
    print("Get control item response : " + response.body);
    controlItem.value = ControlItem.fromJson(jsonDecode(response.body));

    // Get.to(() => const NewEquipWorkOrderFrom());
  }

  // TODO file upload
  _asyncFileUpload(String text, File file) async {
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest("POST", Uri.parse("<url>"));

    
    //add text fields
    request.fields["text_field"] = text;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("file_field", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
  }

  Future<void> fetchNewWorkOrderOptions() async {
    // if()

     try {
    final Map<String, String> params = {
      'type': '1',
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID':  storageBox.read("role").toString(),
    };
    print(params.toString());
    final response = await http.get(
      Uri.parse(
        "http://${_apiController.apiAddress.value}$getNewOrderOptionsEndPoint}",
      ).replace(queryParameters: params),
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> siteNamesJson = jsonData['SiteList'];
      List<dynamic> callTypesNamesJson = jsonData['CallTypeList'];
      List<dynamic> categoriesJson = jsonData['CategoryList'];

      categoriesJson.forEach((item) {
        categories[item["Text"]] = Category.fromJson(item);
      });
      siteNamesJson.forEach((item) {
        siteNames[item["Text"]] = Site.fromJson(item);
      });
      siteNamesJson.forEach((item) {
        siteNames[item["Text"]] = Site.fromJson(item);
      });

      callTypesNamesJson.forEach((item) {
        if (!item["Text"].isEmpty && item["Text"] != "") {
          callTypes[item["Text"]] = CallType.fromJson(item);
        }
      });
    }
    } catch (e) {
      if(foundation.kDebugMode){
       rethrow;
       
      }else{
        Get.snackbar("Error","Could not fetch WOs Options data");
      
      }
  
    }
  }

  Future<CreateWorkOrderDTO> createWorkOrder(WorkOrder workOrder) async {
    print(workOrder.imageFile);

 

    var url = "http://${_apiController.apiAddress.value}${createWorkOrderEndpoint}"; // Replace with your URL
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var multipartFile;
    // Prepare the image file for upload
    if(workOrder.imageFile != null) {
      multipartFile = await http.MultipartFile.fromPath('imageFile',  workOrder.imageFile!.path );
    } else {
      multipartFile = await http.MultipartFile.fromPath('imageFile',  "" );
    }
    request.files.add(multipartFile);

      // Add other data (replace with your actual data fields)
       request.fields['EquipmentID'] = workOrder.equipmentID ?? "";
      request.fields['CallTypeID'] = workOrder.callTypeID ?? "";
      request.fields['IsUrgent'] = workOrder.isUrgent.toString();
      request.fields['FaultStatus'] = workOrder.faultStatues ?? "";
      request.fields['RoomID'] = workOrder.roomId ?? "";
      request.fields['Type'] = workOrder.type.toString();
      request.fields['UserID'] = storageBox.read("id").toString();
      request.fields['EquipmentTypeID'] = workOrder.equipTypeID ?? "";
      request.fields['NewOrEdit'] = "0";

    // Send the request
    var response = await request.send();
    print("Response status: $response");
    // Handle the response (success, error)
    

    if (response.statusCode == 200) {
      
    CreateWorkOrderDTO createWODTO =
        CreateWorkOrderDTO(success: 0, message: "Connaction faliure");
    if (response.statusCode == 200) {

      // var data =responseData(response);
      // print(response);
      // print(response.runtimeType);
      // print(await data);
      // var d = await data;
      // print(d.runtimeType);
      // print("-----------------");
      var data = await responseData(response);
      return CreateWorkOrderDTO(success: 1, message: "Created successfully",jobNum: data["JobNO"] );
    } else {
      createWODTO.message ="MISSING DATA";
    }
    return createWODTO;
    } 
    
    else {
      return CreateWorkOrderDTO(success: 0, message: "Connaction faliure");
  }
  
}
  Future<Map<String, dynamic>> responseData(http.StreamedResponse response) async {
  final responseBody = await response.stream.bytesToString();
  final data = jsonDecode(responseBody); // Assuming JSON response
  return data; // Return the decoded data
}
}
