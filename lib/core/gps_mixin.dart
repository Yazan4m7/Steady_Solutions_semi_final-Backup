import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

mixin GPSMixin {

  Future<dynamic> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
        print("Location services are disabled.");
           Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text( "Location services are disabled."),
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
        
        return;
    
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
                Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text("Location permissions are denied."),
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
    
        return;
        
      }
    }

    if (permission == LocationPermission.deniedForever) {
     
        print("Location services are denaid forever.");
      
          Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Location permissions are permanently denied'),
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
      return;
     
    }
   
        print("Location services are alowed, getting location.");
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    
      return [position.latitude,position.longitude];
    
  }
}