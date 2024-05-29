
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/core/data/app_sizes.dart';
import 'package:steady_solutions/core/services/responsive.dart';
import 'package:steady_solutions/screens/dashboard/dashboard.dart';
import 'package:steady_solutions/screens/work_orders/new_equip_wo_form_screen.dart';
import 'package:steady_solutions/screens/work_orders/new_service_wo_form_screen.dart';
import 'package:steady_solutions/widgets/utils/qr_scanner.dart';
import 'package:steady_solutions/widgets/utils/background.dart';
import 'package:steady_solutions/widgets/side_bar.dart';
class HomeScreen extends StatefulWidget {

   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
    
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  bool _isOpened = false;
  AnimationController? _animationController;
  Animation<double>? _progress;
 final AuthController _authController = Get.find<AuthController>();
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration:  Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });

    _progress =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    // FlutterError.onError = (FlutterErrorDetails details) {
    //   print("=================== CAUGHT FLUTTER ERROR");
    //   print("=================== =====================================");
    //   print(details);
    //   // NEVER REACHES HERE - WHY?
    // };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Get.locale?.languageCode.toString());
    return  Background(
        child: Scaffold(
          
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: DashboardAppBar(),
          ),
          bottomNavigationBar: _bottomNavigationBar(context),
          //backgroundColor: Colors.transparent,0l
          floatingActionButton: SpeedDial(
            spacing: 0,
            spaceBetweenChildren: 0,
            backgroundColor:  Color(0xFF104267),
            //animatedIcon: AnimatedIcons.arrow_menu,
            overlayColor: Colors.black,
            overlayOpacity: 0.6,
            onOpen: animate,
            onClose: animate,
            direction:Get.locale?.languageCode.toString() == "ar" ? SpeedDialDirection.right : SpeedDialDirection.left , // Change the direction to up
      
            children: [
              SpeedDialChild(
                  child:  Icon(FontAwesomeIcons.wrench),
                  label: AppLocalizations.of(context).service_work_order,
                  labelStyle:  TextStyle(color: kPrimeryBlack,fontSize:30.sp),
                  onTap: () {
                    Get.to(() =>  NewServiceWorkOrderFrom());
                  },),
              SpeedDialChild(
                  child:  Icon(FontAwesomeIcons.microchip),
                  label: AppLocalizations.of(context).service_equip_order,
                  labelStyle:  TextStyle(color: kPrimeryBlack,fontSize:30.sp),
                  onTap: () {
                    Get.to(() =>  NewEquipWorkOrderFrom());
                  },)
            ],
            child: SimpleAnimatedIcon(
              color: Colors.white,
              startIcon: Icons.add,
              endIcon: Icons.close,
              progress: _progress!,
            ),
          ),
          key: scaffoldKey,
          drawer: SideBar(),
          body: Padding(
            padding:  EdgeInsets.all(8.0),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(10),
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _pageController.keepPage;
                      
                      _currentIndex = page;
                    });
                  },
                  children: [
                    Dashboard(context: context),
                    QRScannerView(),
                    SizedBox(child: Text(AppLocalizations.of(context).approvals),),
                  ],
                ),
                ),
              ),
          ),
          ),
        );
  }


 
  void animate() {
    if (_isOpened) {
      _animationController?.reverse();
    } else {
      _animationController?.forward();
    }

    setState(() {
      _isOpened = !_isOpened;
    });
  }

  Widget _bottomNavigationBar(context) {
    return ClipRRect(
      borderRadius:  BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
        bottomLeft: Radius.circular(0.0),
        bottomRight: Radius.circular(0.0),
      ),
      child: BottomNavigationBar(
        elevation: 200,

        backgroundColor: Color.fromARGB(255, 185, 204, 219),
        // selectedIconTheme: IconThemeData(size: 40.h),
        selectedItemColor: Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(255, 89, 96, 101),
        iconSize: 23,

        // selectedFontSize: 15.sp,
        //unselectedFontSize: 13.sp,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(FontAwesomeIcons.house),
            label: AppLocalizations.of(context).home,
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.qrcode),
            label: AppLocalizations.of(context).qr_scanner,
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.circleCheck),
            label: AppLocalizations.of(context).approval,
          )
        ],

        onTap: (index) {
          _currentIndex = index;
          _pageController.jumpToPage(index);
          setState(() {
            print(index);
          });
        },
        //type: BottomNavigationBarType.fixed,
      ),
    );
  }

Widget DashboardAppBar() {
    return AppBar(
      
      iconTheme: IconThemeData(color: Color(0xFF4e7ca2)),
      backgroundColor: Colors.transparent,
      title: Text(AppLocalizations.of(context).dashboard),
      centerTitle: true,
      actions: [
               Container(
               // color: Colors.blue,
                width: MediaQuery.of(context).size.width * 0.15,
                 child: Center(
                   child: IconButton(
                             color: Color(0xFF4e7ca2),
                             icon: Stack(
                               children: [
                                 Icon(Icons.notifications, size: 100.w,),
                                 Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                                     offset: Offset(7, -5),
                                     child: Container(
                        padding: EdgeInsets.all(18.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "5", // Replace with the actual number of unseen notifications
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                                 ),
                               ],
                             ),
                             onPressed: () {
                               // Handle onPressed event
                             },
                           ),
                 ),
               ),
        // IconButton(
        //   color: Color(0xFF4e7ca2),
        //   icon:  Icon(Icons.notifications, size: 100.w,),
        //   onPressed: () {
        
        //   },
        // ),
        Obx( () =>
        GestureDetector(
          child: 
           Container(
              margin: EdgeInsets.only(right: 20.w,left:20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.w),
                color:_authController.checkedIn.value ? Color.fromARGB(255, 148, 39, 39) : Color.fromARGB(255, 0, 128, 0)
              ),
              child: Padding(
            
                padding:  EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.011, 
                  horizontal: MediaQuery.of(context).size.height * 0.027),
                    child: Text(_authController.checkedIn.value ? 
                   AppLocalizations.of(context).check_out : AppLocalizations.of(context).check_in,
                  style: TextStyle(color: Colors.white,fontSize: 32.sp),
                ),
              ),
            ),
             onTap: () => _authController.checkedIn.value  ? _authController.checkOut() : _authController.checkIn(), 
          ),
         
        )]);}
}




