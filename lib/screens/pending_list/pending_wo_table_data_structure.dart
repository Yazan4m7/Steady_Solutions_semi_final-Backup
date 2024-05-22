import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:steady_solutions/models/pending_work_order.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// This class Structures the list of PendWorkOrders as a DataGridSource to be
// used in the SfDataGrid widget.

class PendingWorkOrderDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  PendingWorkOrderDataSource({required List<PendingWorkOrder> woList}) {
    dataGridRows = woList
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'jobNumber',
                  value: dataGridRow.jobNumber.toString()),
              DataGridCell<String>(
                  columnName: 'departmentDesc',
                  value: dataGridRow.departmentDesc),
              DataGridCell(
                  columnName: "controlNumber",
                  value: dataGridRow.controlNumber),
              DataGridCell<String>(
                  columnName: 'failureDateTime',
                  value: dataGridRow.failureDateTime.toString().split(' ')[0]),
               DataGridCell<String>(
                  columnName: 'failureDateTime',
                  value: dataGridRow.failureDateTime.toString().split(' ')[1]),
              DataGridCell<String>(
                  columnName: 'isUrgent',
                  value: dataGridRow.isUrgent.toString() == "false" ? "No" : "Yes"),
              /* DataGridCell<String>(
                  columnName: 'priority', value: dataGridRow.priority),*/
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
            : Colors.grey[200],
        cells: row.getCells().map<Widget>((dataGridCell) {
          // BUILD PAGES FOR STATUS
          if (dataGridCell.columnName == 'statusDesc') {
            return buildStatusContainer(dataGridCell.value.toString());
          }

          // ASSIGN COLOR TO FAILURE DATE
          TextStyle? getTextStyle() {
            if (dataGridCell.columnName == 'failureDateTime') 
              return TextStyle(color: Color(0xff7b0505));
             if (dataGridCell.columnName == 'isUrgent') {
              if (dataGridCell.value.toString() == 'Yes') {
                return TextStyle(color: Color.fromARGB(255, 236, 21, 21));}
                else{
                  return TextStyle(color: Color.fromARGB(221, 49, 167, 6));
                }

             }
             
              return TextStyle(color: Colors.black87);
            
          }

          // MAIN CONTAINER
          return Container(
             alignment: 
              (dataGridCell.columnName == 'jobNumber')?
                   Alignment.center
                  : Alignment.centerLeft,
              padding: EdgeInsets.only(left: 0.0),
              child: Text(
                style: getTextStyle(),
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }

  Widget buildStatusContainer(String status) {
    Color backgroundColor;
    Color textColor;

    if (status == 'Pending') {
      backgroundColor = Color(0xffa56025);
      textColor = Colors.white;
    } else if (status == 'Repaired') {
      backgroundColor = Colors.deepPurple;
      textColor = Colors.white24;
    } else {
      backgroundColor = Colors.black26;
      textColor = Colors.white;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 60.0.w, vertical: 21.0.h),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
