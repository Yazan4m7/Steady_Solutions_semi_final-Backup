import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/models/dashboards/pm_cm_performance.dart';
import 'package:steady_solutions/notifications/notifications.dart';
import 'package:steady_solutions/screens/asset_management/installed_base_table.dart';
import 'package:steady_solutions/screens/auth/login_screen.dart';
import 'package:steady_solutions/screens/pm/calendar.dart';
import 'package:steady_solutions/screens/pm/oldcalendar.dart';
import 'package:steady_solutions/screens/work_orders/achievment_report.dart';
import 'package:steady_solutions/screens/work_orders/new_equip_wo_form_screen.dart';
import 'package:steady_solutions/screens/work_orders/new_service_wo_form_screen.dart';
import 'package:steady_solutions/screens/pending_list/pending_work_orders.dart';
import 'package:steady_solutions/widgets/language_icon_button.dart';
import 'package:steady_solutions/widgets/utils/qr_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBar extends StatelessWidget {
  SideBar({
    super.key,
  });
  final DashboardController _chartsController = Get.find<DashboardController>();
  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    double? leftPadding;
    double? rightPadding;
    print(Get.locale.toString());
    if (Get.locale.toString() == "en") {
      leftPadding = 25.w;
      rightPadding = null;
    } else if (Get.locale.toString() == "ar") {
      leftPadding = null;
      rightPadding = 25.w;
    }
    double level1IconSize = 60.w,
        level2IconSize = 40.w,
        level3IconSize = 30.w;
    return Drawer(
      backgroundColor: drawerBgColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  child: SvgPicture.asset(
                      color: Colors.white, "assets/images/logos/LightOMS.svg"),
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading: Icon(
                    Icons.storage_rounded,
                    color: Colors.white,
                    size: level1IconSize,
                  ),

                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  //trailing:  Icon(Icons.arrow_drop_down, color: Colors.white),
                  title: Text(
                    AppLocalizations.of(context).asset_management,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    DrawerListInnerTile(
                      icon: Icon(Icons.account_tree_outlined),
                      title: AppLocalizations.of(context).installed_base,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstalledBaseList(),
                          ),
                        );
                      },
                    ),
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).qr_scanner,
                      icon: Icon(FontAwesomeIcons.qrcode),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRScannerView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading: Icon(
                    Icons.work_history_outlined,
                    color: Colors.white,
                    size: level1IconSize,
                  ),
                    iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Text(
                    AppLocalizations.of(context).work_orders,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    _authController.checkedIn.value
                        ? ExpansionTile(
                            childrenPadding: EdgeInsets.only(left: 10),
                            leading: Icon(
                              Icons.add_box_outlined,
                              color: Colors.white,
                              size: level1IconSize,
                            ),
                              iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                            title: Text(
                              AppLocalizations.of(context).create,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            children: [
                              DrawerListInnerTile(
                                title: AppLocalizations.of(context)
                                    .equipment_work_order,
                                icon: Icon(Icons.devices_other_rounded,
                                    size: level2IconSize),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewEquipWorkOrderFrom(),
                                    ),
                                  );
                                },
                              ),
                              DrawerListInnerTile(
                                title: AppLocalizations.of(context)
                                    .service_work_order,
                                icon: Icon(FontAwesomeIcons.tools,
                                    size: level2IconSize),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewServiceWorkOrderFrom(),
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        : ExpansionTile(
                            enabled: false,
                            childrenPadding: EdgeInsets.only(left: 10),
                            leading: Icon(
                              Icons.add_box_outlined,
                              color: Colors.grey,
                              size: level1IconSize,
                            ),
                              iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                            title: Text(
                              AppLocalizations.of(context).create,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            children: [],
                          ),
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).pending_list,
                      icon: Icon(FontAwesomeIcons.list, size: level2IconSize),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PendingOrdersList(),
                          ),
                        );
                      },
                    ),
                    _authController.checkedIn.value
                        ? DrawerListInnerTile(
                            title: AppLocalizations.of(context).generate_report,
                            icon: Icon(
                              FontAwesomeIcons.clockRotateLeft,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewAchievementReportFrom(),
                                ),
                              );
                            },
                          )
                        : DrawerListInnerTile(
                            title: AppLocalizations.of(context).generate_report,
                            titleIconColor: Colors.grey,
                            icon: Icon(
                              FontAwesomeIcons.clockRotateLeft,
                            ),
                            onTap: () {
                              return null;
                            },
                          )
                  ],
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading: Icon(
                    Icons.tire_repair_rounded,
                    color: Colors.white,
                    size: level1IconSize,
                  ),
                    iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Text(
                    AppLocalizations.of(context).pm,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).calendar,
                      icon:
                          Icon(FontAwesomeIcons.calendar, size: level2IconSize),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgendaViewCalendar(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                DrawerListTile(
                  title: AppLocalizations.of(context).notifications,
                  icon: Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: level1IconSize,
                  ),
                  onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationsScreen(),
                          ),
                        );
                        },
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading: Icon(
                    Icons.dashboard_customize_outlined,
                    color: Colors.white,
                    size: level1IconSize,
                  ),
                    iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Text(
                    AppLocalizations.of(context).dashboard,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
// |__Perofmrance
// |__MTBF & MTTR & Avg down time
                    ExpansionTile(
                      childrenPadding: EdgeInsets.only(left: 10),
                      leading: Icon(
                        Icons.tire_repair_rounded,
                        color: Colors.white,
                        size: level1IconSize,
                      ),
                            iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                      title: Text(
                        AppLocalizations.of(context).pm,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      children: [  Obx(()=>
                        DrawerListInnerTile(
                          
                           trailingWidget: 
                          //  _chartsController.loading["PM"] == true
                          //    ? CircularProgressIndicator(color: Colors.white)
                          //    : 
                             _chartsController.selectedWidgets.contains(DashboardWidgets.PMPerformanceChart)
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).performance,
                          icon: Icon(FontAwesomeIcons.calendar,
                              size: level2IconSize),
                          onTap: () {
                              if ( !_chartsController.selectedWidgets.contains(DashboardWidgets.PMPerformanceChart))
                             _chartsController.selectedWidgets.add(DashboardWidgets.PMPerformanceChart);
                              else{
                                
                               _chartsController.selectedWidgets.remove(DashboardWidgets.PMPerformanceChart);
                              }
                          },
                        ), ), Obx(()=>
                        DrawerListInnerTile(
                           trailingWidget: 
                          //  _chartsController.loading["MTTR"] == true
                          //    ? CircularProgressIndicator(color: Colors.white)
                          //    : 
                             _chartsController.selectedWidgets.contains(DashboardWidgets.MTTRIndicator)
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).mttr,
                          icon: Icon(Icons.monitor_heart_outlined,
                              size: level2IconSize),
                          onTap: () {
                          if ( !_chartsController.selectedWidgets.contains(DashboardWidgets.MTTRIndicator))
                            _chartsController.selectedWidgets.add(DashboardWidgets.MTTRIndicator);
                          else
                          {  _chartsController.selectedWidgets.remove(DashboardWidgets.MTTRIndicator);
                          }
                            
                        },
                        ), ) ,Obx(()=>
                        DrawerListInnerTile(
                           trailingWidget: 
                           _chartsController.loading["MTBF"] == true
                             ? CircularProgressIndicator(color: Colors.white)
                             : 
                             _chartsController.selectedWidgets.contains(DashboardWidgets.MTBFIndicator)
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).mtbf,
                          icon: Icon(Icons.monitor_heart_outlined,
                              size: level2IconSize),
                          onTap: () {
                          if (!_chartsController.selectedWidgets.contains(DashboardWidgets.MTBFIndicator))
                            _chartsController.selectedWidgets.add(DashboardWidgets.MTBFIndicator);
                          else{_chartsController.selectedWidgets.remove(DashboardWidgets.MTBFIndicator);
                           }
                        },
                        ), ), Obx(()=>
                        DrawerListInnerTile(
                           trailingWidget: 
                           //_chartsController.loading["AvgDownTime"] == true
                            //  ? CircularProgressIndicator(color: Colors.white)
                            //  : 
                            _chartsController.selectedWidgets.contains(DashboardWidgets.AvgDownTimeIndicator)
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).avg_down_time,
                          icon: Icon(FontAwesomeIcons.calendar,
                              size: level2IconSize),
                          onTap: () {
                          if (!_chartsController.selectedWidgets.contains(DashboardWidgets.AvgDownTimeIndicator))
                           _chartsController.selectedWidgets.add(DashboardWidgets.AvgDownTimeIndicator);
                          else{_chartsController.selectedWidgets.remove(DashboardWidgets.AvgDownTimeIndicator);
                           }
                        },
                        ),)
                      ],
                    ),

