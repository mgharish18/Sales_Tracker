import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:sales_records/storage/firebase_database.dart';

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
  SplayTreeMap supply = SplayTreeMap();

  @override
  void initState() {
    super.initState();
    acc = widget.name;
  }

  List<GridColumn> getColumns(Map itemMap) {
    header = ['DATE', 'TIME'];
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Records',
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
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: getDocStream(acc),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  Map<String, dynamic>? data = snapshot.data!.data();
                  if (data != null) {
                    items = data['product'];
                    Map temp = data['supply'];
                    temp.forEach((key, values) {
                      supply[key] = values;
                    });
                  } else {
                    items = {};
                    supply = SplayTreeMap();
                  }
                } else {
                  items = {};
                  supply = SplayTreeMap();
                }
                return items.isEmpty
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
                            columns: getColumns(items),
                            source: GridSource(
                                account: acc, items: items, supply: supply),
                            verticalScrollPhysics:
                                const BouncingScrollPhysics(),
                            horizontalScrollPhysics:
                                const BouncingScrollPhysics(),
                            allowSorting: true,
                            frozenColumnsCount: 2,
                            columnWidthMode: ColumnWidthMode.auto,
                            allowPullToRefresh: true,
                            gridLinesVisibility: GridLinesVisibility.none,
                            headerGridLinesVisibility:
                                GridLinesVisibility.horizontal),
                      );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went worng'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class GridSource extends DataGridSource {
  GridSource(
      {required String account, required Map items, required Map supply}) {
    dataGridRowsList = getRows(account, items, supply);
  }
  late List<DataGridRow> dataGridRowsList;
  @override
  List<DataGridRow> get rows => dataGridRowsList;

  List<DataGridRow> getRows(String acc, Map items, Map countMap) {
    List<DataGridRow> dataRow = [];
    for (var key in countMap.keys) {
      DateTime datetime = DateTime.parse(key);
      List<String> datacell = [];
      datacell.add(DateFormat('d/M/yy').format(datetime));
      datacell.add(DateFormat.jm().format(datetime));
      for (var x in countMap[key]) {
        datacell.add('$x');
      }
      while (datacell.length < items.length + 2) {
        datacell.add('0');
      }
      var header = ['DATE', 'TIME'];

      for (var element in items.keys) {
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
