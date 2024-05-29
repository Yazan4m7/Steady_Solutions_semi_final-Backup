import 'dart:convert';
import 'dart:io';
import 'package:steady_solutions/models/site_rooms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/DTOs/all_rooms_response_DTO.dart';
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
  final AuthController _authController = Get.find<AuthController>();

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

  // NEW METHOD
  RxMap<String, Map<String, Department>> allDepartments =
      <String, Map<String, Department>>{}.obs;
  // RxMap<String, Map<String, Room>> allRooms = <String, Map<String, Room>>{}.obs;
  bool isDataLoaded = false;
  void clearData() {
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

  onReady() {
    if (_authController.isLoggedIn.value ?? false) {
      fetchAllData();
    }
    else{
    _authController.isLoggedIn.listen((value) {
      if (value ?? false) {
        if (!isDataLoaded) {
          fetchAllData();
        }
      }
    });
    }
    
  }

  Future<void> fetchDepartments()async{
    siteNames.forEach(await (key, value) async {
          print("fetching global deps: site : ${value.value}  ");
          await Future.delayed(Duration(seconds: 2), () async {
         
                await getDepartments(siteId: value.value!);
          });

          print(
              "retarned to global deps:${allDepartments[value.value]} site: ${value.value}");
        });

  }
    Future<void> getallRooms() async {
   
    final Map<String, String> params = {
      'EquipmentTypeID': storageBox.read("role").toString(),
      'UserID': storageBox.read("id").toString(),
    };

   
    try {
      final response = await http.get(Uri.parse(
              "http://${_apiController.apiAddress.value}$getAllRoomsEndPoint")
          .replace(queryParameters: params));
      AllRoomsResponseDTO allRoomsResponseDTO = AllRoomsResponseDTO();
      if (response.statusCode == 200) {
        jsonDecode(response.body).forEach((item) {
          SiteRoomsRepository().addRoom(item["Group"]["Name"], item);
          print("all rooms object $item");
          //allRoomsResponseDTO = AllRoomsResponseDTO.fromJson(item);
         // print("all rooms DTO: ${allRoomsResponseDTO.group?.name}");
         // allRooms[allRoomsResponseDTO.group?.name]?[allRoomsResponseDTO.value!] = Room.fromJson(item);
         // print("setting all rooms : ${allRooms[allRoomsResponseDTO.group!.name!]}");
         // print("for : ${allRoomsResponseDTO.group!.name!} : ${allRoomsResponseDTO.value}"); 
         // print("final all rooms : ${allRooms[allRoomsResponseDTO.group?.name].toString()} rooms");
        });
      }
      // CONNECTION ERROR
      
      else{
        Get.dialog(CupertinoAlertDialog(
          title: Text("Error"),
          content: Text("Could not fetch rooms data"),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ));

      }
    }
    // EXCPETION decoding
     catch (e) {
      if(foundation.kDebugMode)
      rethrow;
       Get.dialog(CupertinoAlertDialog(
          title: Text("Error"),
          content: Text("Could not fetch rooms data"),
          actions: [
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ));
    }
  

  }

  Future<void> fetchAllData() async { 
    if(isDataLoaded){
      return;
    }
    print("<<<<<<<<<< LOADING ALL DATA>>>>>>>>");
    await fetchNewWorkOrderOptions();
    await Future.delayed(Duration(seconds: 3));
    await fetchDepartments();
    print(" <<<<<<<<<<<<<<<<<<< FETCHED DEPARTMENTS >>>>>>>>>>>>>>>>");
   // await Future.delayed(Duration(seconds: 3));
    await getallRooms();
      print(" <<<<<<<<<<<<<<<<<<< FETCHED ROOMS >>>>>>>>>>>>>>>>");

      print("<<<<<<<<<< FINISHED LOADING ALL DATA FUNCTION >>>>>>>>");
      print(
          "all data : departments : ${allDepartments.length} ");
    

    isDataLoaded = true;
  }

  Future<void> fetchPendingOrders() async {
    isLoading.value = true;
    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),

      /// todo CHANGE
      'flag': '2' //today=0 ,week=1,month=2
    };
    final response = await http.get(Uri.parse(
            "http://${_apiController.apiAddress.value}$getPendingOrdersEndPoint")
        .replace(queryParameters: params));
    print("Get pending orders response : " + response.body);
    List temp = jsonDecode(response.body)['data'];
    for (var item in temp) {
      pendingWorkOrders.add(PendingWorkOrder.fromJson(item));
    }

    isLoading.value = false;
    // return pendingWorkOrders;
  }

  Future<Map<String, Room>> getRoomsList({required String departmentId}) async {
    //       print(allRooms.keys);
    // if (allRooms.containsKey(departmentId)) {
    //   print("Dep id : $departmentId  pre rooms  ${rooms.values.length} new rooms : ${allRooms[departmentId]!.values.length}" );
    //   rooms.value = allRooms[departmentId]!;
    //   print("returning from global list : ${rooms.length} rooms");
    //   return rooms;
    // }
    print("deparm id : $departmentId");
    print(storageBox.read("role").toString());

    final Map<String, String> params = {
      'DepID': departmentId,
      'EquipmentTypeID': storageBox.read("role").toString(),
      'UserID': storageBox.read("id").toString(),
    };

   
    try {
      final response = await http.get(Uri.parse(
              "http://${_apiController.apiAddress.value}$getRoomsListEndPoint")
          .replace(queryParameters: params));
      print(Uri.parse(
              "http://${_apiController.apiAddress.value}$getRoomsListEndPoint")
          .replace(queryParameters: params));
      if (response.statusCode == 200) {
        jsonDecode(response.body).forEach((item) {
          rooms[item["Text"]] = Room.fromJson(item);
        });
      }
      print("Get rooms response : " + response.body);
    } catch (e) {
      rooms[departmentId] = Room(text: "None", value: "0");
      rethrow;
    }
    return rooms;
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
      Uri.parse(
              "http://${_apiController.apiAddress.value}${getInfoServiceEndPoint}")
          .replace(queryParameters: params),
    );
    // print("Get service url : " +
    //     Uri.parse(
    //             "http://${_apiController.apiAddress.value}${getInfoServiceEndPoint}")
    //         .replace(queryParameters: params)
    //         .toString());
    print("Get Service info response : " + response.body);
    if (response.statusCode == 200) {
      print("Get Service info response : 200");

      serviceInfo.value = ServiceInfo.fromJson(jsonDecode(response.body));
    } else {
      // Connection error
      serviceInfo.value = ServiceInfo(
          Id: '0', controlNo: "Not found", serviceDesc: "Not found");
    }
    debugPrint("Service info : ${serviceInfo.toString()}");
  }

  Future<void> getDepartments(
      {required String siteId}) async {
    print("GET DEPARTMENTS XXXXXXXXXXXXXXXXXXXXXXXX");
    if (allDepartments.containsKey(siteId)) {
      departments.value = allDepartments[siteId]!;
      print("returning from global list : ${departments.length} DEPARTMENTS");
     // return departments;
    }

    debugPrint("Get departments");
    debugPrint("site id : $siteId");
    final Map<String, String> params = {
      'SiteID': siteId,
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
    final response = await http.get(Uri.parse(
            "http://${_apiController.apiAddress.value}$getDepartmentsEndpoint")
        .replace(queryParameters: params));
    if (response.statusCode == 200) {
      List temp = jsonDecode(response.body)["Departments"];
      //debugPrintnt(temp.length.toString() + " departments");
      temp.forEach((item) {
        departments[item["Text"]] = Department.fromJson(item);
      });
     // return departments;
    }
    //return RxMap<String, Department>();
  }

  Future<void> getControlItem(
      {required String controlNum}) async {
    final Map<String, String> params = {
      'type': "1",
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'EquipmentID': "0",
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
        'EquipmentTypeID': storageBox.read("role").toString(),
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

        callTypesNamesJson.forEach((item) {
          if (!item["Text"].isEmpty && item["Text"] != "") {
            callTypes[item["Text"]] = CallType.fromJson(item);
          }
        });
        categories.remove("--Please Select--");
        callTypes.remove("--Please Select--");
        siteNames.remove("--Please Select--");
        print(categories.keys);
      }
    } catch (e) {
      if (foundation.kDebugMode) {
        rethrow;
      } else {
        Get.snackbar("Error", "Could not fetch WOs Options data");
      }
    }
  }

  Future<CreateWorkOrderDTO> createWorkOrder(WorkOrder workOrder) async {
    print(workOrder.imageFile);

    var url =
        "http://${_apiController.apiAddress.value}${createWorkOrderEndpoint}"; // Replace with your URL
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var multipartFile;
    // Prepare the image file for upload
    if (workOrder.imageFile != null) {
      multipartFile = await http.MultipartFile.fromPath(
          'imageFile', workOrder.imageFile!.path);
              request.files.add(multipartFile);
    } 

    String role = storageBox.read("role").toString();
    if (role =="" || role.isEmpty)
    role = "2";
    // Add other data (replace with your actual data fields)
    request.fields['EquipmentID'] = controlItem.value.id ?? "0";
    request.fields['CallTypeID'] = workOrder.callTypeID ?? "";
    request.fields['IsUrgent'] = workOrder.isUrgent.toString();
    request.fields['FaultStatus'] = workOrder.faultStatues ?? "";
    request.fields['RoomID'] = workOrder.roomId ?? "";
    request.fields['Type'] = workOrder.type.toString();
    request.fields['UserID'] = storageBox.read("id").toString();
    request.fields['EquipmentTypeID'] = role = "2";
;

    request.fields['NewOrEdit'] = "0";

    // Send the request
    var response = await request.send();
    print("Response status: ${response.reasonPhrase}");
    // final response2 = await http.Response.fromStream(response); 

    //   final body = response2.body;
    //   print("Crete WO response : " + body);
    //        var data =await responseData(response);
    //          print("Crete WO MAP : " + data.toString());
    // Handle the response (success, error)

    if (response.statusCode == 200) {
      CreateWorkOrderDTO createWODTO =
          CreateWorkOrderDTO(success: 0, message: "Connaction faliure");
      if (response.statusCode == 200) {
           
        var data =await responseData(response);
        print(response);
        print(response.runtimeType);
        print( data);
        var d =  data;
        print(d.runtimeType);
        print("-----------------");
        //var data = await responseData(response);
        return CreateWorkOrderDTO(
            success: 1, message: "Created successfully", jobNum: data["JobNO"]);
      } else {
        createWODTO.message = "MISSING DATA";
      }
      return createWODTO;
    } else {
   
      return CreateWorkOrderDTO(success: 0, message: "Connaction faliure");
    }
  }

  Future<Map<String, dynamic>> responseData(
      http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody); // Assuming JSON response
    return data; // Return the decoded data
  }
}