// Wor orders
// |__WO Category
// |__WO by current year
                    ExpansionTile(
                      enabled: true,
                      childrenPadding: EdgeInsets.only(left: 10),
                      leading: Icon(
                        Icons.tire_repair_rounded,
                        color: Colors.grey,
                        size: level1IconSize,
                      ),
                        iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                      title: Text(
                        AppLocalizations.of(context).work_orders,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      children: [
  Obx(()=>
                        DrawerListInnerTile(
                           trailingWidget: _chartsController.loading["wo_by_category"] == true
                             ? CircularProgressIndicator(color: Colors.white)
                             : _chartsController.dashboardWidgets["wo_by_category"] != null
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).by_category,
                          icon: Icon(FontAwesomeIcons.calendar,
                              size: level2IconSize),
                          onTap: () {
                         if (_chartsController.dashboardWidgets["wo_by_category"] == null)
                            _chartsController.fetchWObyCategory();
                          else
                            _chartsController.dashboardWidgets.remove("wo_by_category");
                        },
                        ),),
          Obx(()=>
                        DrawerListInnerTile(
                           trailingWidget: _chartsController.loading["wo_by_year"] == true
                             ? CircularProgressIndicator(color: Colors.white)
                             : _chartsController.dashboardWidgets["wo_by_year"] != null
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).by_current_year,
                          icon: Icon(FontAwesomeIcons.calendar,
                              size: level2IconSize),
                          onTap: () {
                          // if (_chartsController.dashboardWidgets["wo_by_year"] == null)
                          //   _chartsController.fetchCMPerformance();
                          // else
                          //   _chartsController.dashboardWidgets.remove("wo_by_year");
                        },
                        ),)
                      ],
                    ),
