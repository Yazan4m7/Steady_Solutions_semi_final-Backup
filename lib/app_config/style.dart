import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:steady_solutions/app_config/app_theme.dart';

String fontFamily = 'ProductSans';

// ****** MAIN COLORS ****** //

// card back gron and buttton
Color kPrimaryColor1Green = Color(0xff00AC54);
// drawer bg  1C2C3C,
Color kPrimeryColor2NavyDark = Color(0xff1C2C3C);
// card bg c6d8ff,
Color kPrimaryColor3BrightBlue = Color(0xffc6d8ff);
// card bg  btn bg head icon bg 71a9f7,
Color kPrimaryColor4MidBlue = Color(0xff71a9f7);
// card bg list line charts f5e0b7
Color kPrimaryColor3Yellow = Color(0xfff5e0b7);
// Container bg, Text color 1
Color kPrimerWhite = Color.fromARGB(255, 244, 255, 245);
//  Text color 2
Color kPrimeryBlack = Color.fromARGB(255, 33, 33, 33);

Color kHintColor = Color.fromARGB(255, 110, 110, 110);

Color drawerBgColor = Color.fromARGB(255, 65, 77, 112);
Color kTFprimaryColor = Color.fromARGB(255, 55, 137, 67); // Your primary color
Color kTFsecondaryColor = Color.fromARGB(255, 107, 107, 107);
// Equipment Type font color
 Color secondary_light_blue = Color(0xffd1e4f8);
////////// Text Widgets font color //////////
Color bodyColor = Color.fromARGB(255, 105, 122, 144);

Color greyTextColor = Color.fromARGB(255, 132, 132, 132);

////////////////// TEXT STYLES ///////////////////////
TextStyle inputTextStyle =
    TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontSize: 42.sp);
TextStyle hintTextStyle = TextStyle(color: kHintColor, fontSize: 42.sp);
TextStyle blueClickableText =
    TextStyle(color: Colors.blueAccent, fontSize: 42.sp);
TextStyle dropDownTextStyle =
    TextStyle(color: const Color.fromARGB(255, 41, 41, 41), fontSize: 40.sp);
TextStyle inputHintStyle = TextStyle(color: Colors.grey, fontSize: 45.sp);
TextStyle dialogInnerDetailsTextStyle =
    TextStyle(color: Color.fromARGB(255, 48, 48, 48), fontSize: 43.sp,fontWeight: FontWeight.w300);
TextStyle dialogValueTitlesDetailsTextStyle =
    TextStyle(color: Color.fromARGB(255, 25, 25, 25), fontSize: 45.sp,fontWeight: FontWeight.w600);
TextStyle dialogTitleTextStyle = TextStyle(
    color: kPrimeryColor2NavyDark,
    fontSize: 65.sp,
    fontWeight: FontWeight.w700);
////////////////// Text Fields Styles ///////////////////////
InputDecoration kTextFieldDecoration = InputDecoration(
  
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color:primery_blue_grey_color
            .withOpacity(0.8)), // Change this color to your preference
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    
  ),
  disabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(
        color: Color.fromARGB(255, 116, 116, 116)), // Change this color to your preference
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
        color:primery_blue_grey_color), // Change this color to your preference
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  ),
  prefixIcon: const Icon(Icons.link),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
  // labelText: '',
  labelStyle: TextStyle(color: const Color.fromARGB(255, 26, 26, 26), fontSize: 45.sp),
);

////////////////// Buttons Styles ///////////////////////
ButtonStyle kPrimeryBtnStyle(BuildContext context) {
  return ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust border radius
        side: BorderSide(color: grey_bg_color),
      ),
    ),
    padding: WidgetStateProperty .all(EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .19,
        vertical: MediaQuery.of(context).size.height * .013)),
    // Adjust these colors to your preference
    alignment: Alignment.center,
    foregroundColor:
        WidgetStateProperty .all<Color>(Colors.white),
    backgroundColor:
        WidgetStateProperty .all<Color>(primery_blue_color), // Blue color
    overlayColor: WidgetStateProperty .all<Color>(primery_blue_color),
    
    // shape: WidgetStateProperty .all<RoundedRectangleBorder>(
  
    //   RoundedRectangleBorder(
        
    //     borderRadius: BorderRadius.circular(20.0), // Adjust border radius
      
    //   ),
    //),
  );
}
ButtonStyle kPrimeryBtnNoPaddingStyle(BuildContext context) {
  return ButtonStyle(
    padding: WidgetStateProperty .all(EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .08,
        vertical: MediaQuery.of(context).size.height * .013)),
    // Adjust these colors to your preference
    alignment: Alignment.center,
    foregroundColor:
        WidgetStateProperty .all<Color>(Color.fromARGB(255, 255, 255, 255)),
    backgroundColor:
        WidgetStateProperty .all<Color>(primery_blue_color), // Blue color
    overlayColor: WidgetStateProperty .all<Color>(Color(0xFF1f2e38)),
    shape: WidgetStateProperty .all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust border radius
      ),
    ),
  );
}
ButtonStyle kSmallBtnStyle(BuildContext context) {
  return ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .09,
        vertical: MediaQuery.of(context).size.height * .01)),
    // Adjust these colors to your preference
    foregroundColor:
        MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF00a853)),
    overlayColor:
        MaterialStateProperty.all<Color>(Color(0xFF1f2e38)), // Blue color
    //overlayColor: MaterialStateProperty.all<Color>(Color(0xFF4272aa)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust border radius
      ),
    ),
  );
}

ButtonStyle kSmallSecondaryBtnStyle(BuildContext context) {
  return ButtonStyle(
    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .06,
        vertical: MediaQuery.of(context).size.height * .01)),
    // Adjust these colors to your preference
    foregroundColor:
        MaterialStateProperty.all<Color>(primery_blue_color),
    backgroundColor:
        MaterialStateProperty.all<Color>(secondary_light_blue),
    overlayColor: MaterialStateProperty.all<Color>(
        Color.fromARGB(255, 229, 229, 229)), // Blue color
    //overlayColor: MaterialStateProperty.all<Color>(Color(0xFF4272aa)),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Adjust border radius
      ),
    ),
  );
}

const double dialogPadding = 20;
const double dialogAvatarRadius = 35;
const double defaultPadding = 16.0;
