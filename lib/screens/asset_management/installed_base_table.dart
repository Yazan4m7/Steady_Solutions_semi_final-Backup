import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/controllers/assets_management_controller.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/pm/manufacturer.dart';
import 'package:steady_solutions/screens/asset_management/table_structure.dart';
import 'package:steady_solutions/screens/home_screen.dart';

import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class InstalledBaseList extends StatefulWidget {
  const InstalledBaseList({Key? key}) : super(key: key);

  @override
  State<InstalledBaseList> createState() => _InstalledBaseListState();
}

class _InstalledBaseListState extends State<InstalledBaseList> {
  final AssetsManagementController _assetsManagementController =
      Get.find<AssetsManagementController>();
  // Data to be sent to the server

  /// List after structuring it for the data grid
  final Rx<InstalledBaseDataSource> _installedBaseDataSource =
      InstalledBaseDataSource(installedBaseList: []).obs;
  String? selectedManafacturer;
  String? selectedDepratment;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _overlayManfEntry;
 OverlayEntry? _overlayDeptfEntry;
  String selectedOption = 'All';
     double overlayTop = 40;
  void structureDataForDataGrid(
      {String? manafacturer, String? department}) async {
    // Show filter dialog and wait for user selection

    await _assetsManagementController.fetchDataAndInsertIntoMap(
        manafacturer, department);
    _installedBaseDataSource.value = InstalledBaseDataSource(
        installedBaseList:
            _assetsManagementController.installedBase.values.toList());
  }