// Asset Managment
// |__Working Equip
// |__Equipment
                    ExpansionTile(
                      enabled: true,
                                       childrenPadding: EdgeInsets.only(left: 10),
                      leading: Icon(
                        Icons.tire_repair_rounded,
                        color: Colors.grey,
                        size: level1IconSize,
                      ),
                        iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                      title: Text(
                        AppLocalizations.of(context).asset_management,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                          Obx(()=>
                        DrawerListInnerTile(
                           trailingWidget: _chartsController.loading["working_equipment"] == true
                             ? CircularProgressIndicator(color: Colors.white)
                             : _chartsController.dashboardWidgets["working_equipment"] != null
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                          title: AppLocalizations.of(context).working_equipment,
                          icon: Icon(FontAwesomeIcons.calendar,
                              size: level2IconSize,color: Colors.white,),
                          onTap: () {
                          // if (_chartsController.dashboardWidgets["working_equipment"] == null)
                          //   _chartsController.fetchWorkingEquip();
                          // else
                          //   _chartsController.dashboardWidgets.remove("working_equipment");
                        },
                        ),
                          ),
                        Obx(()=>
                           DrawerListInnerTile(
                             trailingWidget: _chartsController.loading["equipment"] == true
                             ? CircularProgressIndicator(color: Colors.white)
                             : _chartsController.dashboardWidgets["equipment"] != null
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                            
                            title: AppLocalizations.of(context).equipment,
                            icon: Icon(FontAwesomeIcons.calendar,
                                size: level2IconSize,color: Colors.white,),
                            onTap: () {
                          //    if (_chartsController.dashboardWidgets["equipment"] == null)
                          //   _chartsController.fetchEquip();
                          // else
                          //   _chartsController.dashboardWidgets.remove("equipment");
                        },
                          ),
                        ),
                      ],
                    ),
