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
      double level1IconSize = 60.dm, level2IconSize = 40.dm, level3IconSize = 30.dm;
    return Drawer(
      backgroundColor: drawerBgColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  child: SvgPicture.asset(
                      color: Colors.white,
                      "assets/images/logos/steadyOMS_Colored.svg"),
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading:  Icon(
                    Icons.storage_rounded,
                    color: Colors.white,
                    size: level1IconSize,
                  ),
                  title: Text(
                    AppLocalizations.of(context).asset_management,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    DrawerListInnerTile(
                      icon:  Icon(Icons.account_tree_outlined),
                      title: AppLocalizations.of(context).installed_base,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  InstalledBaseList(),
                          ),
                        );
                      },
                    ),
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).qr_scanner,
                      icon:  Icon(FontAwesomeIcons.qrcode),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  QRScannerView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading:  Icon(
                    Icons.work_history_outlined,
                    color: Colors.white,
                      size: level1IconSize,
                  ),
                  title: Text(
                    AppLocalizations.of(context).work_orders,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    ExpansionTile(
                      childrenPadding: EdgeInsets.only(left: 10),
                      leading:
                           Icon(Icons.add_box_outlined, color: Colors.white,  size: level1IconSize,),
                      title: Text(
                        AppLocalizations.of(context).create,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        DrawerListInnerTile(
                          title:
                              AppLocalizations.of(context).equipment_work_order,
                          icon:  Icon(Icons.devices_other_rounded,size : level2IconSize),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  NewEquipWorkOrderFrom(),
                              ),
                            );
                          },
                        ),
                        DrawerListInnerTile(
                          title:
                              AppLocalizations.of(context).service_work_order,
                          icon:  Icon(FontAwesomeIcons.tools,size : level2IconSize),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  NewServiceWorkOrderFrom(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).pending_list,
                      icon:  Icon(FontAwesomeIcons.list,size : level2IconSize),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  PendingOrdersList(),
                          ),
                        );
                      },
                    ),
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).generate_report,
                      icon:  Icon(FontAwesomeIcons.qrcode),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewAchievementReportFrom(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading:  Icon(Icons.tire_repair_rounded, color: Colors.white,  size: level1IconSize,),
                  title: Text(
                    AppLocalizations.of(context).pm,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    DrawerListInnerTile(
                      title: AppLocalizations.of(context).calendar,
                      icon:  Icon(FontAwesomeIcons.calendar,size : level2IconSize),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  AgendaViewCalendar(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                DrawerListTile(
                  title: AppLocalizations.of(context).notifications,
                  icon:  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: level1IconSize,
                  ),
                  onTap: () {},
                ),
                ExpansionTile(
                  childrenPadding: EdgeInsets.only(left: 10),
                  leading:  Icon(Icons.dashboard_customize_outlined,
                      color: Colors.white,  size: level1IconSize,),
                  title: Text(
                    AppLocalizations.of(context).dashboard,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Obx(
                      ()=>DrawerListTile(
                        title: AppLocalizations.of(context).pm_performance,
                        trailingWidget:
                        _chartsController.loading["PM"] == true ? CircularProgressIndicator(color: Colors.white) :
                         _chartsController.dashboardWidgets["PM"] != null ?  Icon(Icons.check,color:Colors.white) : null,
                        icon:  Icon(
                          Icons.local_attraction_sharp,
                          color: Colors.white,
                          size: level2IconSize,
                        ),
                        onTap: () {
                            if(_chartsController.dashboardWidgets["PM"] == null)
                               _chartsController.fetchCMPerformance(1) ;
                               else
                             _chartsController.dashboardWidgets.remove("PM");
                        },
                      ),
                    ),
                    Obx(
                      ()=> DrawerListTile(
                        title: AppLocalizations.of(context).cm_performance  ,
                         trailingWidget: 
                         _chartsController.loading["CM"] == true ? CircularProgressIndicator(color: Colors.white) :
                         _chartsController.dashboardWidgets["CM"] != null ?  Icon(Icons.check,color:Colors.white) : null,
                        icon:  Icon(
                          Icons.workspace_premium_sharp,
                          color: Colors.white,
                           size: level2IconSize,
                        ),
                        onTap: () {
                          print(" _chartsController.dashboardWidgets[cm]");
                             if(_chartsController.dashboardWidgets["CM"] == null)
                               _chartsController.fetchCMPerformance(2);
                               else
                             _chartsController.dashboardWidgets.remove("CM");
                      
                        },
                      ),
                    ),
                    DrawerListTile(
                      title: AppLocalizations.of(context).wo_analysis_by_category,
                      icon:  Icon(
                        Icons.analytics_outlined,
                        color: Colors.white,
                         size: level2IconSize,
                      ),
                      onTap: () {},
                    ),
                    DrawerListTile(
                      title: AppLocalizations.of(context).inventory_part_consumbtion_by_current_year,
                      icon:  Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white,
                         size: level2IconSize,
                      ),
                      onTap: () {},
                    ),
                    DrawerListTile(
                      title: AppLocalizations.of(context).work_wrders_by_current_year,
                      icon:  Icon(
                        Icons.new_releases_outlined,
                        color: Colors.white,
                         size: level2IconSize,
                      ),
                      onTap: () {},
                    ),
                    // DrawerListTile(
                    //   title: AppLocalizations.of(context).cm_performance,
                    //   icon:  Icon(
                    //     Icons.workspace_premium_sharp,
                    //     color: Colors.white,
                    //      size: level2IconSize,
                    //   ),
                    //   onTap: () {},
                    // ),
                    // DrawerListTile(
                    //   title: AppLocalizations.of(context).cm_performance,
                    //   icon:  Icon(
                    //     Icons.workspace_premium_sharp,
                    //     color: Colors.white,
                    //      size: level2IconSize,
                    //   ),
                    //   onTap: () {},
                    // ),
                    // DrawerListTile(
                    //   title: AppLocalizations.of(context).cm_performance,
                    //   icon:  Icon(
                    //     Icons.workspace_premium_sharp,
                    //     color: Colors.white,
                    //      size: level2IconSize,
                    //   ),
                    //   onTap: () {},
                    // ),
                  ],
                ),
                DrawerListTile(
                  title: AppLocalizations.of(context).logout,
                  icon:  Icon(
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
                margin:  EdgeInsets.only(top: 10),
                child: Padding(
                  padding:  EdgeInsets.all(5.0),
                  child: GestureDetector(
                    child: Text(
                      "${AppLocalizations.of(context).steady_solutions} © ${DateTime.now().year}",
                      style:  TextStyle(color: Colors.white),
                    ),
                    onTap: () => launch('https://steadysolutions-jo.com'),
                  ),
                ),
              )),
          Positioned(
            right: rightPadding,
            left: leftPadding,
            child:  LanguageIconButton(),
          ),
        ],
      ),
    );
  }

  /// Returns a single Drawer Tile for the sidebar.
  Widget DrawerListTile({
    required String title,
    required Widget icon,
   Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 4.0,
      leading: icon,
      trailing:  trailingWidget,
      title: Text(
        title,
        style:  TextStyle(
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
              color: Colors.white,
            ),
            title: Text(
              title,
              style:  TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
