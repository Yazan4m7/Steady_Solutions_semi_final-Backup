import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';

import 'package:steady_solutions/models/DTOs/create_wo_DTO.dart';
import 'package:steady_solutions/models/work_orders/achievement_report.dart';
import 'package:steady_solutions/models/work_orders/room.dart';
import 'package:steady_solutions/models/work_orders/service_info.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/models/work_orders/call_type.dart';
import 'package:steady_solutions/models/work_orders/category.dart';
import 'package:steady_solutions/models/work_orders/control_item_model.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/pending_work_order.dart';
import 'package:steady_solutions/screens/notifications/notifications_screen.dart';

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
  //RxMap<String, Map<String, Room>> allRooms = <String, Map<String, Room>>{}.obs;
  bool isDataLoaded = false;
  // void clearData() {
  //   siteNames = <String, Site>{}.obs;
  //   callTypes = <String, CallType>{}.obs;
  //   categories = <String, Category>{}.obs;
  //   departments = <String, Department>{}.obs;
  //   rooms = <String, Room>{}.obs;
  //   controlItem = ControlItem().obs;
  //   serviceInfo = ServiceInfo().obs;
  //   equipName = "".obs;
  //   serialNumber = "".obs;
  //   isLoading = false.obs;
  // }

  onInit() {
    super.onInit();
    if (storageBox.read("id") != null) if (_authController.isLoggedIn.value) {
      // // print"DATAAA 1");
      fetchAllData();
    } else {
      _authController.isLoggedIn.listen((value) {
        if (value) {
          if (!isDataLoaded) {
            // // print"DATAAA 2");
            fetchAllData();
          } else {
            // // print"DATAAA 3");
          }
        }
      });
    }
  }

  Future<void> fetchDepartments() async {
    departments = RxMap<String, Department>();
    siteNames.forEach(await (key, value) async {
      print("fetching global departs: site : ${value.value}  ");
      //await Future.delayed(Duration(seconds: 2), () async {
      await getDepartments(siteId: value.value!);
      // });

      // // print
      //   "retarned to global deps:${allDepartments[value.value]} site: ${value.value}");
    });
  }
  Future< RxMap<String, Department>> getRoomsList({required String departmentId}) async {
    // // print"GET DEPARTMENTS XXXXXXXXXXXXXXXXXXXXXXXX");
    // if (allDepartments.containsKey(siteId)) {
    //   departments.value = allDepartments[siteId]!;
    //   print("returning from global list : ${departments.length} DEPARTMENTS");
    //   // return departments;
    // }
    rooms = RxMap<String, Room>();
    print("Get Room");
    print("departmentId id : $departmentId");
    final Map<String, String> params = {
      // 'SiteID': departmentId,
        'EquipmentTypeID': storageBox.read("role").toString(),
      'UserID': storageBox.read("id").toString(),
      'DepID': departmentId,
    };
    final response = await http.get(Uri.parse(
            "https://${storageBox.read('api_url')}$getRoomsListEndPoint")
        .replace(queryParameters: params));
    if (response.statusCode == 200) {
      List temp = jsonDecode(response.body);

      temp.forEach((item) {
        rooms[item["Text"]] = Room.fromJson(item);
      });
         print("found ${rooms.length} rooms");
      // return departments;
    } else
      print(response.body);
    return RxMap<String, Department>();
  }
  // Future<void> getRoomsList({required String departmentId}) async {
  //   //rooms = RxMap<String, Room>();
  //   final Map<String, String> params = {
  //     'EquipmentTypeID': storageBox.read("role").toString(),
  //     'UserID': storageBox.read("id").toString(),
  //     'DepID' : departmentId
  //   };
  //   debugPrint("Getting rooms for $departmentId");
  //   try {
  //     print("GETTIGN ROOM BY DEP: ");
  //     final response = await http.get(
  //         Uri.parse("https://${storageBox.read('api_url')}$getRoomsListEndPoint")
  //             .replace(queryParameters: params));
  //     Room room = Room();

  //     // // printUri.parse("https://${storageBox.read('api_url')}$getAllRoomsEndPoint")
  //     //  .replace(queryParameters: params));
  //     if (response.statusCode == 200) {
  //       jsonDecode(response.body).forEach(
  //         (item) {
  //           print("all rooms object $item");
  //           room = Room.fromJson(item);
  //           //if (room.deptId == departmentId) {
  //             print("adding room ${room.value} : ${room.text}");
  //             rooms[room.value!] = room;
  //          // }
  //           print("final all rooms : ${rooms.length} rooms");
  //         },
  //       );
  //     }
  //     // CONNECTION ERROR 

  //     else {
  //       Get.dialog(CupertinoAlertDialog(
  //         title: Text("Error"),
  //         content: Text("Could not fetch rooms data"),
  //         actions: [
  //           CupertinoDialogAction(
  //             child: Text("OK"),
  //             onPressed: () {
  //               Get.back();
  //             },
  //           ) 
  //         ],
  //       ));
  //     }
  //   }
  //   // EXCPETION decoding
  //   catch (e) {
  //     if (foundation.kDebugMode) rethrow;
  //     Get.dialog(CupertinoAlertDialog(
  //       title: Text("Error"),
  //       content: Text("Could not fetch rooms data"),
  //       actions: [
  //         CupertinoDialogAction(
  //           child: Text("OK"),
  //           onPressed: () {
  //             Get.back();
  //           },
  //         )
  //       ],
  //     ));
  //   }
  // }

  Future<void> fetchAllData() async {
    if (isDataLoaded) {
      return;
    }

    // // print"<<<<<<<<<< LOADING ALL DATA>>>>>>>>");
    fetchNewWorkOrderOptions();
    log("loaded options");
    await Future.delayed(Duration(seconds: 1));
    fetchDepartments();
    // // print" <<<<<<<<<<<<<<<<<<< FETCHED DEPARTMENTS >>>>>>>>>>>>>>>>");
    // await Future.delayed(Duration(seconds: 3));
    //await getallRooms();
    // // print" <<<<<<<<<<<<<<<<<<< FETCHED ROOMS >>>>>>>>>>>>>>>>");
    // // print"<<<<<<<<<< FINISHED LOADING ALL DATA FUNCTION >>>>>>>>");
    // // print
    //    "DATA FETCHED : departments : ${allDepartments.length} rooms : ${allRooms.length} sites : ${siteNames.length}");

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
            "https://${storageBox.read('api_url')}$getPendingOrdersEndPoint")
        .replace(queryParameters: params));
    // // print"Get pending orders response : " + response.body);
    List temp = jsonDecode(response.body)['data'];
    for (var item in temp) {
      pendingWorkOrders.add(PendingWorkOrder.fromJson(item));
    }

    isLoading.value = false;
    // return pendingWorkOrders;
  }

  // Future<Map<String, Room>> getRoomsList({required String departmentId}) async {
  //   //       // // printallRooms.keys);
  //   // if (allRooms.containsKey(departmentId)) {
  //   //   // // print"Dep id : $departmentId  pre rooms  ${rooms.values.length} new rooms : ${allRooms[departmentId]!.values.length}" );
  //   //   rooms.value = allRooms[departmentId]!;
  //   //   // // print"returning from global list : ${rooms.length} rooms");
  //   //   return rooms;
  //   // }
  //   // // print"deparm id : $departmentId");
  //   // // printstorageBox.read("role").toString());

  //   final Map<String, String> params = {
  //     //'DepID': departmentId,
  //     'EquipmentTypeID': storageBox.read("role").toString(),
  //     'UserID': storageBox.read("id").toString(),
  //   };

  //   try {
  //     final response = await http.get(
  //         Uri.parse("https://${storageBox.read('api_url')}$getRoomsListEndPoint")
  //             .replace(queryParameters: params));
  //     // // print
  //         Uri.parse("https://${storageBox.read('api_url')}$getRoomsListEndPoint")
  //             .replace(queryParameters: params));
  //     if (response.statusCode == 200) {
  //       jsonDecode(response.body).forEach((item) {
  //         if (allRooms['DepartmentID'] == null)
  //           allRooms['DepartmentID'] = Map<String, Room>();
  //         allRooms['DepartmentID']?['RoomID'] = Room.fromJson(item);
  //       });
  //     }
  //     // // print"Get rooms response : " + response.body);
  //   } catch (e) {
  //     if (foundation.kDebugMode) rethrow;
  //   }
  //   return rooms;
  // }

  Future<AchievementReport> getAchievementReport(int reportId) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });
    AchievementReport report = AchievementReport();
    // // print"sending report id : $reportId");
    final Map<String, String> params = {
      'CMReportID': reportId.toString(),
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
    // // print Uri.parse(
    //        "https://${storageBox.read('api_url')}$getAchievementReportEndPoint")
    //    .replace(queryParameters: params));
    final response = await http.get(
      Uri.parse(
              "https://${storageBox.read('api_url')}$getAchievementReportEndPoint")
          .replace(queryParameters: params),
    );

    // // print"Get ach report info response : " + response.body);
    if (response.statusCode == 200) {
      report = AchievementReport.fromJson(jsonDecode(response.body));
    } else {
      // Connection error
      Get.dialog(CupertinoAlertDialog(
        title: Text("Error"),
        content: Text("Could not get report data from server"),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Get.back();
              Get.off(NotificationsScreen());
            },
          )
        ],
      ));
    }
    //  debug// // print"Aciev report :${report.equipName} ${report.failureDateTime} ${report.remedy}");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = false;
    });
    return report;
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
              "https://${storageBox.read('api_url')}${getInfoServiceEndPoint}")
          .replace(queryParameters: params),
    );
    // // // print"Get service url : " +
    //     Uri.parse(
    //             "https://${storageBox.read('api_url')}${getInfoServiceEndPoint}")
    //         .replace(queryParameters: params)
    //         .toString());
    print("Get Service info response : " + response.body);
    if (response.statusCode == 200) {
      // // print"Get Service info response : 200");

      serviceInfo.value = ServiceInfo.fromJson(jsonDecode(response.body));
    } else {
      // Connection error
      serviceInfo.value = ServiceInfo(
          Id: '0', controlNo: "Not found", serviceDesc: "Not found");
    }
    print("Service info : ${serviceInfo.toString()}");
  }

  Future<void> getDepartments({required String siteId}) async {
    departments.value = RxMap<String, Department>();
    // // print"GET DEPARTMENTS XXXXXXXXXXXXXXXXXXXXXXXX");
    if (allDepartments.containsKey(siteId)) {
      departments.value = allDepartments[siteId]!;
      print("returning from global list : ${departments.length} DEPARTMENTS");
      // return departments;
    }

    print("Get departments");
    print("site id : $siteId");
    final Map<String, String> params = {
      'SiteID': siteId,
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };
    final response = await http.get(Uri.parse(
            "https://${storageBox.read('api_url')}$getDepartmentsEndpoint")
        .replace(queryParameters: params));
    if (response.statusCode == 200) {
      List temp = jsonDecode(response.body)["Departments"];
      debugPrint(temp.length.toString() + " departments");
      temp.forEach((item) {
        departments[item["Text"]] = Department.fromJson(item);
      });
      // return departments;
    }
    //return RxMap<String, Department>();
  }

  Future<void> getControlItem({required String controlNum}) async {
    String CNO = "";
    if (isLink(controlNum)) {
      final Uri uri = Uri.parse(controlNum);
      final queryParameters = uri.queryParameters;

      if (queryParameters.containsKey('CNo')) {
        log("contains CNO");
        CNO = queryParameters['CNo']!;
        controlNum = CNO;
        log("controlNum is $controlNum now");
        Get.back();
      } else {
        log(" doesnt contains CNO");
        if (Get.context != null){}
          // showCupertinoDialog(
          //     context: Get.context!,
          //     builder: (builder) => CupertinoAlertDialog(
          //             title: Text("Error"),
          //             content: Text("Invalid Control Number"),
          //             actions: [
          //               CupertinoDialogAction(
          //                   child: Text("OK"),
          //                   onPressed: () {
          //                     Get.back();
          //                   })
          //             ]));
        else
          controlItem.value =
              ControlItem(controlNo: "Control # Not found in link");

        //return ""; // Or throw an exception if CNO is mandatory
      }
    } else {
      log("not a link");
    }

    // // print"getControlItem called");
    // // printcontrolNum);
    // // print"Get Control Info : ${storageBox.read("role").toString()}");
    final Map<String, String> params = {
      'type': "1",
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'EquipmentID': "0",
      'ControlNo': controlNum
    };
    //Get Id from QR code
    final response = await http.get(Uri.parse(
            "https://${storageBox.read('api_url')}$getControlInfoEndpoint")
        .replace(queryParameters: params));
     print("Get control item response : " + response.body);
    controlItem.value = ControlItem.fromJson(jsonDecode(response.body));
   print("getControlItem equip ${controlItem.value.equipName}");
  // print"getControlItem equip ${storageBox.read("role").toString()}");
    // Get.to(() => const NewEquipWorkOrderFrom());
  }

  bool isLink(String text) {
    return (text.contains("https://") || text.contains("www"));
  }

  Future<void> fetchNewWorkOrderOptions() async {
    // if()

    try {
      final Map<String, String> params = {
        'Type': '1',
        'UserID': storageBox.read("id").toString(),
        'EquipmentTypeID': storageBox.read("role").toString(),
      };
// // printUri.parse(
      //   "https://${storageBox.read('api_url')}$getNewOrderOptionsEndPoint}",
      //  ).replace(queryParameters: params));
      final response = await http.get(
        Uri.parse(
          "https://${storageBox.read('api_url')}$getNewOrderOptionsEndPoint}",
        ).replace(queryParameters: params),
      );

      // // print"fetchNewWorkOrderOptions 4 sites${response.body}");
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
        // // print"DATAAA 4 sites${siteNames.length}");
        // // print"DATAAA 4 sites${categories.length}");
        // // print"DATAAA 4 sites${callTypes.length}");
      }
    } catch (e) {
      if (foundation.kDebugMode) {
        // rethrow;
      } else {
        Get.snackbar("Error", "Could not fetch WOs Options data");
      }
    }
  }
