import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';


class ApiAddressController extends GetxController {
  // Path: lib/application/0.api_address/api_adderss_controller.dart

  RxString apiAddress = "".obs;
  Rx<bool> isApiRunning = storageBox.read("api_url") != null ? true.obs : false.obs;
  //StreamSubscription<String>? lisenter;
  Rx<bool> isLoading = false.obs;

  // Future<void> readUrlAddressFromLocalStorage() async {
  //   print("API ADDRESS in local storage : ${storageBox.read("api_url")}");
  //    apiAddress.value = storageBox.read("api_url") ??"";
  // }

  @override
  void onReady() {
    // String value = apiAddress.value;
    // print("API LISTENER: $value");
    // if ( value.isEmpty || value.length < 2 || value == "") {
    //   Get.dialog(
    //     AlertDialog(
    //       title: const Text('Error'),
    //       content: const Text('Invalid API address detetected. Please enter a valid API address.'),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Get.offAll(const ApiAddressScreen());
    //           },
    //           child: const Text('Enter URL'),
    //         ),
    //       ],
    //     ),
    //   );
    // }else{
    //   print("Listned to api address : $value");
    // }

    super.onReady();
  }

  testAndSaveAPI(String url, BuildContext context) async {
    isLoading.value = true;
    if ( url.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("url is empty");
        storageBox.remove("api_url");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ApiAddressScreen()));
      });
      showWrongPortalAddressDialog(context);
    } else {
      print("url not empty ===> testing url : $url");
      apiAddress.value = url;
      if (await testApiAddress(context)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("Portal passed the test, navigating to login screen");
          storageBox.write("api_url",url);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      }
    }
    storageBox.write("api_url", url);
    print("Saved on device");
    apiAddress.value = url;
    print("after saving on memory storage : $apiAddress");

    isLoading.value = false;
  }

  Future<bool> testApiAddress(context) async {
    bool isApiRunning = false;

    try {
      var response = await http
          .post(Uri.parse("http://${apiAddress.value}$loginEndpoint"), body: {
        "Email": "Test@gmail.com",
        "Password": "DummyPassword",
        "EquipmentType": "1"
      });
      print("response body : ${response.body}");

      if (response.statusCode == 200) {
        print("API response CODE : ${response.statusCode}");
        isApiRunning = true;
      } else {
        isApiRunning = false;
      }
    } catch ( e) {
      //if(kDebugMode)
      //rethrow;
      showWrongPortalAddressDialog(context);
      storageBox.write("isLoggedIn", false);
     
    }
     apiAddress.value = storageBox.read("api_url").toString();
    return isApiRunning;
  }

  void showWrongPortalAddressDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(AppLocalizations.of(context).connection_failed),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(AppLocalizations.of(context).checkUrlMsg),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //Image.asset("assets/images/.png"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: CupertinoDialogAction(
                        isDefaultAction:
                            true, // Makes this button visually distinct
                        child: Text(AppLocalizations.of(context).retry),
                        onPressed: () {
                          Navigator.pop(
                              context); // Perform any desired action on "OK" press
                        },
                      ),
                    )
                  ]),
            ));
  }
}