  Future<dynamic> filterDialog() {
    selectedManafacturer = null;
    selectedDepratment = null;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope  (
          onWillPop:() async => await Get.offAll(HomeScreen()),
          child: AlertDialog(
          title: Text(AppLocalizations.of(context).filter_by),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 60.h,),
              Container(
                 width: MediaQuery.of(context).size.width*0.7,
                child: Column(children: [ Text(AppLocalizations.of(context).department),
                Obx(
                  () => DropdownButton<String>(
                    hint: Text(
                      _assetsManagementController.departments.isEmpty
                          ? AppLocalizations.of(context).please_wait
                          : AppLocalizations.of(context).select_department,
                      style: hintTextStyle,
                    ),
                    dropdownColor: Colors.white,
                    style: dropDownTextStyle,
                    onChanged: (String? value) {
                      structureDataForDataGrid(department: value);
                      Navigator.of(context).pop();
                    },
                    items: _assetsManagementController.departments.values
                        .map((department) => DropdownMenuItem(
                            value: department.value,
                            child: Text(department.text ?? '')))
                        .toList(),
                  ),
                ),
                             ],),
              ),
              SizedBox(height: 40.h,),
              // Text(AppLocalizations.of(context)
              //     .choose_how_to_filter_installed_base),
              Column(
                children: [
                  Text(AppLocalizations.of(context).manufacturer,style:Theme.of(context).textTheme.displayMedium ,),
                  Obx(
                    () => DropdownButton<String>(
                       iconSize: 30, // Set the size of the dropdown icon
                     // isExpanded: true, // Set the dropdown to expand to the available width
                      itemHeight: 50, 
                      hint: Text(
                        _assetsManagementController.departments.isEmpty
                            ? AppLocalizations.of(context).please_wait
                            : AppLocalizations.of(context).select_manufacturer,
                        style: hintTextStyle,
                      ),
                      style: dropDownTextStyle,
                      alignment: Alignment.center,
                      dropdownColor: Colors.white,
                      onChanged: (String? value) {
                        structureDataForDataGrid(manafacturer: value);
                        Navigator.of(context).pop();
                      },
                      items: _assetsManagementController.manufacturers.values
                          .map((manafacturer) => DropdownMenuItem(
                              value: manafacturer.value,
                              child: Text(manafacturer.text ?? '')))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              style: kPrimeryBtnStyle(context),
              onPressed: () {
                structureDataForDataGrid();
                Navigator.of(context).pop();
              },
              child: Text(
                  "${AppLocalizations.of(context).all} ${AppLocalizations.of(context).installed_base}"),
            ),
            // Add more options as needed
          ],
        ));
  });
    
  }

  StreamSubscription<bool>? lisenter;
  @override
  void initState() {
   // _overlayManfEntry?.remove();
   // _overlayDeptfEntry?.remove();
    //_overlayEntry?.remove();
    _assetsManagementController.fetchFilterData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // show filtering dialog
      filterDialog();
      lisenter = _assetsManagementController.isLoading.listen(
        (value) {
          if (value) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
        },
      );
    });

    super.initState();
  }
 
  @override
  void dispose() {
    if(_overlayManfEntry != null)
    _overlayManfEntry?.remove();
     if(_overlayDeptfEntry != null)
    _overlayDeptfEntry?.remove();
     if(_overlayEntry != null)
    _overlayEntry?.remove();
    lisenter?.cancel();
    super.dispose();
  }


  void _showFilterSelectionDropDown() {

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: 0,
        top: overlayTop,
        width: MediaQuery.of(context).size.width-100,
        child: Material(
          elevation: 4.0,
          child: Column(children: [
//               'Department'
// 'Manufacturer'
// 'All'
            ListTile(
              
              tileColor: Colors.blueGrey,
              textColor: Colors.white,
              title: Text("Department"),
              onTap: () {
                _overlayEntry?.remove(); // Close the dropdown
                showDepartmentSelectionDropDown();
              },
            ),
            ListTile(
               tileColor: Colors.blueGrey,
              textColor: Colors.white,
              title: Text("Manufacturer"),
              onTap: () {
                _overlayEntry?.remove(); // Close the dropdown
                showManufacturerSelectionDropDown();
              },
            ),
            ListTile(
               tileColor: Colors.blueGrey,
              textColor: Colors.white,
              title: Text("All"),
              onTap: () {
                structureDataForDataGrid();
                _overlayEntry?.remove(); // Close the dropdown
               
              },
            ),
          ]),
        ),
      ),
    );
    print("inserting overlay entry");
    setState(() {
      Overlay.of(context).insert(_overlayEntry!);
    });
    //Overlay.of(context).insert(_overlayEntry!);
  }

  void showDepartmentSelectionDropDown() {

    _overlayDeptfEntry = OverlayEntry(
      builder: (context) {
      
        return Positioned(
        right:0,
        top: overlayTop,
        width: MediaQuery.of(context).size.width-100,
        child: Material(
          elevation: 4.0,
          child: Column(
            children: _assetsManagementController.departments.values
                .map<ListTile>((Department value) {
              return ListTile(
                 tileColor: Colors.blueGrey,
                 textColor: Colors.white,
                title: Text(value.text!),
                onTap: () {
                  structureDataForDataGrid(department: value.value);
                  
                  _overlayDeptfEntry?.remove(); // Close the dropdown
                },
              );
            }).toList(),
          ),
        ),
      );
      },
    );

    Overlay.of(context).insert(_overlayDeptfEntry!);
  }

  void showManufacturerSelectionDropDown() {
  
    _overlayManfEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: 0,
        top: overlayTop,
        width: MediaQuery.of(context).size.width-100,
        child: Material(
          elevation: 4.0,
          child: SingleChildScrollView(
            child: Column(
              children: _assetsManagementController.manufacturers.values
                  .map<ListTile>((Manufacturer value) {
                return ListTile(
                   tileColor: Colors.blueGrey,
                  textColor: Colors.white,
                  title: Text(value.text!),
                  onTap: () {
                   structureDataForDataGrid(manafacturer: value.value);
                    _overlayManfEntry?.remove(); // Close the dropdown
            
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)!.insert(_overlayManfEntry!);
  }


  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    Alignment culumnAlignment = Alignment.centerLeft;
    Map<String, double> maxColumnWidths = {
      'controlNO': screenSize.width / 3.5,
      "equipName": screenSize.width / 1.6,
      'serNO': screenSize.width / 2.5,
      'modelNO': screenSize.width / 4.5,
      'manufacturer': screenSize.width / 2.5,
      'departmentDesc': screenSize.width / 1.5,
      "warrenty": screenSize.width / 3.5,
    };

    if (Get.locale?.languageCode == "ar") {
      culumnAlignment = Alignment.center;
      maxColumnWidths = {
        'controlNO': screenSize.width / 7.5,
        "equipName": screenSize.width / 1.6,
        'serNO': screenSize.width / 2.5,
        'modelNO': screenSize.width / 4.5,
        'manufacturer': screenSize.width / 3.5,
        'departmentDesc': screenSize.width / 1.5,
        "warrenty": screenSize.width / 5.5,
      };
    }

    TextStyle headerTextStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Colors.white, fontSize: 36.sp, fontWeight: FontWeight.bold);

    return WillPopScope(

    
      onWillPop:  () async {
        if (_overlayManfEntry != null) {
            print("overlay1 entry is not null");
          _overlayManfEntry?.remove();
          _overlayManfEntry=null;
           return false;
        }
        if (_overlayDeptfEntry != null) {
            print("overlay2 entry is not null");
            
          _overlayDeptfEntry?.remove();
          _overlayDeptfEntry=null;
           return false;
        }
        if (_overlayEntry != null) {
          print("overlay3 entry is not null");
          
          _overlayEntry?.remove();
          _overlayEntry=null;
           return false;
        }
         ;
          // _overlayEntry?.remove();
          print(_overlayManfEntry);
          print(_overlayDeptfEntry);
          print(_overlayEntry);
          
       
      
          print("no overlays, poping");
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => true);
          return true;
        
       
     },
      child: Container(
        color: kPrimerWhite,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(flex: 1, child: header(context)),
                Obx(
                  () => _assetsManagementController.isInstalledBaseListEmpty.value
                      ? Expanded(
                          flex: 10,
                          child: Center(
                            child: Container(
                                color: Colors.white,
                                child: Text(
                                  AppLocalizations.of(context).no_data_found,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                )),
                          ),
                        )
                      : Expanded(
                          flex: 10,
                          child: SfDataGridTheme(
                            data: const SfDataGridThemeData(
                                //sortIcon: SizedBox(width: 0, height: 0),
                                gridLineColor: Color(0xFF3E3E3E),
                                gridLineStrokeWidth: 1.0,
                                filterIconColor: Colors.blueGrey,
                                filterIconHoverColor: Colors.purple,
                                sortIconColor: Colors.blueGrey,
                                sortIcon: SizedBox(),
                                headerColor: Color(0xFF383838),
                                headerHoverColor: Colors.yellow),
                            child: Obx(
                              () => SfDataGrid(
                                  sortingGestureType:
                                      SortingGestureType.doubleTap,
                                  headerRowHeight:
                                      MediaQuery.of(context).size.width / 9,
                                  allowFiltering: Get.locale?.languageCode == "en"
                                      ? true
                                      : false,
                                  allowSorting: true,
                                  source: _installedBaseDataSource.value,
                                  onSelectionChanged: (List<DataGridRow> column,
                                      List<DataGridRow> row) {},
                                  selectionMode: SelectionMode.single,
                                  allowMultiColumnSorting: true,
                                  columnWidthMode: ColumnWidthMode.none,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  showColumnHeaderIconOnHover: true,
                                  columns: [
                                    GridColumn(
                                        width: maxColumnWidths['controlNO']!,
                                        filterIconPosition:
                                            ColumnHeaderIconPosition.start,
                                        columnName: 'controlNO',
                                        label: Container(
                                            alignment: culumnAlignment,
                                            child: Text(
                                              style: headerTextStyle,
                                              AppLocalizations.of(context)
                                                  .control_no,
                                              // overflow: TextOverflow.clip,
                                            ))),
                                    GridColumn(
                                        width: maxColumnWidths['equipName']!,
                                        columnName: 'equipName',
                                        label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            alignment: culumnAlignment,
                                            child: Text(
                                              style: headerTextStyle,
                                              AppLocalizations.of(context)
                                                  .equip_name,
                                            ))),
                                    GridColumn(
                                        width: maxColumnWidths['serNO']!,
                                        columnName: 'serNO',
                                        label: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            alignment: culumnAlignment,
                                            child: Text(
                                              style: headerTextStyle,
                                              AppLocalizations.of(context)
                                                  .serial_no,
                                            ))),
                                    GridColumn(
                                        width: maxColumnWidths['manufacturer']!,
                                        columnName: 'manufacturer',
                                        label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            alignment: culumnAlignment,
                                            child: Text(
                                              style: headerTextStyle,
                                              AppLocalizations.of(context)
                                                  .manufacturer,
                                            ))),
                                    GridColumn(
                                        width: maxColumnWidths['departmentDesc']!,
                                        columnName: 'departmentDesc',
                                        label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            alignment: culumnAlignment,
                                            child: Text(
                                              style: headerTextStyle,
                                              AppLocalizations.of(context)
                                                  .department_desc,
                                            ))),
                                    GridColumn(
                                        width: maxColumnWidths['warrenty']!,
                                        columnName: 'warrenty',
                                        label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            alignment: culumnAlignment,
                                            child: Text(
                                              style: headerTextStyle,
                                              AppLocalizations.of(context)
                                                  .warrenty,
                                            ))),
                                  ]),
                            ),
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
  
  Container header(BuildContext context) {
       
    return Container(
    color: kPrimeryColor2NavyDark,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: kPrimerWhite),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                      AppLocalizations.of(context)
                          .installed_base_screen_title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.white,
                              fontSize: 50.sp,
                              fontWeight: FontWeight.bold))),
              Container(
                child: Center(
                    child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)
                            .double_check_to_sort_click_to_generate_report,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.filter_alt, color: kPrimerWhite),
            onPressed: () {
              _showFilterSelectionDropDown();
            },
          ),
          //   icon: Icon(Icons.filter_alt, color: kPrimerWhite),
          //   onPressed: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => InstalledBaseList()));
          //   },
          // ),
        ),
      ],
    ),
  );
  }

}





