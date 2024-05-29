import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/gps_mixin.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/DTOs/login_DTO.dart';
import 'package:steady_solutions/models/employee.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AuthController extends GetxController with GPSMixin {
  static AuthController get instance => Get.find();

ApiAddressController _apiController = Get.find<ApiAddressController>();
  Rx<bool?> isLoggedIn = false.obs;
  Rx<Employee> employee = Employee().obs;
  bool isLoggingOut = false;
  Rx<bool> checkedIn = false.obs;

  @override
  void onReady() {
    //employee.value = Employee.fromJson(storageBox.read("userAccount"));
    employee.value.email = storageBox.read("userEmail");
    employee.value.id = storageBox.read("id").toString() ?? "0";
    employee.value.role = storageBox.read("role");
    employee.value.firstName = storageBox.read("firstName");
    employee.value.lastName = storageBox.read("lastName");
    //employee.value.email = storageBox.read("userAccount");

    //isLoggedIn.value = storageBox.read("userAccount") ?? false;
    /*
     if (employee.value.role == null || employee.value.id == null) {
      isLoggedIn.value = false;
      Get.to(() => LoginScreen());
    } else {
      isLoggedIn.value = true;
      Get.offAll(() => Dashboard());
    }
    */
    // isLoggedIn.listen((value) {
    //   if (value) {
    //     Get.offAll(() => Dashboard());
    //   } else {
    //     Get.offAll(() => LoginScreen());
    //   }
    // });
    // apiAddress.listen((value) {
    //   if (value.length > 7) {
    //     Get.offAll(() => LoginScreen());
    //   } else {
    //     Get.offAll(() => ApiAddressScreen());
    //   }
    // });
  }

  login(
      String email, String password, String role, BuildContext context) async {
          print("api address : ${_apiController.apiAddress.value}");
    var response = await http.post(
        Uri.parse("http://${storageBox.read('api_url')}$loginEndpoint?"),
        body: {"Email": email, "Password": password, "EquipmentType": role});
    LoginDTO loginDTO = LoginDTO.fromJson(jsonDecode(response.body));
    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (loginDTO.success == 1) {
        isLoggedIn.value = true;
        storageBox.write("id", json["UserID"]);
        storageBox.write("firstName", json["FirstName"]);
        storageBox.write("firstName", json["alhmoud"]);
        storageBox.write("email", email);
        storageBox.write("role", role);
        storageBox.write("isLoggedIn", true);
        storageBox.write("userAccount", employee.value);
        Get.to(() =>  HomeScreen());
      } else {
        storageBox.write("isLoggedIn", false);
        Get.dialog(Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context).login_failed,
                    style: TextStyle(fontSize: 54),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                //Image.asset("assets/images/logo.png"),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      AppLocalizations.of(context).check_credentials,
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Center(
                    child: Container(
                      height: 100.h,
                      width: 220.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 194, 38, 26),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        AppLocalizations.of(context).retry,
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    } else {
      storageBox.write("isLoggedIn", false);
      Get.dialog(Dialog(
        backgroundColor: Colors.red,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(AppLocalizations.of(context).connection_failed),
              ),
              const SizedBox(
                height: 10,
              ),
              Image.asset("assets/images/LightOMS.png"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  AppLocalizations.of(context).please_check_your_connection,
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Center(
                  child: Container(
                    height: 30,
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      AppLocalizations.of(context).retry,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
      storageBox.write("isLoggedIn", false);
    }
  }

  Future<void> logout() async {
    storageBox.write("isLoggedIn", false);
    isLoggedIn.value = false;
    employee = Employee().obs;
    //Get.offAll(() => LoginScreen());
  }

  Future<void> checkIn() async {
    String url =
        "http://${storageBox.read('api_url')}$checkInEndPoint";
    List<double> location = await getCurrentLocation();

    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'Longitude': location[1].toString(),
      'Latitude': location[0].toString(),
    };
    final response =
        await http.get(Uri.parse(url).replace(queryParameters: params));
 print("print check in response ${response.body}");
    var json = jsonDecode(response.body); 
    if(json["success"] == "false"){
      Get.dialog(Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(Get.context!).check_in_failed,
                  style: TextStyle(fontSize: 54),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
               Center(
                child: Text(
                  AppLocalizations.of(Get.context!).check_in_failed
                 ,
                  style: TextStyle(fontSize: 54),
                ),
              ),
              //Image.asset("assets/images/logo.png"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(Get.context!).youre_to_far_away_from_workplace,
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Center(
                  child: Container(
                    height: 100.h,
                    width: 220.w,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 194, 38, 26),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      AppLocalizations.of(Get.context!).close,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    else{
      checkedIn.value = true;
    }

  }

  Future<void> checkOut() async {
        String url =
        "http://${storageBox.read('api_url')}$checkOutEndPoint";
    List<double> location = await getCurrentLocation();

    final Map<String, String> params = {
      'UserID': storageBox.read("id").toString(),
      'EquipmentTypeID': storageBox.read("role").toString(),
      'Longitude': location[1].toString(),
      'Latitude': location[0].toString(),
    };
    final response =
        await http.get(Uri.parse(url).replace(queryParameters: params));
    print("print check out response ${response.body}");
    var json = jsonDecode(response.body);
    if(json['success'] == false)
              Get.dialog(
        AlertDialog(
          title:  Text(AppLocalizations.of(Get.context!).error),
          content:  Text('Check Out Failed , ${json["Message"]}'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    else
    checkedIn.value = false;
  }
}
