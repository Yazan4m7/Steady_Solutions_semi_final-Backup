import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/main.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/core/utils/main_bindings.dart';
import 'package:steady_solutions/screens/auth/api_address_screen.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';
import 'package:steady_solutions/screens/dashboard/dashboard.dart';
import 'package:steady_solutions/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//   statusBarColor: Colors.transparent, 
// ));
SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  statusBarColor: Colors.transparent, // Set the status bar color to transparent
 statusBarIconBrightness: Brightness.light, // Set the icon color (light or dark)
));
  MainBindings().dependencies();
  //MainBindings().overloadAPI();
  //_auth.employee.value = Employee.fromJson(storageBox.read("userAccount"));
 
  //print(_auth.employee.value.id);
  //print(" employee from storage : ${storageBox.read("userAccount")}");

  //await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  //); /*.then((value) => Get.put(AuthController()));*/
  //initializeFCM();
  //wait GetStorage.init();
  // await setupLocalNotification();
  // if(UITestingMode)
  // clearData();
  //storageBox.erase();
  //await myErrorsHandler.initialize();
  //FlutterError.onError = (details) {
  //debugPrint("=============== FLUTTER ERROR CAUGHT IN MAIN METHOD");
  //debugPrint("==== $details");
  //FlutterError.presentError(details);
  // runApp(FatalErrorScreen(details: details));
  //};
  //PlatformDispatcher.instance.onError = (error, stack) {
  //  myErrorsHandler.onError(error, stack);
  //debugPrintnt("err");
  //  return false;
  //};

  runApp(const SteadySolutionsApplication()); // starting point of app
}

class SteadySolutionsApplication extends StatefulWidget {
  const SteadySolutionsApplication({super.key});

  @override
  _SteadySolutionsApplicationState createState() {
    return _SteadySolutionsApplicationState();
  }

  static void setLocale(BuildContext context, Locale newLocale) async {
    _SteadySolutionsApplicationState? state =
        context.findAncestorStateOfType<_SteadySolutionsApplicationState>();

    storageBox.write('languageCode', newLocale.languageCode);
    storageBox.write('countryCode', "");

    state?.setState(() {
      state._locale = newLocale;
    });
  }
}

final ApiAddressController _apiController = Get.find<ApiAddressController>();

class _SteadySolutionsApplicationState
    extends State<SteadySolutionsApplication> {
  final AuthController _authController = Get.find<AuthController>();
  final ApiAddressController _apiController = Get.find<ApiAddressController>();
  late Locale _locale;
  static void setLocale(BuildContext context, Locale newLocale) async {
    _SteadySolutionsApplicationState? state =
        context.findAncestorStateOfType<_SteadySolutionsApplicationState>();

    storageBox.write('languageCode', newLocale.languageCode);
    storageBox.write('countryCode', "");

    state?.setState(() {
      state._locale = newLocale;
    });
  }

  Future<Locale> _fetchLocale() async {
    String languageCode = storageBox.read('languageCode') ?? "";
    if (languageCode.isEmpty) {
      languageCode = "en";
      print(" No Preferenced language found, set to default : $languageCode");
    }
    setLocale(context, Locale(languageCode));

    return Locale(languageCode);
  }

  @override
  void initState() {
    
    super.initState();
    _fetchLocale().then((locale) {
      _locale = locale;
      Get.updateLocale(locale);
      setState(() {
        _locale = locale;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
      //     ScreenUtil.init(
      //       context, designSize: Size(1080, 1920), 
        
      //   minTextAdapt: true,
      //  );
  //  return ScreenUtilInit(
  //     designSize: const Size(1080, 1920),
  //     minTextAdapt: true,
  //     splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
    //  builder: (_ , child) {

_locale = Locale("en","us");
// SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
//   SystemUiOverlay.
// ]);
  ScreenUtil.ensureScreenSizeAndInit(
  designSize: const Size(1080, 1920),
   minTextAdapt: true,
  splitScreenMode: true,
  context);
    return MediaQuery(
  //Setting font does not change with system font size
  
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: GlobalLoaderOverlay(
        useDefaultLoading: true,
        overlayWidgetBuilder: (_) {
          //ignored progress for the moment
          return Center(
              child: SpinKitCubeGrid(
            color: kPrimaryColor3BrightBlue,
            size: 50.0,
          )
              // child: Lottie.asset(
              //   fit: BoxFit.contain,
              //      // frameRate: FrameRate.max,
              //      //repeat: true,
              //      // reverse: false,
              //      // animate: true,
              //       filterQuality: FilterQuality.high,
              //      // width: 200,
              //      // height: 200,
              //   'assets/json_animations/gradient_loading.json',
      
              // ),
              );
        },
        overlayColor: Color.fromARGB(255, 233, 233, 233).withOpacity(0.8),
        child: GetMaterialApp(
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // ignore: prefer_const_literals_to_create_immutables,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: defaultWhiteTheme,
      
          // GetX Controller Binding is in the main method
          debugShowCheckedModeBanner: false,
          //navigatorKey: navigatorKey,
          home:ApiAddressScreen() ,
          // home: Dashboard(),
        ),
      ),
    );
 // }
 // );
    }


    }
// class FatalErrorScreen extends StatelessWidget {
//   final FlutterErrorDetails details;
//   const FatalErrorScreen({super.key, required this.details});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Dialog.fullscreen(
//                     child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   Text(
//                     "FATAL ERROR OCCOURED", //AppLocalizations.of(context).fatal_error,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   Text(
//                     '${details.exceptionAsString()}\n${details.stack.toString()}',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ]))),
//           ),
//         ),
//       ),
//     );
//   }
// }


// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   SendToHome(){
//      Future.delayed(const Duration(seconds: 3), () {
//       Get.offAll(() => initalScreen());
//     });
  
//   }
//   @override
//   Widget build(BuildContext context) {
//     SendToHome();
//     return Container( 
//       color: Colors.white, 
//       child: Image.asset( 'assets/splash_screen/steadyOMS_Colored.png', fit: BoxFit.contain, width: 200.w, height: 200.h,  )
//     ); 
//   } 
// }