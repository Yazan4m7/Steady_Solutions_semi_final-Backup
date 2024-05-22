
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';
import 'package:steady_solutions/widgets/misc/custom_dialog.dart';
class ApiAddressController extends GetxController {
    // Path: lib/application/0.api_address/api_adderss_controller.dart

    RxString apiAddress  = "" .obs;
    Rx<bool> isApiRunning = false.obs;
    StreamSubscription<String>? lisenter;
    Rx<bool> isLoading = false.obs;

  Future<void> readUrlAddressFromLocalStorage() async {
    print("Read from local storage : ${storageBox.read("api_url")}");
     apiAddress.value = storageBox.read("api_url");
    if (apiAddress.value.isEmpty || apiAddress.value == "" || storageBox.read("api_url").isEmpty || storageBox.read("api_url") == "") {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Invalid API address detetected. Please enter a valid API address.'),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAll(const ApiAddressScreen());
              },
              child: const Text('Enter URL'),
            ),
          ],
        ),
      );
      
     
    }
  }
  

  @override
  void onReady() {
   
    apiAddress.listen((value) {
      print("API LISTENER: $value");
      if ( value.isEmpty || value.length < 2 || value == "") {
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid API address detetected. Please enter a valid API address.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.offAll(const ApiAddressScreen());
                },
                child: const Text('Enter URL'),
              ),
            ],
          ),
        );
      }else{
        print("Listned to api address : $value");
      }

     });
   
    super.onReady();
  } 
  
  
    
    saveApiAddres(String url,BuildContext context) async  {
     isLoading.value = true;
     saveApiAddressToLocalStorage(url);
     saveApiAddressToMemory(url);
     testApiAddress(context);
     isLoading.value = false;
  
  }
     void saveApiAddressToLocalStorage(String url) {

    storageBox.write("api_url", url);
      print("Saved on device");
  }
    void saveApiAddressToMemory(String url) {
  
    apiAddress.value = url;
      print("after saving on memory storage : $apiAddress");
  }


   Future<void> testApiAddress(context) async {
  
         
       try {
      print(apiAddress+"======"+  apiAddress.value);
      var response = await http
          .post(Uri.parse("http://${apiAddress.value}$loginEndpoint"), body: {
        "Email": "Test@gmail.com",
        "Password": "DummyPassword",
        "EquipmentType": "1"
      });
      if (response.statusCode == 200) {
      
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
   
      } else {
        CustomDialogBox(
           title: AppLocalizations.of(context)!.wrongEntry,
           descriptions: AppLocalizations.of(context)!.checkUrlMsg,
           text: "OK",
           inBox: false,
           playSound: false,
         );
     
     
    }
      }
     catch (e) {
      if(kDebugMode)
      rethrow;
      else {
        CustomDialogBox(
        title: "Error",
        descriptions: e.toString(),
        text: "OK",
        inBox: false,
        playSound: false,
      );
      }
    }
  }

}