import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steady_solutions/app_config/style.dart';



////////////////////////////////////////////////
///  USED IN THIS APP :
double titleLTextSize = 70.sp;
double titleMTextSize = 60.0.sp;
double titleSTextSize = 40.0.sp;
////// Text Widgets font size ///////
double bodyLTextSize = 43.0.sp;
double bodyMTextSize = 38.sp;
double bodySTextSize = 35.0.sp;
/////////////////////////////////////////////////

double displayLTextSize = 36.0.sp;
double displayMTextSize = 44.0.sp;
double displaySTextSize = 40.0.sp;

double headlineLTextSize = 66.0.sp;
double headlineMTextSize = 44.0.sp;
double headlineSTextSize = 40.0.sp;

/// Theses
Color primery_blue_color = Color(0xff1977dd);
Color primery_dark_blue_color = Color(0xff153d77);
Color secondary_light_blue = Color(0xff8CBEF2);
Color secondary_dark_blue =Color.fromARGB(255, 18, 79, 144);
Color primery_blue_grey_color = Color(0xff4878a6);

Color icon_wo_bg_color = primery_blue_grey_color;
Color bottom_sheet_bg_color = primery_blue_grey_color;
Color body_color = primery_blue_grey_color;
Color titles_color = primery_blue_grey_color;
Color grey_bg_color = Color(0xfff4f7fc);
//Default theme

