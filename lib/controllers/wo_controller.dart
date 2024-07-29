<<<<<<< HEAD
=======
import 'dart:async';
>>>>>>> 045059f (First Testing Version)
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/gestures.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:http_parser/http_parser.dart';
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
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:steady_solutions/screens/notifications/notifications_screen.dart';
<<<<<<< HEAD
=======
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
>>>>>>> 045059f (First Testing Version)

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
  Rx<ControlItem> assetItem = ControlItem().obs;

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
  void clearData() {

;
    departments = <String, Department>{}.obs;
    rooms = <String, Room>{}.obs;
    assetItem.value = ControlItem();

  }

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

  Future<RxMap<String, Department>> getRoomsList(
      {required String departmentId}) async {
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
    final response = await http.get(
        Uri.parse("https://${storageBox.read('api_url')}$getRoomsListEndPoint")
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

<<<<<<< HEAD
  Future<AchievementReport> getAchievementReport(int reportId) async {
=======
  Future<AchievementReport> getAchievementReport(int reportId, String passedParDate, String notificationedTypeId) async {
>>>>>>> 045059f (First Testing Version)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });
    AchievementReport report = AchievementReport();
    print("sending report id : $reportId");
    final Map<String, String> params = {
      'CMReportID': reportId.toString(),
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
<<<<<<< HEAD
=======
      'NotificationTypeID': notificationedTypeId,
      'PassedParDate' : passedParDate.toString()
>>>>>>> 045059f (First Testing Version)
    };
    // // print Uri.parse(
    //     ghryS   "https://${storageBox.read('api_url')}$getAchievementReportEndPoint")
    //    .replace(queryParameters: params));
    final response = await http.get(
      Uri.parse(
              "https://${storageBox.read('api_url')}$getAchievementReportEndPoint")
          .replace(queryParameters: params),
    );

    print("Get ach report info response : " + response.body);
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
<<<<<<< HEAD
=======
         log(response.body);
>>>>>>> 045059f (First Testing Version)
    if (response.statusCode == 200) {
      List temp = jsonDecode(response.body)["Departments"];
      debugPrint(temp.length.toString() + " departments");
      temp.forEach((item) {
        departments[item["Text"]] = Department.fromJson(item);
      });
<<<<<<< HEAD
      // return departments;
=======
     
       log("get dpartments response with none 200 code : ${response.body}");
>>>>>>> 045059f (First Testing Version)
    }
    //return RxMap<String, Department>();
  }

  Future<void> getAssetItemById({required String assetIdOrLink}) async {

    if (isLink(assetIdOrLink)) {
<<<<<<< HEAD
      assetIdOrLink = extractControlNumberFromLink(assetIdOrLink);
    }
    
=======
      log("assetIdOrLink is link");
      assetIdOrLink = extractControlNumberFromLink(assetIdOrLink);
    }
     print("assetIdOrLink is not link :  $assetIdOrLink");
>>>>>>> 045059f (First Testing Version)
    final Map<String, String> params = {
      'type': "1",
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'EquipmentID': "0",
      'ControlNo': assetIdOrLink
    };


    final response = await http.get(Uri.parse(
            "https://${storageBox.read('api_url')}$GetControlInfoByIDEndPoint")
        .replace(queryParameters: params));
    print("Get control/service item response : " + response.body);
    assetItem.value = ControlItem.fromJson(jsonDecode(response.body));

    print("getControlItem equip ${assetItem.toJson()}");
   
  }

  String extractControlNumberFromLink(String assetId, ) {
     log("extractControlNumberFromLink ");;
    String CNO = "";
    final Uri uri = Uri.parse(assetId);
    final queryParameters = uri.queryParameters;
    
    if (queryParameters.containsKey('CNo')) {
      log("contains CNO");
      CNO = queryParameters['CNo']!;
      assetId = CNO;
      log("controlNum from link is $assetId now");
     return assetId;
    }
      else
       showCupertinoDialog(
           context: Get.context!,
           builder: (builder) => CupertinoAlertDialog(
                   title: Text("Error"),
                   content: Text("Link doesnt has a control number in it\n ERR385CNO"),
                   actions: [
                     CupertinoDialogAction(
                         child: Text("OK"),
                         onPressed: () {
                           Get.offAll(()=>  HomeScreen());
                         })
                   ]));
      
    
      return ""; 
    }
  

  
Future<void> getAssetItemByCatAndDept(
      {required String departmentId, required String categoryId}) async {
    print(
        " getAssetItemByIdGet Control Info : categoryId $categoryId   - departmentId : $departmentId");
    final Map<String, String> params = {
      'CategoryID': categoryId,
      'DepartmentID': departmentId,
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
    };

    final response = await http.get(Uri.parse(
            "https://${storageBox.read('api_url')}$GetServiceInfoByCatByDep")
        .replace(queryParameters: params));
    print(Uri.parse(
            "https://${storageBox.read('api_url')}$GetServiceInfoByCatByDep")
        .replace(queryParameters: params)
        .toString());
    print("Get getAssetItemByCatAndDept item response : " + response.body);
    assetItem.value = ControlItem.fromJson(jsonDecode(response.body));

    print("getAssetItemByCatAndDept equip ${assetItem.toJson()}");
  }

