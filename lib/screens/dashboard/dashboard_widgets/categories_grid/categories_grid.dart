/// Package imports
// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:steady_solutions/app_config/style.dart';
import 'package:steady_solutions/screens/dashboard/dashboard_widgets/categories_grid/data_source.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

/// Barcode import
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// render data grid widget
class StylingDataGrid extends StatefulWidget {
  /// Creates data grid widget
  const StylingDataGrid({Key? key}) : super(key: key);

  @override
  _StylingDataGridState createState() => _StylingDataGridState();
}

class _StylingDataGridState extends State<StylingDataGrid> {
  /// Supported to notify the panel visibility
  final ValueNotifier<bool> frontPanelVisible = ValueNotifier<bool>(true);
  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;
  bool panelOpen = false;

  /// Determine to decide whether the device in landscape or in portrait
  bool isLandscapeInMobileView = false;

  //ate OrderInfoDataGridSource stylingDataGridSource;

  /// Determine to set the gridLineVisibility of SfDataGrid.
  late String gridLinesVisibility;

  /// Determine to set the gridLineVisibility of SfDataGrid.
  late GridLinesVisibility gridLineVisibility;

 // late bool isWebOrDesktop;

  /// GridLineVisibility strings for drop down widget.
  final List<String> _encoding = <String>[
    'both',
    'horizontal',
    'none',
    'vertical',
  ];

  void _onGridLinesVisibilityChanges(String item) {
    gridLinesVisibility = item;
    switch (gridLinesVisibility) {
      case 'both':
        gridLineVisibility = GridLinesVisibility.both;
        break;
      case 'horizontal':
        gridLineVisibility = GridLinesVisibility.horizontal;
        break;
      case 'none':
        gridLineVisibility = GridLinesVisibility.none;
        break;
      case 'vertical':
        gridLineVisibility = GridLinesVisibility.vertical;
        break;
    }
    setState(() {});
  }

  List<GridColumn> getColumns() {
     TextStyle? textStyle =
        Theme.of(context).textTheme.displayLarge?.copyWith(color: Color.fromRGBO(255, 255, 255, 1,));
    return  <GridColumn>[
            GridColumn(
              columnName: 'category',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerRight,
                child:  Text(
                  'Category',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
             GridColumn(
              columnName: 'all',
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child:  Text(
                  'All',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            GridColumn(
              width: 100,
              columnName: 'performance',
              //columnWidthMode: ColumnWidthMode.fill
                 
              label: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child:  Text(
                  '% Performance',
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
           
          ];
  }

  SfDataGridTheme _buildDataGrid(GridLinesVisibility gridLineVisibility) {
    return SfDataGridTheme(
      data: SfDataGridThemeData(
          headerHoverColor: Colors.white.withOpacity(0.3),
          headerColor: kPrimeryColor2NavyDark),
      child: SfDataGrid(
        source: OrderInfoDataGridSource(isWebOrDesktop: false,orderDataCount: 20, isFilteringSample: false),
        columnWidthMode: ColumnWidthMode.fill,
        gridLinesVisibility: gridLineVisibility,
        columns: getColumns(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    gridLinesVisibility = 'horizontal';
    gridLineVisibility = GridLinesVisibility.horizontal;
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLandscapeInMobileView = 
        MediaQuery.of(context).orientation == Orientation.landscape;
  }


  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Grid lines visibility',
              softWrap: false,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
            Theme(
              data: ThemeData(
                  useMaterial3: false,
                  canvasColor: kPrimaryColor3BrightBlue),
              child: DropdownButton<String>(
                  dropdownColor: kPrimerWhite,
                  focusColor: Colors.transparent,
                  value: gridLinesVisibility,
                  items: _encoding.map((String value) {
                    return DropdownMenuItem<String>(
                        value: (value != null) ? value : 'none',
                        child: Text(value,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: const Color.fromRGBO(51, 51, 51, 1,))));
                  }).toList(),
                  onChanged: (dynamic value) {
                    _onGridLinesVisibilityChanges(value);
                    stateSetter(() {});
                  }),
            ),
          ]);
    });
  }

  BoxDecoration drawBorder() {
    final BorderSide borderSide = BorderSide(
        color:  const Color.fromRGBO(255, 255, 255, 0.26));

    // Restricts the right side border when Datagrid has gridlinesVisibility
    // to both and vertical to maintains the border thickness.
    switch (gridLineVisibility) {
      case GridLinesVisibility.none:
      case GridLinesVisibility.horizontal:
        return BoxDecoration(
            border: Border(
                left: borderSide, right: borderSide, bottom: borderSide));
      case GridLinesVisibility.both:
      case GridLinesVisibility.vertical:
        return BoxDecoration(
            border: Border(left: borderSide, bottom: borderSide));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color:  const Color(0xFFFAFAFA)
           ,
        child: Card(
            margin: const EdgeInsets.all(16.0),
            clipBehavior: Clip.antiAlias,
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DecoratedBox(
                  decoration: drawBorder(),
                  child: _buildDataGrid(gridLineVisibility)),
            )));
  }
}