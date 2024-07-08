import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'dart:async';

import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';
import 'package:steady_solutions/screens/home_screen.dart';


class InitialScreen extends StatelessWidget {
  final storage = GetStorage();

  AuthController _authController = Get.find<AuthController>();

  Future<bool> checkApi() async {
    try{
       await _authController.getEquipIds();
        return true;

    }
    catch (e) {
          return false;
    }
      
      // Get.dialog( AlertDialog(
      //   title: Text("ERROR"),
      //   content: Text("Can not connect to the server. Please check your internet connection and try again."),
        
    // ));
    

   
  // bool isApiRunning = false;
            
  //   try {
  //     log("NEW) URL : ${storageBox.read('api_url')}");
  //    final response = await http.get(
  //         Uri.parse("https://${storageBox.read('api_url')}$getEquipTypeIdsEndPoint"));
  //     log("NEW) test api response body : ${response.body}");

  //     if (response.statusCode == 200) {
  //       log("NEW) API IS RUNNING");
  //       return true;
  //     }
  //   } catch ( e) {
  //     log("NEW) API TEST EXCPPETION e : $e");
  //     if(kDebugMode)
  //     rethrow;
  //     else
  //     return false;
  //   }
    
  //   return isApiRunning;
  }
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      
      bool isLoggedIn = storage.read('isLoggedIn') ?? false;
      bool isApiRunning = false;
      if (storage.read('api_url') !=null && storage.read("api_url") != "");
         isApiRunning = await checkApi();

      if (isLoggedIn && isApiRunning) {
        Get.off(() => HomeScreen());
      } else if (!isApiRunning) {
        Get.off(() => ApiAddressScreen());
      } else {
        Get.off(() => LoginScreen());
      }
    });

    return Material(
      child: Scaffold(
        body: Center(child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(color: Colors.white),
            SizedBox(height: 20),
            Text("Loading, please wait...",style: TextStyle(color: Colors.white),)
          ],
        ))),
      ),
    );
  }
}
