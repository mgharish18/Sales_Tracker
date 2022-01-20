import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:sales_records/storage/shared_preferences.dart';

class SalesTable extends StatefulWidget {
  final String name;
  const SalesTable({Key? key, required this.name}) : super(key: key);

  @override
  _SalesTableState createState() => _SalesTableState();
}

class _SalesTableState extends State<SalesTable> {
  late String acc;
  late Map items;
  List header = [];

  @override
  void initState() {
    super.initState();
    acc = widget.name;
    items = LocalData().getItem(acc);
  }

  List<GridColumn> getColumns() {
    header = ['DATE', 'TIME'];
    Map itemMap = LocalData().getItem(acc);
    for (var element in itemMap.keys) {
      header.add(element.toString().toUpperCase());
    }
    return header
        .map((e) => GridColumn(
            columnName: e,
            label: Center(
              child: Text(
                e,
                style: GoogleFonts.rajdhani(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    items = LocalData().getItem(acc);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            acc,
            style: GoogleFonts.rajdhani(
                fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh_rounded))
          ],
        ),
        body: items.isEmpty
            ? Center(
                child: Text(
                  'Add your Products ',
                  style: GoogleFonts.rajdhani(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )
            : SfDataGridTheme(
                data: SfDataGridThemeData(
                  gridLineColor: Colors.black54,
                  gridLineStrokeWidth: 1.5,
                  frozenPaneElevation: 0.0,
                  frozenPaneLineColor: Colors.black54,
                  frozenPaneLineWidth: 1.5,
                ),
                child: SfDataGrid(
                    columns: getColumns(),
                    source: GridSource(account: acc),
                    verticalScrollPhysics: const BouncingScrollPhysics(),
                    horizontalScrollPhysics: const BouncingScrollPhysics(),
                    allowSorting: true,
                    frozenColumnsCount: 2,
                    columnWidthMode: ColumnWidthMode.auto,
                    allowPullToRefresh: true,
                    gridLinesVisibility: GridLinesVisibility.none,
                    headerGridLinesVisibility: GridLinesVisibility.horizontal),
              ));
  }
}

class GridSource extends DataGridSource {
  GridSource({required String account}) {
    dataGridRowsList = getRows(account);
  }
  late List<DataGridRow> dataGridRowsList;
  @override
  List<DataGridRow> get rows => dataGridRowsList;

  List<DataGridRow> getRows(String acc) {
    List<DataGridRow> dataRow = [];
    Map countMap = LocalData().getSalesLog(acc);

    for (var key in countMap.keys) {
      DateTime datetime = DateTime.parse(key);
      List<String> datacell = [];
      datacell.add(DateFormat('d/M/yy').format(datetime));
      datacell.add(DateFormat.jm().format(datetime));
      var items = LocalData().getItem(acc);
      for (var x in countMap[key]) {
        datacell.add('$x');
      }
      while (datacell.length < items.length + 2) {
        datacell.add('0');
      }
      var header = ['DATE', 'TIME'];
      Map itemMap = LocalData().getItem(acc);
      for (var element in itemMap.keys) {
        header.add(element.toString().toUpperCase());
      }
      dataRow.add(DataGridRow(
          cells: datacell
              .map((e) => DataGridCell(
                  columnName: header[datacell.indexOf(e)], value: e))
              .toList()));
    }

    return List.from(dataRow.reversed);
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => DataGridRowAdapter(
          cells: row.getCells().map((e) {
        return Center(
            child: Text(
          e.value,
          style: GoogleFonts.rajdhani(
              fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ));
      }).toList());
}
