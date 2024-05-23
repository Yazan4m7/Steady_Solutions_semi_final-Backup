import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:steady_solutions/controllers/api_adderss_controller.dart';
import 'package:steady_solutions/controllers/auth_controller.dart';
import 'package:steady_solutions/controllers/wo_controller.dart';
import 'package:steady_solutions/core/data/constants.dart';

import 'package:steady_solutions/core/services/local_storage.dart';
import 'package:steady_solutions/models/DTOs/create_wo_DTO.dart';
import 'package:steady_solutions/models/work_orders/room.dart';
import 'package:steady_solutions/models/work_orders/service_info.dart';
import 'package:steady_solutions/models/work_orders/site.dart';
import 'package:steady_solutions/models/work_orders/work_order_model.dart';
import 'package:steady_solutions/models/work_orders/call_type.dart';
import 'package:steady_solutions/models/work_orders/category.dart';
import 'package:steady_solutions/models/work_orders/control_item_model.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/pending_work_order.dart';


mixin Helper {
  //final AuthController _authController = Get.find<AuthController>();
  //final ApiAddressController _apiAddressController = Get.find<ApiAddressController>();
  final WorkOrdersController _workOrdersController = Get.find<WorkOrdersController>();
  bool isInitialWOCreationOptionsLoaded() { // Catagories & CallTypes & Sites
    if(_workOrdersController.callTypes.isEmpty || _workOrdersController.categories.isEmpty || _workOrdersController.siteNames.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
    bool isDeptsLoaded() {
    if(_workOrdersController.allRooms.isEmpty || _workOrdersController.departments.isEmpty ) {
      return false;
    } else {
      return true;
    }
  }
   bool isRoomsLoaded(String deptId) {
    if(_workOrdersController.allRooms.isEmpty || _workOrdersController.departments.isEmpty ) {
      return false;
    } else {
      return true;
    }
  }
  
}