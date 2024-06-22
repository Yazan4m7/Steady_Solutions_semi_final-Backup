import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/dashboard_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';
import 'package:steady_solutions/screens/asset_management/installed_base_table.dart';
import 'package:steady_solutions/screens/notifications/notifications_screen.dart';
import 'package:steady_solutions/screens/pending_list/pending_work_orders.dart';
import 'package:steady_solutions/screens/pm/calendar.dart';
import 'package:steady_solutions/screens/work_orders/achievment_report.dart';
import 'package:steady_solutions/screens/work_orders/new_equip_wo_form_screen.dart';
import 'package:steady_solutions/screens/work_orders/new_service_wo_form_screen.dart';
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
    double level1IconSize = 60.w, level2IconSize = 40.w, level3IconSize = 30.w;
    return Drawer(
      backgroundColor: drawerBgColor,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 30.h,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      DrawerHeader(
                        child: Column(
                          children: [
                            LanguageIconButton(),
                            SvgPicture.asset(
                                color: Colors.white,
                                "assets/images/logos/LightOMS.svg"),
                          ],
                        ),
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        children: [
                          DrawerListInnerTile(
                            context: context,
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
                          //=======================================
                          DrawerListInnerTile(
                            context: context,
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        children: [
                          //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  children: [
                                    //=======================================
                                    DrawerListInnerTile(
                                      context: context,
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
                                    //=======================================
                                    DrawerListInnerTile(
                                      context: context,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.grey,
                                        ),
                                  ),
                                  children: [],
                                ),
                          //=======================================
                          DrawerListInnerTile(
                            context: context,
                            title: AppLocalizations.of(context).pending_list,
                            icon: Icon(FontAwesomeIcons.list,
                                size: level2IconSize),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PendingOrdersList(),
                                ),
                              );
                            },
                          ),
                          //=======================================
                          _authController.checkedIn.value
                              ? DrawerListInnerTile(
                                  context: context,
                                  title: AppLocalizations.of(context)
                                      .generate_report,
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
                                  context: context,
                                  title: AppLocalizations.of(context)
                                      .generate_report,
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
                      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        children: [
                          DrawerListInnerTile(
                            context: context,
                            title: AppLocalizations.of(context).calendar,
                            icon: Icon(FontAwesomeIcons.calendar,
                                size: level2IconSize),
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
                      //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx

                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////
                      /////////////////////       DASHBOARD      ///////////////////////////////

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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        children: [
                          /////////////////////       work_orders      ///////////////////////////////
                          /////////////////////       work_orders      ///////////////////////////////
                          /////////////////////       Work_orders      ///////////////////////////////
                          /////////////////////       work_orders      ///////////////////////////////
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
                              AppLocalizations.of(context).work_orders,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            children: [
                              /////////////////////       cm_performance      ///////////////////////////////
                              /////////////////////       cm_performance      ///////////////////////////////
                              /////////////////////       cm_performance      ///////////////////////////////
                              /////////////////////       cm_performance      ///////////////////////////////
                              Obx(
                                () => DrawerListTile(
                                  context: context,
                                  trailingWidget:
                                      // _chartsController.loading["CM"] == true
                                      //      ? CircularProgressIndicator(color: Colors.white)
                                      //      :
                                      _chartsController.selectedWidgets
                                              .contains(DashboardWidgets
                                                  .CMPerformanceChart)
                                          ? Icon(Icons.check,
                                              color: Colors.white)
                                          : null,
                                  title: AppLocalizations.of(context)
                                      .cm_performance,
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(DashboardWidgets
                                            .CMPerformanceChart))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets.CMPerformanceChart);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.CMPerformanceChart);
                                    }
                                  },
                                ),
                              ),
                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget:
                                      // _chartsController.selectedWidgets.contains(DashboardWidgets.MTBFIndicator)
                                      //    ? CircularProgressIndicator(color: Colors.white)
                                      //    :
                                      _chartsController.selectedWidgets
                                              .contains(DashboardWidgets
                                                  .MTBFIndicator)
                                          ? Icon(Icons.check,
                                              color: Colors.white)
                                          : null,
                                  title: AppLocalizations.of(context).mtbf,
                                  icon: Icon(Icons.monitor_heart_outlined,
                                      size: level2IconSize),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(
                                            DashboardWidgets.MTBFIndicator))
                                      _chartsController.selectedWidgets
                                          .add(DashboardWidgets.MTBFIndicator);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.MTBFIndicator);
                                    }
                                  },
                                ),
                              ),

                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget:
                                      //  _chartsController.loading["MTTR"] == true
                                      //    ? CircularProgressIndicator(color: Colors.white)
                                      //    :
                                      _chartsController.selectedWidgets
                                              .contains(DashboardWidgets
                                                  .MTTRIndicator)
                                          ? Icon(Icons.check,
                                              color: Colors.white)
                                          : null,
                                  title: AppLocalizations.of(context).mttr,
                                  icon: Icon(Icons.monitor_heart_outlined,
                                      size: level2IconSize),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(
                                            DashboardWidgets.MTTRIndicator))
                                      _chartsController.selectedWidgets
                                          .add(DashboardWidgets.MTTRIndicator);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.MTTRIndicator);
                                    }
                                  },
                                ),
                              ),

                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget:
                                      //_chartsController.loading["AvgDownTime"] == true
                                      //  ? CircularProgressIndicator(color: Colors.white)
                                      //  :
                                      _chartsController.selectedWidgets
                                              .contains(DashboardWidgets
                                                  .AvgDownTimeIndicator)
                                          ? Icon(Icons.check,
                                              color: Colors.white)
                                          : null,
                                  title: AppLocalizations.of(context)
                                      .avg_down_time,
                                  icon: Icon(FontAwesomeIcons.calendar,
                                      size: level2IconSize),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(DashboardWidgets
                                            .AvgDownTimeIndicator))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets
                                              .AvgDownTimeIndicator);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets
                                              .AvgDownTimeIndicator);
                                    }
                                  },
                                ),
                              ),

                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget: (_chartsController
                                          .selectedWidgets
                                          .contains(DashboardWidgets
                                              .WOByCategoryChart))
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                                  title: AppLocalizations.of(context)
                                      .wo_by_category,
                                  icon: Icon(FontAwesomeIcons.calendar,
                                      size: level2IconSize),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(
                                            DashboardWidgets.WOByCategoryChart))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets.WOByCategoryChart);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.WOByCategoryChart);
                                    }
                                  },
                                ),
                              ),
                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget: (_chartsController
                                          .selectedWidgets
                                          .contains(
                                              DashboardWidgets.WOByYearTable))
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                                  title: AppLocalizations.of(context)
                                      .wo_by_current_year,
                                  icon: Icon(FontAwesomeIcons.timeline,
                                      size: level2IconSize),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(
                                            DashboardWidgets.WOByYearTable))
                                      _chartsController.selectedWidgets
                                          .add(DashboardWidgets.WOByYearTable);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.WOByYearTable);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),

                          ExpansionTile(
                            enabled: true,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            children: [
                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget:
                                      //  _chartsController.loading["PM"] == true
                                      //    ? CircularProgressIndicator(color: Colors.white)
                                      //    :
                                      _chartsController.selectedWidgets
                                              .contains(DashboardWidgets
                                                  .PMPerformanceChart)
                                          ? Icon(Icons.check,
                                              color: Colors.white)
                                          : null,
                                  title: AppLocalizations.of(context)
                                      .pm_performance,
                                  icon: Icon(FontAwesomeIcons.calendar,
                                      size: level2IconSize),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(DashboardWidgets
                                            .PMPerformanceChart))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets.PMPerformanceChart);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.PMPerformanceChart);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),

                          //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx
                          //   ExpansionTile(
                          //     enabled: true,
                          //     childrenPadding: EdgeInsets.only(left: 10),
                          //     leading: Icon(
                          //       Icons.tire_repair_rounded,
                          //       color: Colors.white,
                          //       size: level1IconSize,
                          //     ),
                          //       iconColor: Colors.white,
                          // collapsedIconColor: Colors.white,
                          //     title: Text(
                          //       AppLocalizations.of(context).work_orders,
                          //       style: Theme.of(context).textTheme.displayLarge?.copyWith(),
                          //     ),
                          //     children: [

                          //     ],
                          //                   ),
                          ExpansionTile(
                            enabled: true,
                            childrenPadding: EdgeInsets.only(left: 10),
                            leading: Icon(
                              Icons.tire_repair_rounded,
                              color: Colors.white,
                              size: level1IconSize,
                            ),
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            title: Text(
                              AppLocalizations.of(context).asset_management,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            children: [
                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget: (_chartsController
                                          .selectedWidgets
                                          .contains(DashboardWidgets
                                              .workingEquipmentIndicator))
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                                  title: AppLocalizations.of(context)
                                      .working_equipment,
                                  icon: Icon(
                                    FontAwesomeIcons.calendar,
                                    size: level2IconSize,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(DashboardWidgets
                                            .workingEquipmentIndicator))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets
                                              .workingEquipmentIndicator);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets
                                              .workingEquipmentIndicator);
                                    }
                                  },
                                ),
                              ),

                              //=======================================
                              Obx(
                                () => DrawerListInnerTile(
                                  context: context,
                                  trailingWidget: (_chartsController
                                          .selectedWidgets
                                          .contains(DashboardWidgets
                                              .equipByClassChart))
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                                  title: AppLocalizations.of(context)
                                      .equip_by_class,
                                  icon: Icon(
                                    FontAwesomeIcons.calendar,
                                    size: level2IconSize,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(
                                            DashboardWidgets.equipByClassChart))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets.equipByClassChart);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets.equipByClassChart);
                                    }
                                  },
                                ),
                              ),
                              //=======================================
                            ],
                          ),
                          // Parts Consum. By Curent year
                          // PM Performance
                          //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXx
                          ExpansionTile(
                            enabled: true,
                            childrenPadding: EdgeInsets.only(left: 10),
                            leading: Icon(
                              Icons.tire_repair_rounded,
                              color: Colors.white,
                              size: level1IconSize,
                            ),
                            iconColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            title: Text(
                              AppLocalizations.of(context).stock_management,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            children: [
                              Obx(
                                () => DrawerListTile(
                                  context: context,
                                  trailingWidget: (_chartsController
                                          .selectedWidgets
                                          .contains(DashboardWidgets
                                              .PartsConsumptionChart))
                                      ? Icon(Icons.check, color: Colors.white)
                                      : null,
                                  title: AppLocalizations.of(context)
                                      .parts_consumption_by_current_year,
                                  titleTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                  icon: Icon(
                                    Icons.pie_chart_outline,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    if (!_chartsController.selectedWidgets
                                        .contains(DashboardWidgets
                                            .PartsConsumptionChart))
                                      _chartsController.selectedWidgets.add(
                                          DashboardWidgets
                                              .PartsConsumptionChart);
                                    else {
                                      _chartsController.selectedWidgets.remove(
                                          DashboardWidgets
                                              .PartsConsumptionChart);
                                    }
                                  },
                                ),
                              ),
                              //=======================================
                            ],
                          ),
                          // Parts Consum. By Curent year
                          // PM Performance
                        ],
                      ),
                      //=======================================

                      DrawerListTile(
                        context: context,
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

                      DrawerListTile(
                        context: context,
                        title: AppLocalizations.of(context).logout,
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        onTap: () {
                          _authController.logout();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => LoginScreen(),
                          //   ),
                          // );
                        },
                      ),
                    ],
                  ),
                  Container(
                    color: drawerBgColor,
                    margin: EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: GestureDetector(
                        child: Text(
                          "${AppLocalizations.of(context).steady_solutions} © ${DateTime.now().year}",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        onTap: () => launch('https://steadysolutions-jo.com'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns a single Drawer Tile for the sidebar.
  Widget DrawerListTile({
    required String title,
    required Widget icon,
    required BuildContext context,
    Widget? trailingWidget,
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
        style: titleTextStyle ??
            Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
      ),
    );
  }

  Widget DrawerListInnerTile({
    required String title,
    required Icon icon,
    required VoidCallback onTap,
    required BuildContext context,
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
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: titleIconColor,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
