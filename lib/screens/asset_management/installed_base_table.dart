import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:steady_solutions/app_config/style.dart' as style;
import 'package:steady_solutions/controllers/assets_management_controller.dart';
import 'package:steady_solutions/models/department.dart';
import 'package:steady_solutions/models/pm/manufacturer.dart';
import 'package:steady_solutions/screens/asset_management/table_structure.dart';
import 'package:steady_solutions/screens/home_screen.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
import 'package:pdf/widgets.dart' as pw;

class InstalledBaseList extends StatefulWidget {
  const InstalledBaseList({Key? key}) : super(key: key);

  @override
  State<InstalledBaseList> createState() => _InstalledBaseListState();
}

class _InstalledBaseListState extends State<InstalledBaseList>
    with SingleTickerProviderStateMixin {
  final AssetsManagementController _assetsManagementController =
      Get.find<AssetsManagementController>();

  Animation<double> _progress = AlwaysStoppedAnimation<double>(0.0);

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
  AnimationController? _animationController;
  List<String> columnNames = [
    'Control #',
    "Equip Name",
    "Ser.",
    'Manufac.',
    'Depart.',
    "Warrenty"
  ];

  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) {
     _assetsManagementController.total.value = "-";
     });
    // _overlayManfEntry?.remove();
    // _overlayDeptfEntry?.remove();
    //_overlayEntry?.remove();
    _assetsManagementController.fetchFilterData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // show filtering dialog
      filterDialog();
      // lisenter = _assetsManagementController.isLoading.listen(
      //   (value) {
      //     if (value) {
      //       context.loaderOverlay.show();
      //     } else {
      //       context.loaderOverlay.hide();
      //     }
      //   },
      // );
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _progress =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);

    super.initState();
  }

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
          return WillPopScope(
              onWillPop: () async => await Get.offAll(HomeScreen()),
              child: AlertDialog(
                title: Text(AppLocalizations.of(context).filter_by),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context).department),
                          Obx(
                            () => DropdownButton<String>(
                              hint: Text(
                                _assetsManagementController.departments.isEmpty
                                    ? AppLocalizations.of(context).please_wait
                                    : AppLocalizations.of(context)
                                        .select_department,
                                style: style.hintTextStyle,
                              ),
                              dropdownColor: Colors.white,
                              style: style.dropDownTextStyle,
                              onChanged: (String? value) {
                                structureDataForDataGrid(department: value);
                                Navigator.of(context).pop();
                              },
                              items: _assetsManagementController
                                  .departments.values
                                  .map((department) => DropdownMenuItem(
                                      value: department.value,
                                      child: Text(department.text ?? '')))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    // Text(AppLocalizations.of(context)
                    //     .choose_how_to_filter_installed_base),
                    Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).manufacturer,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Obx(
                          () => DropdownButton<String>(
                            iconSize: 30, // Set the size of the dropdown icon
                            isExpanded:
                                true, // Set the dropdown to expand to the available width
                            itemHeight: 50,
                            hint: Text(
                              _assetsManagementController.departments.isEmpty
                                  ? AppLocalizations.of(context).please_wait
                                  : AppLocalizations.of(context)
                                      .select_manufacturer,
                              style: style.hintTextStyle,
                            ),
                            style: style.dropDownTextStyle,
                            alignment: Alignment.center,
                            dropdownColor: Colors.white,
                            onChanged: (String? value) {
                              structureDataForDataGrid(manafacturer: value);
                              Navigator.of(context).pop();
                            },
                            items: _assetsManagementController
                                .manufacturers.values
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
                alignment: Alignment.center,
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        iconAlignment: IconAlignment.start,
                        style: style.kPrimeryBtnNoPaddingStyle(context),
                        onPressed: () {
                          structureDataForDataGrid();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                            "${AppLocalizations.of(context).all} ${AppLocalizations.of(context).installed_base}"),
                      ),
                    ],
                  ),
                  // Add more options as needed
                ],
              ));
        });
  }

  StreamSubscription<bool>? lisenter;


  @override
  void dispose() {
    if (_overlayManfEntry != null) _overlayManfEntry?.remove();
    if (_overlayDeptfEntry != null) _overlayDeptfEntry?.remove();
    if (_overlayEntry != null) _overlayEntry?.remove();
    lisenter?.cancel();
    super.dispose();
  }

  final GlobalKey<SfDataGridState> _key321 = GlobalKey<SfDataGridState>();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Alignment culumnAlignment = Alignment.centerLeft;
    Map<String, double> maxColumnWidths = {
      'controlNO': screenSize.width / 2.5,
      "equipName": screenSize.width / 1.6,
      'serNO': screenSize.width / 2.5,
      'modelNO': screenSize.width / 4.5,
      'manufacturer': screenSize.width / 2.5,
      'departmentDesc': screenSize.width / 3.0,
      "warrenty": screenSize.width / 3.1,
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
        color: Colors.white, fontSize: 40.sp, fontWeight: FontWeight.bold);

    return WillPopScope(
      onWillPop: () async {
        if (_overlayManfEntry != null) {
          // print("overlay1 entry is not null");
          _overlayManfEntry?.remove();
          _overlayManfEntry = null;
          return false;
        }
        if (_overlayDeptfEntry != null) {
          // print("overlay2 entry is not null");

          _overlayDeptfEntry?.remove();
          _overlayDeptfEntry = null;
          return false;
        }
        if (_overlayEntry != null) {
          // print("overlay3 entry is not null");

          _overlayEntry?.remove();
          _overlayEntry = null;
          return false;
        }
        ;
        // _overlayEntry?.remove();
        // print(_overlayManfEntry);
        // print(_overlayDeptfEntry);
        // print(_overlayEntry);

        // print("no overlays, poping");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => true);
        return true;
      },
      child: Container(
        color: Colors.white,
        child: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Big Data Table'),
          //   actions: [
          //     IconButton(
          //       icon: const Icon(Icons.share),
          //       onPressed: _shareData,
          //     ),

          // IconButton(
          //   icon: const Icon(Icons.file_download),
          //  // onPressed: _exportToExcel,
          // ),

          //       IconButton(
          //       icon: const Icon(Icons.// print),
          //       onPressed: _// printData,
          //     ),
          //   ],
          // ),
          floatingActionButton: SpeedDial(
            label: Text(
              "Export",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Color.fromARGB(255, 15, 65, 120)),
            ),
            spacing: 0,
            spaceBetweenChildren: 0,
            backgroundColor: secondary_light_blue,

            animatedIcon: AnimatedIcons.arrow_menu,
            overlayColor: Color.fromARGB(255, 46, 46, 46),
            overlayOpacity: 0.9,
            curve: Curves.bounceInOut,
            // onOpen: animate,
            // onClose: animate,
            direction: Get.locale?.languageCode.toString() == "ar"
                ? SpeedDialDirection.right
                : SpeedDialDirection.left, // Change the direction to up
            children: [
              SpeedDialChild(
                child: Icon(Icons.print),
                label: "Print",
                labelStyle: TextStyle(color: Colors.black, fontSize: 30.sp),
                onTap: () async {
                   _printData();
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.share),
                label: "SHARE",
                labelStyle: TextStyle(color: Colors.black, fontSize: 30.sp),
                onTap: () async {
                  _shareData();
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
          body: SafeArea(
            child: Column(
              children: [
                Expanded(flex: 1, child: header(context)),

                // _assetsManagementController
                //         .isInstalledBaseListEmpty.value
                //     ? Expanded(
                //         flex: 10,
                //         child: Center(
                //           child: Container(
                //               color: Colors.white,
                //               child: Text(
                //                 AppLocalizations.of(context).no_data_found,
                //                 style:
                //                     Theme.of(context).textTheme.headlineLarge,
                //               )),
                //         ),
                //       )
                //     :
                Expanded(
                  flex: 10,
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(

                        sortIcon: SizedBox(width: 15, height: 15),
                        gridLineColor: Color(0xFF3E3E3E),
                        gridLineStrokeWidth: 1.0,
                        filterIconColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        filterIconHoverColor:
                            Color.fromARGB(255, 206, 206, 206),
                        sortIconColor: const Color.fromARGB(255, 242, 247, 250),
                       // sortIcon: SizedBox(),
                        headerColor: secondary_dark_blue,
                       ),
                    child: Obx(
                      () => SfDataGrid(
                          key: _key321,
                          gridLinesVisibility: GridLinesVisibility.none,
                          rowsPerPage: 20,
                          columnWidthMode: ColumnWidthMode.none,
                          navigationMode: GridNavigationMode.row,
                          sortingGestureType: SortingGestureType.doubleTap,
                          headerRowHeight:
                              MediaQuery.of(context).size.width / 9,
                          allowFiltering:
                              Get.locale?.languageCode == "en" ? true : false,
                          allowSorting: true,
                          source: _installedBaseDataSource.value,
                          onSelectionChanged: (List<DataGridRow> column,
                              List<DataGridRow> row) {},
                          selectionMode: SelectionMode.single,
                          allowMultiColumnSorting: true,
                          headerGridLinesVisibility:
                              GridLinesVisibility.horizontal,
                          isScrollbarAlwaysShown: true,
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
                                      AppLocalizations.of(context).asset_number,
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
                                      AppLocalizations.of(context).asset_name,
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
                                      AppLocalizations.of(context).serial_no,
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
                                      AppLocalizations.of(context).manufacturer,
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
                                          .department_subzone_1,
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
                                      AppLocalizations.of(context).warrenty,
                                    ))),
                          ]),
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

  void _showFilterSelectionDropDown() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        right: 0,
        top: overlayTop,
        width: MediaQuery.of(context).size.width - 100,
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
    // print("inserting overlay entry");
    setState(() {
      Overlay.of(context).insert(_overlayEntry!);
    });
    //Overlay.of(context).insert(_overlayEntry!);
  }

  void showDepartmentSelectionDropDown() {
    _overlayDeptfEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: 0,
          top: overlayTop,
          width: MediaQuery.of(context).size.width - 100,
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
        width: MediaQuery.of(context).size.width - 100,
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

  Container header(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 7, 36, 77),
      ),
      //color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.home_outlined,
                  color: const Color.fromARGB(221, 255, 255, 255)),
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
                    child: Column(
                  children: [
                    Text(
                        AppLocalizations.of(context)
                            .installed_base_screen_title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                letterSpacing: 0.2,
                                color: Colors.white,
                                fontSize: 55.sp,
                                fontWeight: FontWeight.normal)),
                    Obx(
                      () => Text(
                          "Total : ${_assetsManagementController.total.value}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 225, 225, 225),
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.normal)),
                    )
                  ],
                )),
                // Container(
                //   child: Center(
                //       child: Text(
                //           textAlign: TextAlign.center,
                //           AppLocalizations.of(context)
                //               .double_check_to_sort_click_to_generate_report,
                //           style: Theme.of(context)
                //               .textTheme
                //               .labelMedium!
                //               .copyWith(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.bold))),
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.filter_alt,
                  color: const Color.fromARGB(221, 255, 255, 255)),
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
  // void _exportToExcel() async {
  //   List<List<dynamic>> csvData = [columnNames];
  //   csvData.addAll(_installedBaseDataSource.value.dataGridRows.map((e) => e.values.toList()));
  //   String csvString = const ListToCsvConverter().convert(csvData);

  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = '${directory.path}/data.csv';
  //   File(path).writeAsStringSync(csvString);
  //   OpenFile.open(path);
  // }

  void _shareData() async {
    List<List<dynamic>> csvData = [columnNames];
    csvData.addAll(_installedBaseDataSource.value.dataGridRows.map(
        (row) => row.getCells().map((cell) => cell.value.toString()).toList()));

    String csvString = const ListToCsvConverter().convert(csvData);

    final directory = await getExternalStorageDirectory();
    final path = '${directory?.path}/InstalledBase- ${DateTime.now().toString().substring(0, 10)}.csv';
    File file = File(path);
    file.writeAsStringSync(csvString);
    OpenFile.open(file.path, type: "csv");
   // XFile(path).saveTo(path);
    log(path);
    Share.shareXFiles([XFile(path)], subject: 'Sharing table data');
  }

  void _printData() async {
    final doc = pw.Document();
    final data = <List<dynamic>>[
      columnNames
    ]..addAll(_installedBaseDataSource.value.dataGridRows.map(
        (row) => row.getCells().map((cell) => cell.value.toString()).toList()));
    const rowsPerPage = 25; // Rows per page

    // Calculate column widths based on content
    final Map<int, pw.FixedColumnWidth>? columnWidths =
        columnNames.asMap().map((index, name) {
      final values = data.map((row) => row[index].toString());
      final maxLength = values.fold<int>(
          0, (max, value) => value.length > max ? value.length : max);
      return MapEntry(index,
          pw.FixedColumnWidth(maxLength * 6.0)); // Wrap in TableColumnWidth
    });

    for (int i = 0; i < data.length; i += rowsPerPage) {
      final pageData = data.sublist(
          i, i + rowsPerPage > data.length ? data.length : i + rowsPerPage);

      doc.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.TableHelper.fromTextArray(
            data: pageData,
            //columnWidths: columnWidths, // Correctly typed
            tableWidth: pw.TableWidth.max,
          );
        },
      ));
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/INSTALLED BASE - ${DateTime.now()}.pdf");
    await file.writeAsBytes(await doc.save());

    await Printing.layoutPdf(
        onLayout: (format) async => await file.readAsBytes());
  }
}

