import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/notifications_controller.dart';
import 'package:steady_solutions/screens/dashboard/dashboard.dart';
import 'package:steady_solutions/screens/notifications/notifications_screen.dart';
import 'package:steady_solutions/screens/work_orders/new_equip_wo_form_screen.dart';
import 'package:steady_solutions/screens/work_orders/new_service_wo_form_screen.dart';
import 'package:steady_solutions/widgets/side_bar.dart';
import 'package:steady_solutions/widgets/utils/qr_scanner.dart';

import '../widgets/utils/background.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final NotificationsController _notificationsController =
      NotificationsController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  bool _isOpened = false;
  AnimationController? _animationController;
  Animation<double> _progress = AlwaysStoppedAnimation<double>(0.0);
  final AuthController _authController = Get.find<AuthController>();
  StreamSubscription<bool>? lisenter;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });

    _progress =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);
    if (mounted) {
      lisenter = _authController.checkingInOrOut.listen((value) {
        if (value) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      });
    }
    print("font scaling : 1 is ${1.sp} and 10 is ${10.sp}");

    // FlutterError.onError = (FlutterErrorDetails details) {
    //   print("=================== CAUGHT FLUTTER ERROR");
    //   print("=================== =====================================");
    //   print(details);
    //   // NEVER REACHES HERE - WHY?
    // };
    super.initState();
  }

  Key _key123 = Key("123");
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: DashboardAppBar(),
          ),
          bottomNavigationBar: _bottomNavigationBar(context),
          // backgroundColor: Colors.white,
          floatingActionButton: Obx(
            () => !_authController.checkedIn.value
                ? SizedBox()
                : SpeedDial(
                    label: Text(
                      AppLocalizations.of(context).work_order,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    spacing: 0,
                    spaceBetweenChildren: 0,
                    backgroundColor: _authController.checkedIn.value
                        ? primery_blue_color
                        : const Color.fromARGB(255, 112, 112, 112),
                    //animatedIcon: AnimatedIcons.arrow_menu,
                    overlayColor: Color.fromARGB(255, 46, 46, 46),
                    overlayOpacity: 0.9,
                    onOpen: animate,
                    onClose: animate,
                    direction: Get.locale?.languageCode.toString() == "ar"
                        ? SpeedDialDirection.right
                        : SpeedDialDirection.left, // Change the direction to up
                    children: !_authController.checkedIn.value
                        ? []
                        : [
                            SpeedDialChild(
                              child: Icon(FontAwesomeIcons.wrench),
                              label: AppLocalizations.of(context)
                                  .equipment_work_order,
                              labelStyle: TextStyle(
                                  color: kPrimeryBlack, fontSize: 30.sp),
                              onTap: () {
                                Get.to(() => NewEquipWorkOrderFrom());
                              },
                            ),
                            SpeedDialChild(
                              child: Icon(FontAwesomeIcons.microchip),
                              label: AppLocalizations.of(context)
                                  .service_work_order,
                              labelStyle:
                                  Theme.of(context).textTheme.displayLarge,
                              onTap: () {
                                Get.to(() => NewServiceWorkOrderFrom());
                              },
                            )
                          ],
                    child: SimpleAnimatedIcon(
                      color: Colors.white,
                      startIcon: Icons.add,
                      endIcon: Icons.close,
                      progress: _progress,
                    ),
                  ),
          ),
          key: scaffoldKey,
          drawer: SideBar(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView(
                      key: _key123,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // _pageController.keepPage;

                            _currentIndex = page;
                          });
                        });
                      },
                      children: [
                        DashboardScreen(),
                        QRScannerView(),
                        // SizedBox(
                        //   child: Text(AppLocalizations.of(context).approvals),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
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
    return BottomNavigationBar(
      elevation: 0,

      backgroundColor: bottom_sheet_bg_color,

      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house),
          label: AppLocalizations.of(context).home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_sharp),
          label: AppLocalizations.of(context).qr_scanner,
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(FontAwesomeIcons.circleCheck),
        //   label: AppLocalizations.of(context).approval,
        // )
      ],

      onTap: (index) {
        _currentIndex = index;
        _pageController.jumpToPage(index);
        setState(() {
          print(index);
        });
      },
      //type: BottomNavigationBarType.fixed,
    );
  }

  Widget DashboardAppBar() {
    log(
      _notificationsController.notificationsList.length.toString(),
    );
    return Container(
      // color:Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: primery_blue_color,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          Row(
            children: [
              Container(
                // color: Colors.blue,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Center(
                  child: IconButton(
                    color: Color.fromARGB(255, 128, 193, 255),
                    icon: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NotificationsScreen()));
                      },
                      child: Stack(
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 100.w,
                          ),
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
                                child: Obx(
                                  () => Text(
                                    _notificationsController
                                        .notificationsList.length
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NotificationsScreen()));
                    },
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(right: 20.w, left: 20.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.w),
                        color: _authController.checkedIn.value
                            ? Color.fromARGB(255, 148, 39, 39)
                            : Color.fromARGB(255, 0, 128, 0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.011,
                          horizontal:
                              MediaQuery.of(context).size.height * 0.027),
                      child: Text(
                        _authController.checkedIn.value
                            ? AppLocalizations.of(context).check_out
                            : AppLocalizations.of(context).check_in,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  onTap: () => _authController.checkedIn.value
                      ? _authController.checkOut()
                      : _authController.checkIn(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