<<<<<<< HEAD
  Future<void> getAssetItemByQRCode({required String assetId}) async {
=======
 // Future<void> getAssetItemByQRCode({required String assetId}) async {
>>>>>>> 045059f (First Testing Version)
    //Get Id from QR code
    // final response = await http.get(Uri.parse(
    //         "https://${storageBox.read('api_url')}$getControlInfoEndpoint")
    //     .replace(queryParameters: params));
    // print("Get control item response : " + response.body);
    // assetItem.value = ControlItem.fromJson(jsonDecode(response.body));
    // print("getControlItem equip ${assetItem.value.equipName}");
    // print("getControlItem equip ${assetItem.toJson()}");
    // Get.to(() => const NewEquipWorkOrderFrom());
<<<<<<< HEAD
  }

  bool isLink(String text) {
    return (text.contains("https://") || text.contains("www"));
=======
 //}

  bool isLink(String text) {
    return (text.contains("http") || text.contains(".com"));
>>>>>>> 045059f (First Testing Version)
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
<<<<<<< HEAD
    var url =
        "https://${storageBox.read('api_url')}${createWorkOrderEndpoint}"; // Replace with your URL
    var request = http.MultipartRequest('POST', Uri.parse(url));
   request.headers['Content-Type'] = 'application/json';
=======
 
    if (!validateRequestFields(workOrder)) {
       isCreating.value = false;
      return CreateWorkOrderDTO(success: -1, message: "Missing data");
    }

    var url =
        "https://${storageBox.read('api_url')}${createWorkOrderEndpoint}"; // Replace with your URL
 
>>>>>>> 045059f (First Testing Version)
    // Prepare the image file for upload
    // if (workOrder.imageFile != null) {
    //   multipartFile = await http.MultipartFile.fromPath(
    //       'imageFile', workOrder.imageFile!.path);
    //   request.files.add(multipartFile);
    // }
<<<<<<< HEAD
  
=======
 
   var request = http.MultipartRequest('POST', Uri.parse(url));
   request.headers['Content-Type'] = 'application/json';
>>>>>>> 045059f (First Testing Version)
    String userId = workOrder.userId ?? storageBox.read("id").toString();
    request.fields['EquipmentID'] = assetItem.value.id ?? "0";
    request.fields['CallTypeID'] = workOrder.callTypeID ?? "";
    request.fields['IsUrgent'] = workOrder.isUrgent.toString();
    request.fields['FaultStatus'] = workOrder.faultStatues ?? "";
    request.fields['RoomID'] = workOrder.roomId ?? "0";
    request.fields['Type'] = workOrder.type.toString();
    request.fields['UserID'] = userId;
    request.fields['EquipmentTypeID'] = storageBox.read("role").toString();
    request.fields['NewOrEdit'] = "0";

<<<<<<< HEAD


/// TODO : Valided Request Fields before sending
/////////////////// IMAGE UPLOAD
///
 if (workOrder.imageFile != null) {
   

// request.fields['ImageFile'] = ''; 
//     final imageAsBytes = workOrder.imageFile!.readAsBytesSync();

//     log(imageAsBytes.toString());

// final compressedBytes = await testCompressFile(workOrder.imageFile!);
// request.files.add(http.MultipartFile.fromBytes(
//   'ImageFile', // Replace with the expected field name in your API
//   compressedBytes,
//   contentType: MediaType('image', 'jpeg'), // Set the image content type (adjust if needed)
//  ),);
 //  request.files.add(await http.MultipartFile.fromPath('ImageFile', workOrder.imageFile!.path, filename: "noty"));

  
 }
 
//  final compressedImage = await compressImage(workOrder.imageFile!);
//     final bytes = await compressedImage.readAsBytes();
//     final base64Image = base64Encode(bytes);
//    request.fields['ImageFile'] = base64Image;
// String encodeImageToBase64(List<int> imageBytes) {
//   return base64Encode(imageBytes);
// }

final compressedImage = await compressImage(workOrder.imageFile!);
    final bytes = await compressedImage.readAsBytes();
    final base64Image = base64Encode(bytes);

final imagePart = http.MultipartFile.fromString(
  'ImageFile', // Use the expected parameter name here
  base64Image, // Pass the Base64-encoded string directly
  contentType: MediaType('image', 'jpg'), // Specify content type with MIME type
);
request.files.add(imagePart);
print("data:image/jpeg;base64" +base64Image);
=======
///  Valided Request Fields before sending///
  if (workOrder.imageFile != null) {
    final mimeType = lookupMimeType(workOrder.imageFile!.path);
    if (mimeType == null) {
      throw Exception('Could not determine file mime type');
    }
    final contentType = MediaType(mimeType.split('/')[0], mimeType.split('/')[1]);

    // Compress the image if needed
    final compressedImage = await compressImage(workOrder.imageFile!);
    final bytes = await compressedImage.readAsBytes();

    // Add the file to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'imageFile',
        bytes,
        filename: basename(workOrder.imageFile!.path),
        contentType: contentType,
      ),
    );
  }