// Future<void> exportDataGridToExcel() async {
//   final Workbook workbook = _key321.currentState!.exportToExcelWorkbook();
//   final List<int> bytes = workbook.saveAsStream();
//   await FileSaver.instance.saveFile(
//       bytes: Uint8List.fromList(bytes),
//       name: 'installed_base',
//       ext: 'xlsx',
//       mimeType: MimeType.csv);
//   workbook.dispose();
//   // await helper.FileSaveHelper.saveAndLaunchFile(bytes, 'DataGrid.xlsx');
// }

// Future<void> exportDataGridTPdf() async {
//   // print("pdf");
//   PdfDocument document = PdfDocument();
//   // print("add");
//   PdfPage pdfPage = document.pages.add();
//   // print("added");
//   // print(_key321.currentState);

//   PdfGrid? pdfGrid = _key321.currentState!.exportToPdfGrid();
//   // print(pdfGrid);
//   pdfGrid?.draw(
//     page: pdfPage,
//     bounds: Rect.fromLTWH(0, 0, 0, 0),
//   );
//   // print("pdf exporting : ");
//   final List<int> bytes = document.saveSync();
//   // print(bytes);
//   final directory = await getApplicationDocumentsDirectory();
//   final file = File('${directory.path}/Installed Base.xlsx');
//   File fileObj = await file.writeAsBytes(bytes);

//   await FileSaver.instance.saveFile(
//       bytes: Uint8List.fromList(bytes),
//       name: 'installed_base',
//       ext: 'xlsx',
//       file: fileObj,
//       mimeType: MimeType.microsoftExcel);
//   // print("saved");

//   log("saved");
// }
