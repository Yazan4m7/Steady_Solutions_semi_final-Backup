import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:steady_solutions/app_config/app_theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_core/theme.dart';
class BigDataTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  const BigDataTable({super.key, required this.data});

  @override
  _BigDataTableState createState() => _BigDataTableState();
}
 Color primaryColor = primery_blue_grey_color; // #4878a6
 Color accentColor =primery_blue_color;  // #1977dd
 Color darkColor =primery_dark_blue_color;   // #153d77
class _BigDataTableState extends State<BigDataTable> {
  late _BigDataSource _bigDataSource;
  List<String> columnNames = ["Column 1", "Column 2", "Column 3"];
  List<bool> _isAscending = [];

  @override
  void initState() {
    super.initState();
    final dummyData = List.generate(100, (index) {
      return {
        'Column 1': 'Data ${index + 1}',
        'Column 2': 'Data ${index + 1}',
        'Column 3': 'Data ${index + 1}',
      };
    });
    if (widget.data.isEmpty) {
      setState(() {
        _bigDataSource = _BigDataSource(dummyData);
        columnNames = dummyData.isNotEmpty ? dummyData[0].keys.toList() : [];
        _isAscending = List.filled(columnNames.length, true);
      });
    }else{
    _bigDataSource = _BigDataSource(widget.data);
    columnNames = widget.data.isNotEmpty ? widget.data[0].keys.toList() : [];
    _isAscending = List.filled(columnNames.length, true);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Big Data Table'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareData,
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printData,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportToExcel,
          ),
        ],
      ),
      body: SfDataGridTheme(
        data : SfDataGridThemeData(
               gridLineColor: darkColor,               // Lines between cells
         // headerGridLineColor: darkColor.withOpacity(0.8), // Header line
         // headerBackgroundColor: primaryColor,   // Header background
          rowHoverColor: accentColor.withOpacity(0.1), // Hover effect
          selectionColor: accentColor.withOpacity(0.3),
        ),
        child: SfDataGrid(
        // Selection
          source: _bigDataSource,
          allowSorting: true,
          allowFiltering: true,
          columnWidthMode: ColumnWidthMode.fill,
          columns: columnNames.map((name) {
            int index = columnNames.indexOf(name);
            return GridColumn(
              
              columnName: name,
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text(name),
              ),
              // onSort: (columnIndex) => _sortColumn(columnIndex),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _sortColumn(int columnIndex) {
    setState(() {
      _isAscending[columnIndex] = !_isAscending[columnIndex];
      _bigDataSource._sortData(columnIndex, _isAscending[columnIndex]);
    });
  }

  void _exportToExcel() async {
    List<List<dynamic>> csvData = [columnNames];
    csvData.addAll(_bigDataSource._data.map((e) => e.values.toList()));
    String csvString = const ListToCsvConverter().convert(csvData);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/data.csv';
    File(path).writeAsStringSync(csvString);
    OpenFile.open(path);
  }

  void _shareData() async {
    List<List<dynamic>> csvData = [columnNames];
    csvData.addAll(_bigDataSource._data.map((e) => e.values.toList()));
    String csvString = const ListToCsvConverter().convert(csvData);

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/data.csv';
    File(path).writeAsStringSync(csvString);
    Share.shareXFiles([XFile(path)], text: 'Sharing table data');
  }

  void _printData() async {
    final doc = pw.Document();

    doc.addPage(pw.Page(
        build: (pw.Context context) {
      return pw.Table.fromTextArray(
          data: <List<dynamic>>[columnNames]
            ..addAll(_bigDataSource._data.map((e) => e.values.toList())));
    }));

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await doc.save());

    await Printing.layoutPdf(
        onLayout: (format) async => await file.readAsBytes());
  }
}

class _BigDataSource extends DataGridSource {
  _BigDataSource(this._data);
  final List<Map<String, dynamic>> _data
  ;
  List<Map<String, dynamic>> _filteredData = [];
  List<String> columnNames = [  "Column 11", "Column 2", "Column 3"];
  @override
  List<DataGridRow> get rows => _filteredData.isEmpty
      ? _data
          .map((e) => DataGridRow(
                cells: e.keys
                    .map((key) => DataGridCell<dynamic>(
                        columnName: key, value: e[key]))
                    .toList(),
              ))
          .toList()
      : _filteredData
          .map((e) => DataGridRow(
                cells: e.keys
                    .map((key) => DataGridCell<dynamic>(
                        columnName: key, value: e[key]))
                    .toList(),
              ))
          .toList();

  void _sortData(int columnIndex, bool ascending) {
    _data.sort((a, b) {
      final dynamic valueA = a[columnNames[columnIndex]];
      final dynamic valueB = b[columnNames[columnIndex]];

      if (valueA == null || valueB == null) return 0;

      if (valueA is String) {
        return ascending
            ? valueA.compareTo(valueB)
            : valueB.compareTo(valueA);
      } else if (valueA is num) {
        return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
      } else {
        return 0;
      }
    });
    notifyListeners();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
  void onFilterChanged(String columnName, String filterText) {
    _filteredData = _data.where((row) {
      final cellValue = row[columnName].toString().toLowerCase();
      return cellValue.contains(filterText.toLowerCase());
    }).toList();
    notifyListeners();
  }
}