>>>>>>> 045059f (First Testing Version)
//////////////////// END OF IMAGE UPLOAD
try{
    // Send the request
    log("response 2 : ${"sendting create WO request"}");
     log(request.fields.toString());
<<<<<<< HEAD
    var response = await request.send();
    log("Response status: ${response.reasonPhrase}");
    log("user id # : ${storageBox.read("id").toString()}");
    //final response2 = await http.Response.fromStream(response);
    //log("response 2 : ${response2.body}");
    //final body = response.stream.transform(utf8.decoder).join();
    //log("Crete WO response : " + body.toString());
    var data = await responseData(response);
    // // print"Crete WO MAP : " + data.toString());
=======
    var response = await request.send().timeout(Duration(seconds: 10));
    log("Response status: ${response.reasonPhrase}");
    var data = await responseData(response);

>>>>>>> 045059f (First Testing Version)
    log(response.toString());
 CreateWorkOrderDTO createWODTO = CreateWorkOrderDTO(success: 0, message: "");
      if (response.statusCode == 200) {
       
        log("Crete WO MAP1 : " + data.toString());
        isCreating.value = false;
        return CreateWorkOrderDTO(
            success: 1, message: "Created successfully", jobNum: data["JobNO"]);
      } else {
        createWODTO.message = "MISSING DATA";
      }
      log("Crete WO MAP2 Failed : " + data.toString());
      isCreating.value = false;
      return createWODTO;
      } catch(e){
<<<<<<< HEAD
        isCreating.value = false;
=======
          if (e is TimeoutException) {
            print('The request timed out.');
          } else {
            print('Error occurred while uploading image: $e');
          }
>>>>>>> 045059f (First Testing Version)
        if(foundation.kDebugMode){
          rethrow;
        }
        print("ERROR : " + e.toString());
<<<<<<< HEAD
        return CreateWorkOrderDTO(success: 0, message: "Failed to create WO (err185)");
=======
        return CreateWorkOrderDTO(success: 0, message: "Server respond is unknown (ERR185)");
>>>>>>> 045059f (First Testing Version)

      }
   
   
  }
  Future<XFile> compressImage(File file) async {
  final dir = await getTemporaryDirectory();
  final targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 50,
  );

  return result!;
}
Future<foundation.Uint8List> testCompressFile(File file) async {
  final imageBytes = await file.readAsBytes();
  var result = await FlutterImageCompress.compressWithList(
    imageBytes,
    minWidth: 2300,
    minHeight: 1500,
    quality: 94,
    rotate: 90,
  );
  return result;
}
  Future<Map<String, dynamic>> responseData(
      http.StreamedResponse response) async {
    final responseBody = await response.stream.bytesToString();
    log("get control response : " + responseBody.toString());
    final data = jsonDecode(responseBody); // Assuming JSON response
    return data; // Return the decoded data
  }
<<<<<<< HEAD
=======


bool validateRequestFields(WorkOrder workOrder) {

  /*    String userId = workOrder.userId ?? storageBox.read("id").toString();
    request.fields['EquipmentID'] = assetItem.value.id ?? "0";
    request.fields['CallTypeID'] = workOrder.callTypeID ?? "";
    request.fields['IsUrgent'] = workOrder.isUrgent.toString();
    request.fields['FaultStatus'] = workOrder.faultStatues ?? "";
    request.fields['RoomID'] = workOrder.roomId ?? "0";
    request.fields['Type'] = workOrder.type.toString();
    request.fields['UserID'] = userId;
    request.fields['EquipmentTypeID'] = storageBox.read("role").toString();
    request.fields['NewOrEdit'] = "0";
*/
log("validate request fields call type : ${workOrder.callTypeID}");
  if (assetItem.value.id == null ) {
    Get.snackbar("Fail", "Asset is required");
    return false;
  }
   if (workOrder.roomId == null ) {
    Get.snackbar("Fail", "Room is required");
     return false;
  }
    if (workOrder.callTypeID == null ||  workOrder.callTypeID == "null" ) {
    Get.snackbar("Fail", "Call Type is required");
     return false;
  }
       if (storageBox.read("id") == null ) {
    Get.snackbar("Fail", "Emp. ID is required");
     return false;
  }
       if (workOrder.isUrgent == null ) {
    Get.snackbar("Fail", "is Urgent is required");
     return false;
  }
     if (storageBox.read("role") == null ) {
    Get.snackbar("Fail", "Emp. Role is required");
     return false;
  }
  return true;
}
>>>>>>> 045059f (First Testing Version)
}