ThemeData defaultWhiteTheme = ThemeData(
  dialogTheme: DialogTheme(
    alignment: Alignment.center,
    titleTextStyle: dialogTitleTextStyle,
    contentTextStyle: TextStyle(
      color: kPrimeryColor2NavyDark,
      fontSize: bodyMTextSize,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
  //primarySwatch: Colors.green,
  scaffoldBackgroundColor: Colors.transparent,
  disabledColor: Colors.grey,
  dialogBackgroundColor: Colors.white,
  useMaterial3: true,
  hintColor: kPrimeryBlack,

  //brightness: Brightness.light,
  primaryColor: primery_blue_grey_color,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.jost(
      color: Colors.black,
      fontSize: displayLTextSize,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: GoogleFonts.jost(
     
      color: Colors.black,
      fontSize: displayMTextSize,
      fontWeight: FontWeight.w600,
    ),
    displaySmall: GoogleFonts.jost(
      color: Colors.black,
      fontSize: displaySTextSize,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: GoogleFonts.jost(
      color: kPrimeryColor2NavyDark,
      fontSize: headlineLTextSize,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: GoogleFonts.jost(
      color: kPrimeryColor2NavyDark,
      fontSize: headlineMTextSize,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: GoogleFonts.jost(
      color: kPrimeryColor2NavyDark,
      fontSize: headlineSTextSize,
      fontWeight: FontWeight.w400,
    ),
   
   
    titleLarge: GoogleFonts.jost(
      color: titles_color,
      fontSize: titleLTextSize,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.jost(
      color: titles_color,
      fontSize: titleMTextSize,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: GoogleFonts.jost(
      color: titles_color,
      fontSize: titleSTextSize,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.jost(
      fontStyle: FontStyle.normal,
      color: body_color,
      fontSize: bodyLTextSize,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: GoogleFonts.jost(
      color: body_color,
      fontSize: bodyMTextSize,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: GoogleFonts.jost(
      color: body_color,
      fontSize: bodySTextSize,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Login equip id popup bg color
  canvasColor: Color.fromARGB(255, 47, 80, 127),

  dividerColor: Colors.grey,
  highlightColor: Colors.blue[300],
  splashColor: const Color.fromARGB(255, 145, 206, 255),
  unselectedWidgetColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: IconThemeData(size: 50.h),
    selectedLabelStyle: TextStyle(
        color: kPrimerWhite,
        fontSize: titleSTextSize,
        fontWeight: FontWeight.w600),
    unselectedLabelStyle: TextStyle(
        color: greyTextColor,
        fontSize: titleSTextSize,
        fontWeight: FontWeight.w600),
    unselectedIconTheme: IconThemeData(size: 45.h),
    showUnselectedLabels: false,
    backgroundColor: Color.fromARGB(138, 255, 255, 255),
    selectedItemColor: Colors.white,
    unselectedItemColor: const Color.fromARGB(255, 226, 226, 226),
  ),

  buttonBarTheme: const ButtonBarThemeData(
    alignment: MainAxisAlignment.spaceEvenly,
    mainAxisSize: MainAxisSize.max,
    buttonTextTheme: ButtonTextTheme.accent,
    layoutBehavior: ButtonBarLayoutBehavior.constrained,
    buttonMinWidth: 90,
    buttonHeight: 50,
    buttonPadding: EdgeInsets.all(8),
    buttonAlignedDropdown: true,
    overflowDirection: VerticalDirection.down,
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.normal,
    colorScheme: ColorScheme.light(),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    color: Color.fromARGB(255, 51, 54, 134),
    selectedColor: Color.fromARGB(255, 18, 154, 154),
    fillColor: Colors.blue[100],
    hoverColor: Colors.blue[50],
    highlightColor: Colors.blue[200],
    splashColor: Colors.blue[200],
  ),

  ///////////////////////// App Bar Theme /////////////////////////
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.hindVadodara(
      color: kPrimeryColor2NavyDark,
      fontSize: 50.0.sp,
      fontWeight: FontWeight.bold,
      letterSpacing: 2
    ),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    color: Colors.transparent,
    centerTitle: true,
    iconTheme: IconThemeData(color: kPrimaryColor3BrightBlue),
    actionsIconTheme: IconThemeData(color: kPrimeryColor2NavyDark),
    elevation: 0,
  ),
);

// ThemeData transparentWhiteTheme = ThemeData(
//   dialogTheme: DialogTheme(
//     alignment: Alignment.center,
//     titleTextStyle: dialogTitleTextStyle,
//     contentTextStyle: TextStyle(
//       color: kPrimeryColor2NavyDark,
//       fontSize: bodyMTextSize,
//       fontWeight: FontWeight.w700,
//     ),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5),
//     ),
//   ),
//   primarySwatch: Colors.green,
//   scaffoldBackgroundColor: Colors.transparent,
//   disabledColor: Colors.grey,
//   dialogBackgroundColor: Colors.white,
//   useMaterial3: true,
//   hintColor: kPrimeryBlack,

//   //brightness: Brightness.light,
//   primaryColor: kPrimaryColor3BrightBlue,
//   textTheme: TextTheme(
//     displayLarge: GoogleFonts.roboto(
//       color: Colors.black,
//       fontSize: displayLTextSize,
//       fontWeight: FontWeight.w400,
//     ),
//     displayMedium: GoogleFonts.roboto(
//       color: Colors.black,
//       fontSize: displayMTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     displaySmall: GoogleFonts.roboto(
//       color: Colors.black,
//       fontSize: displaySTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     headlineLarge: GoogleFonts.roboto(
//       color: kPrimeryColor2NavyDark,
//       fontSize: headlineLTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     headlineMedium: GoogleFonts.roboto(
//       color: kPrimeryColor2NavyDark,
//       fontSize: headlineMTextSize,
//       fontWeight: FontWeight.w400,
//     ),
//     headlineSmall: GoogleFonts.roboto(
//       color: kPrimeryColor2NavyDark,
//       fontSize: headlineSTextSize,
//       fontWeight: FontWeight.w400,
//     ),
//     titleLarge: GoogleFonts.roboto(
//       color: kPrimerWhite,
//       fontSize: titleLTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     titleMedium: GoogleFonts.roboto(
//       color: kPrimerWhite,
//       fontSize: titleMTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     titleSmall: GoogleFonts.roboto(
//       color: kPrimerWhite,
//       fontSize: titleSTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     bodyLarge: GoogleFonts.calligraffitti(
//       color: body_color,
//       fontSize: bodyLTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     bodyMedium: GoogleFonts.ptSansCaption(
//       color: body_color,
//       fontSize: bodyMTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//     bodySmall: GoogleFonts.ptSansCaption(
//       color: body_color,
//       fontSize: bodySTextSize,
//       fontWeight: FontWeight.w600,
//     ),
//   ),

//   // Login equip id popup bg color
//   canvasColor: Color.fromARGB(255, 47, 80, 127),

//   dividerColor: Colors.grey,
//   highlightColor: Colors.blue[300],
//   splashColor: Colors.blue[100],
//   unselectedWidgetColor: const Color.fromARGB(255, 225, 225, 225),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     selectedIconTheme: IconThemeData(size: 50.h),
//     selectedLabelStyle: TextStyle(
//         color: kPrimerWhite,
//         fontSize: titleSTextSize,
//         fontWeight: FontWeight.w600),
//     unselectedLabelStyle: TextStyle(
//         color: greyTextColor,
//         fontSize: titleSTextSize,
//         fontWeight: FontWeight.w600),
//     unselectedIconTheme: IconThemeData(size: 45.h),
//     showUnselectedLabels: false,
//     backgroundColor: Color.fromARGB(138, 255, 255, 255),
//     selectedItemColor: Colors.white,
//     unselectedItemColor: const Color.fromARGB(255, 226, 226, 226),
//   ),

//   buttonBarTheme: const ButtonBarThemeData(
//     alignment: MainAxisAlignment.spaceEvenly,
//     mainAxisSize: MainAxisSize.max,
//     buttonTextTheme: ButtonTextTheme.accent,
//     layoutBehavior: ButtonBarLayoutBehavior.constrained,
//     buttonMinWidth: 90,
//     buttonHeight: 50,
//     buttonPadding: EdgeInsets.all(8),
//     buttonAlignedDropdown: true,
//     overflowDirection: VerticalDirection.down,
//   ),
//   buttonTheme: const ButtonThemeData(
//     textTheme: ButtonTextTheme.normal,
//     colorScheme: ColorScheme.light(),
//   ),
//   toggleButtonsTheme: ToggleButtonsThemeData(
//     color: Color.fromARGB(255, 51, 54, 134),
//     selectedColor: Color.fromARGB(255, 18, 154, 154),
//     fillColor: Colors.blue[100],
//     hoverColor: Colors.blue[50],
//     highlightColor: Colors.blue[200],
//     splashColor: Colors.blue[200],
//   ),

//   ///////////////////////// App Bar Theme /////////////////////////
//   appBarTheme: AppBarTheme(
//     titleTextStyle: TextStyle(
//       color: kPrimeryColor2NavyDark,
//       fontSize: 20.0,
//       fontWeight: FontWeight.bold,
//       fontFamily: fontFamily,
//     ),
//     surfaceTintColor: Colors.transparent,
//     shadowColor: Colors.transparent,
//     color: Colors.transparent,
//     centerTitle: true,
//     iconTheme: IconThemeData(color: kPrimaryColor3BrightBlue),
//     actionsIconTheme: IconThemeData(color: kPrimeryColor2NavyDark),
//     elevation: 0,
//   ),
// );
