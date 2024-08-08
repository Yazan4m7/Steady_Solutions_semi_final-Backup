import 'package:flutter/material.dart';

// TODO: Suspend application if api url is not set.

//String API_URL = storageBox.read('api_url') ?? "";
const String API_KEY = 'g8h9434749qt9723hqp3g892';
String loginEndpoint = "/OMS/Login?";

/// By ID
String GetControlInfoByIDEndPoint = "/OMS/GetControlInfo?";
String createWorkOrderEndpoint = "/OMS/CreateWO?";
String getDepartmentsEndpoint = "/OMS/GetDepartmentsListBySiteID?";
String getNewOrderOptionsEndPoint = "/OMS/CreateWO?";
String getRoomsListEndPoint = "/OMS/GetRoomListByDepID?";

// By category and department
String GetServiceInfoByCatByDep = "/OMS/GetServiceInfoByCatByDep?";
String getWOJobInfoEndPoint = "/OMS/GetWoJobInfo?";
String getPendingOrdersEndPoint = "/OMS/GetPendingWOByEng?";
String createAchievementReportEndPoint = "/OMS/SaveCmReport?";
String getInstalledBaseEndPoint = "/oms/EquipMasterList?";
String getAllDepartmentsEndPoint = "/OMS/GetDepartmentList?";
String getAllManufacturersEndPoint = "/OMS/GetManufacturerList?";
String getCalendarEndPoint = "/OMS/PMCalendarData?";
String getCMPerformanceChartEndPoint = "/oms/ChartCmPerformance?";
String getPMPerformanceChartEndPoint = "/oms/ChartPmPerformance?";
String checkInEndPoint = "/OMS/CheckIn?";
String checkOutEndPoint = "/OMS/CheckOut?";
String getMTTREndPoint = "/OMS/ChartMTTR?";
String getWOByCategoryEndPoint = "/OMS/ChartByCategory?";
String getWOByYearEndPoint = "/OMS/ChartWOByYear?";
String getMTBFEndPoint = "/OMS/ChartMTBF?";
String getAvgDownTimeEndPoint = "/OMS/ChartAvgDownTime?";
String getPartsConsumptionEndPoint = "/OMS/ChartInventoryPartConsumbtion?";
String getWorkingEquipmentEndPoint = "/OMS/ChartWorkingEquipments?";
String getEquipmentByClassEndPoint = "/OMS/ChartEquipmentByClass?";
String sendApprovOrEvalEndPoint = "/OMS/SendEvalOrApprove?";
String getNotificationsEndPoint = "/OMS/GetNotifications?";
String getAllRoomsEndPoint = '/OMS/GetRoomListBySiteID?';
String getEquipTypeIdsEndPoint = '/OMS/GetEquipmentTypeList';
String kMainSuccessIconPath = 'assets/json_animations/success_blue.json';
String getAchievementReportEndPoint = '/OMS/GetAchievmentReport?';
String getPendingPMListEndPoint = '/OMS/GetPendingPMList?';


final navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

enum DashboardWidgets {
  CMPerformanceChart,
  MTTRIndicator,
  MTBFIndicator,
  AvgDownTimeIndicator,
  WOByCategoryChart,
  WOByYearTable,
  PartsConsumptionChart,
  PMPerformanceChart,
  workingEquipmentIndicator,
  equipByClassChart
}

const bool UITestingMode = false;

// COLORS
