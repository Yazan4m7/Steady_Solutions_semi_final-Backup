
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Data Table Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _data = []; // Your big data here
  List<Map<String, dynamic>> _filteredData = [];
  final List<String> _columns = List.generate(15, (index) => 'Column ${index + 1}');
  final _searchControllers = List.generate(15, (_) => TextEditingController());
  bool _sortAscending = true;
  int _sortColumn = 0;

  @override
  void initState() {
    super.initState();
    // Generate sample data
    _data = List.generate(100, (index) {
      return {for (int i = 0; i < 15; i++) 'Column $i': 'Data $i-$index'};
    });
    _filteredData = List.from(_data);
  }

  void _sort<T>(Comparable Function(Map<String, dynamic> d) getField, int columnIndex) {
    setState(() {
      _filteredData.sort((a, b) {
        final aVal = getField(a);
        final bVal = getField(b);
        return _sortAscending
            ? Comparable.compare(aVal, bVal)
            : Comparable.compare(bVal, aVal);
      });
      _sortColumn = columnIndex;
      _sortAscending = !_sortAscending;
    });
  }

  void _filter() {
    setState(() {
      _filteredData = _data.where((element) {
        for (int i = 0; i < _columns.length; i++) {
          final filter = _searchControllers[i].text.toLowerCase();
          if (filter.isNotEmpty && !element[_columns[i]].toLowerCase().contains(filter)) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  Future<void> _exportToPdf() async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Table.fromTextArray(
          data: <List<String>>[
            _columns,
            ..._filteredData.map((row) => _columns.map((col) => row[col].toString()).toList()),
          ],
        ),
      ],
    ));

    final file = File("table.pdf");
    await file.writeAsBytes(await pdf.save());
    Share.shareXFiles([XFile(file.path)], text: 'Table PDF');
  }

  // Future<void> _exportToExcel() async {
  //   final excelDoc = excel.Excel.createExcel();
  //   final sheet = excelDoc['Sheet1'];

  //   // Adding column headers
  //   sheet.appendRow(_columns);

  //   // Adding filtered data
  //   _filteredData.forEach((row) {
  //     sheet.appendRow(_columns.map((col) => row[col].toString()).toList());
  //   });

  //   final List<int>? fileBytes = excelDoc.save();
  //   final file = File("table.xlsx");
  //   await file.writeAsBytes(fileBytes!);
  //   Share.shareXFiles([XFile(file.path)], text: 'Sharing table data');
  // }

  void _printTable() {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Table.fromTextArray(
          data: <List<String>>[
            _columns,
            ..._filteredData.map((row) => _columns.map((col) => row[col].toString()).toList()),
          ],
        ),
      ],
    ));

    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DataTable with Export Options'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
          ),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed:(){},// _exportToExcel,
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printTable,
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _columns.map((col) {
                int colIndex = _columns.indexOf(col);
                return Container(
                  width: 150,
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _searchControllers[colIndex],
                    decoration: InputDecoration(labelText: col),
                    onChanged: (value) {
                      _filter();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable2(
                columns: [
                  for (int i = 0; i < _columns.length; i++)
                    DataColumn(
                      label: Text(_columns[i]),
                      onSort: (columnIndex, _) {
                        _sort<dynamic>((d) => d[_columns[columnIndex]], columnIndex);
                      },
                    ),
                ],
                rows: _filteredData.map((data) {
                  return DataRow(
                    cells: _columns.map((column) {
                      return DataCell(Text(data[column].toString()));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}