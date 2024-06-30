import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/models/assets_management/installed_base.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// This class Structures the list of PendWorkOrders as a DataGridSource to be
// used in the SfDataGrid widget.

class InstalledBaseDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  InstalledBaseDataSource({required List<InstalledBase> installedBaseList}) {
    dataGridRows = installedBaseList
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'controlNO',
                  value: dataGridRow.controlNO.toString()),
                   DataGridCell<String>(
                  columnName: 'equipName',
                  value: dataGridRow.equipName),
                  DataGridCell<String>(
                  columnName: 'SerNO',
                  value: dataGridRow.serNO),
                   DataGridCell<String>(
                  columnName: 'manufacturer',
                  value: dataGridRow.manufacturer),
              DataGridCell<String>(
                  columnName: 'departmentDesc',
                  value: dataGridRow.departmentDesc),
               DataGridCell<String>(
                  columnName: 'warrenty', value: dataGridRow.iSUnderWarranty.toString() == "false" ? "No" : "Yes",)
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;
 
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    TextStyle rowsTextStyle=TextStyle(

    );
    return DataGridRowAdapter(
        color: effectiveRows.indexOf(row) % 2 != 0
            ? Colors.white
            : Color(0xffddeffc),
        cells: row.getCells().map<Widget>((dataGridCell) {
          // BUILD PAGES FOR STATUS
          // if (dataGridCell.columnName == 'statusDesc') {
          //   return buildStatusContainer(dataGridCell.value.toString());
          // }

          // ASSIGN COLOR TO FAILURE DATE
          TextStyle? getTextStyle() {
            if (dataGridCell.columnName == 'failureDateTime') 
              return TextStyle(color: Color(0xff7b0505));
             if (dataGridCell.columnName == 'warrenty') {
              if (dataGridCell.value.toString() == 'Yes') {
                return TextStyle(color: Color.fromARGB(255, 236, 21, 21));}
                else{
                  return TextStyle(color: Color.fromARGB(221, 49, 167, 6));
                }

             }
              return TextStyle(color: Colors.black87);
            
          }
          Alignment culomnAlignment = Alignment.centerLeft;
          if(Get.locale?.languageCode == "ar") {
                culomnAlignment =Alignment.center;
          }
          // MAIN CONTAINER
          return Container(
             alignment: 
              (dataGridCell.columnName == 'controlNO')?
                   Alignment.centerLeft
                  : culomnAlignment,
              padding: EdgeInsets.only(left: 0.0),
              child: Text(
                style: getTextStyle(),
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }

  // Widget buildStatusContainer(String status) {
  //   Color backgroundColor;
  //   Color textColor;



  //   return Container(
  //     decoration: BoxDecoration(
  //       color: backgroundColor,
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     margin: EdgeInsets.symmetric(horizontal: 60.0.w, vertical: 21.0.h),
  //     child: Center(
  //       child: Text(
  //         status,
  //         style: TextStyle(
  //           color: textColor,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
