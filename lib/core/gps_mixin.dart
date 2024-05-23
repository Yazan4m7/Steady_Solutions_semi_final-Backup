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

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
      return [position.latitude,position.longitude];
    
  }
}