Rx<bool> isCreating = false.obs;
  Future<CreateWorkOrderDTO> createWorkOrder(WorkOrder workOrder) async {
    // // printworkOrder.imageFile);
  isCreating.value = true;
    var url =
        "https://${storageBox.read('api_url')}${createWorkOrderEndpoint}"; // Replace with your URL
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var multipartFile;
    // Prepare the image file for upload
    if (workOrder.imageFile != null) {
      multipartFile = await http.MultipartFile.fromPath(
          'imageFile', workOrder.imageFile!.path);
      request.files.add(multipartFile);
    }
    log(storageBox.read('api_url'));

    log("serviceInfo num # : ${serviceInfo.value.Id}");

    String role = storageBox.read("role").toString();
    // if (role == "" || role.isEmpty) role = "2";
    // Add other data (replace with your actual data fields)
    request.fields['EquipmentID'] = serviceInfo.value.Id ?? "0";
    request.fields['CallTypeID'] = workOrder.callTypeID ?? "";
    request.fields['IsUrgent'] = workOrder.isUrgent.toString();
    request.fields['FaultStatus'] = workOrder.faultStatues ?? "";
    request.fields['RoomID'] = workOrder.roomId ?? "12";
    request.fields['Type'] = workOrder.type.toString();
    request.fields['UserID'] = storageBox.read("id").toString();
    request.fields['EquipmentTypeID'] =storageBox.read("role").toString();
    

    request.fields['NewOrEdit'] = "0";

    // Send the request
    var response = await request.send();
    //// // print"Response status: ${response.reasonPhrase}");
    //final response2 = await http.Response.fromStream(response);

    // final body = response2.body;
    // // // print"Crete WO response : " + body);
    //      var data =await responseData(response);
    //        // // print"Crete WO MAP : " + data.toString());

    if (response.statusCode == 200) {
      CreateWorkOrderDTO createWODTO =
          CreateWorkOrderDTO(success: 0, message: "Connaction faliure");
      if (response.statusCode == 200) {
        var data = await responseData(response);
         await Future.delayed(Duration(seconds: 1));
  isCreating.value = false;
        return CreateWorkOrderDTO(
            success: 1, message: "Created successfully", jobNum: data["JobNO"]);
      } else {
        createWODTO.message = "MISSING DATA";
      }
       await Future.delayed(Duration(seconds: 1));
        isCreating.value = false;
      return createWODTO;
    } else {
       await Future.delayed(Duration(seconds: 1));
        isCreating.value = false;
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
