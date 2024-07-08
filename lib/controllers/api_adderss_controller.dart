import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';


class ApiAddressController extends GetxController {
  // Path: lib/application/0.api_address/api_adderss_controller.dart

  RxString apiAddress = "".obs;

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
  //  context.loaderOverlay.show();
      url = url.trim();
      print("url not empty ===> testing url : $url");
      apiAddress.value = url;
      storageBox.write("api_url",url);
      if (await testApiAddress(context)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("Portal passed the test, navigating to login screen");
          storageBox.write("api_url",url);

          apiAddress.value = url;
  
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginScreen()));
        });
      } else {
        showWrongPortalAddressDialog(context);
      }
    
 
  

    isLoading.value = false;
  }

  Future<bool> testApiAddress(context) async {
 

      bool isApiRunning = false;
           String url = storageBox.read("api_url") ;

              apiAddress.value= url;
    try {
      print("URL : ${storageBox.read('api_url')}");
     final response = await http.get(
          Uri.parse("https://${storageBox.read('api_url')}$getEquipTypeIdsEndPoint"));
      print("test api response body : ${response.body}");

      if (response.statusCode == 200) {
        print("API response CODE : ${response.statusCode}");
        isApiRunning = true;
      } else {
        isApiRunning= false;
      }
    } catch ( e) {
      //if(kDebugMode)
      //rethrow;
      //showWrongPortalAddressDialog(context);
      storageBox.write("isLoggedIn", false);
     isApiRunning = false;
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
