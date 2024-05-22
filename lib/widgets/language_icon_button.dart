import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
class LanguageIconButton extends StatelessWidget {
  const LanguageIconButton({
    super.key,
  });

  void toggleLanguage(){
    if (Get.locale?.languageCode.toString().toLowerCase() == "ar") {
        storageBox.write('languageCode',"en") ;
      Get.updateLocale(Locale("en"));
    } else {
        storageBox.write('languageCode',"ar") ;
      Get.updateLocale(Locale("ar"));
    }
  }

  @override
  Widget build(BuildContext context) {
      return Row(
        children: [
          IconButton(onPressed: ()=>toggleLanguage() , icon: Icon(Icons.language), color: Colors.white, ),
          Text(Get.locale?.languageCode.toUpperCase() ?? "",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 45.sp)), ],
      );
    } 
  }