// Parts Consum. By Curent year
// PM Performance
                    Obx(()=>
                      DrawerListTile(
                             trailingWidget: _chartsController.loading["parts_consumption"] == true
                             ? CircularProgressIndicator(color: Colors.white)
                             : _chartsController.dashboardWidgets["parts_consumption"] != null
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                                 
                        title: AppLocalizations.of(context)
                            .parts_consumption_by_current_year,
                          
                            titleTextStyle:  TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        icon: Icon(
                          Icons.pie_chart_outline,
                          color: Colors.white,
                        ),
                        onTap: () {
                            if (_chartsController.dashboardWidgets["parts_consumption"] == null)
                            _chartsController.fetchPartsConsumption();
                          else
                            _chartsController.dashboardWidgets.remove("parts_consumption");
                        },
                      ),
                    ),
                    Obx(()=>
                       DrawerListTile(
                        trailingWidget: 
                        // _chartsController.loading["CM"] == true
                        //      ? CircularProgressIndicator(color: Colors.white)
                        //      :
                              _chartsController.selectedWidgets.contains(DashboardWidgets.CMPerformanceChart)
                                 ? Icon(Icons.check, color: Colors.white)
                                 : null,
                        title: AppLocalizations.of(context).cm_performance,
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onTap: () {
                          if (!_chartsController.selectedWidgets.contains(DashboardWidgets.CMPerformanceChart))
                             _chartsController.selectedWidgets.add(DashboardWidgets.CMPerformanceChart);
                          else{
                            _chartsController.selectedWidgets.remove(DashboardWidgets.CMPerformanceChart);
                            
                          }
                        },
                      ),
                    ),
                  ],
                ),
                DrawerListTile(
                  
                  title: AppLocalizations.of(context).logout,
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 1,
              left: 5,
              child: Container(
                color: drawerBgColor,
                margin: EdgeInsets.only(top: 10),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    child: Text(
                      "${AppLocalizations.of(context).steady_solutions} © ${DateTime.now().year}",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => launch('https://steadysolutions-jo.com'),
                  ),
                ),
              )),
          Positioned(
            right: rightPadding,
            left: leftPadding,
            child: LanguageIconButton(),
          ),
        ],
      ),
    );
  
  }

  /// Returns a single Drawer Tile for the sidebar.
  Widget DrawerListTile({
    required String title,
    required Widget icon,
    Widget? trailingWidget ,
    TextStyle? titleTextStyle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 4.0,
      leading: icon,
      trailing: trailingWidget,
      title: Text(
        title,
        style:titleTextStyle ?? TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget DrawerListInnerTile({
    required String title,
    required Icon icon,
    required VoidCallback onTap,
     Widget? trailingWidget,
    Color? titleIconColor = Colors.white,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: MediaQuery.of(Get.context!).size.width * 0.03),
        Expanded(
          child: ListTile(
            onTap: onTap,
            horizontalTitleGap: 4.0,
            leading: Icon(
              icon.icon,
              color: titleIconColor,
            ),
            trailing: trailingWidget,
            title: Text(
              title,
              style: TextStyle(
                color: titleIconColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
