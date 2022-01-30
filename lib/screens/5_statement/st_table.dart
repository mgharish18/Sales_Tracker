import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sales_records/screens/5_statement/file_display.dart';
import 'package:sales_records/storage/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class StTable extends StatefulWidget {
  final String account;
  final DateTimeRange? date;

  const StTable({Key? key, required this.account, required this.date})
      : super(key: key);

  @override
  _StTableState createState() => _StTableState();
}

class _StTableState extends State<StTable> {
  late Map items;
  late List<String> header;
  late String acc;
  late DateTimeRange date;
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    acc = widget.account;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    date = widget.date!;
    items = LocalData().getItem(acc);
    return Scaffold(
      body: items.isNotEmpty
          ? SfDataGridTheme(
              data: SfDataGridThemeData(
                gridLineColor: Colors.black54,
                gridLineStrokeWidth: 1.5,
                frozenPaneElevation: 0.0,
                frozenPaneLineColor: Colors.black54,
                frozenPaneLineWidth: 1.5,
              ),
              child: SfDataGrid(
                  key: _key,
                  columns: getColumns,
                  source: GridSource(account: acc, date: date),
                  verticalScrollPhysics: const BouncingScrollPhysics(),
                  horizontalScrollPhysics: const BouncingScrollPhysics(),
                  allowSorting: true,
                  frozenColumnsCount: 2,
                  columnWidthMode: ColumnWidthMode.auto,
                  allowPullToRefresh: true,
                  gridLinesVisibility: GridLinesVisibility.none,
                  headerGridLinesVisibility: GridLinesVisibility.horizontal),
            )
          : Center(
              child: Text(
                'Add Your Products',
                style: GoogleFonts.rajdhani(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
          child: Text(
            'PDF',
            style: GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
          ),
          onPressed: _createPdf),
    );
  }

  Future<void> _createPdf() async {
    PdfDocument document = PdfDocument();
    if (_key.currentState != null) {
      document = _key.currentState!.exportToPdfDocument();
      List<int> bytes = document.save();
      document.dispose();

      saveLaunchFile(bytes, 'output.pdf');
    }
  }

  List<GridColumn> get getColumns {
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
}

class GridSource extends DataGridSource {
  GridSource({required String account, required DateTimeRange date}) {
    dataGridRowsList = getRows(account, date);
  }
  late List<DataGridRow> dataGridRowsList;
  late List<List> prGridInfo;
  @override
  List<DataGridRow> get rows => dataGridRowsList;

  List<DataGridRow> getRows(String acc, DateTimeRange date) {
    List<DataGridRow> dataRow = [];
    Map countMap = LocalData().getSalesLog(acc);
    prGridInfo = [];

    for (var key in countMap.keys) {
      DateTime datetime = DateTime.parse(key);
      DateTime onlyDate =
          DateTime.parse(DateFormat('yyyy-MM-dd').format(datetime));
      if (onlyDate.isAfter(date.start.subtract(const Duration(days: 1))) &
          onlyDate.isBefore(date.end.add(const Duration(days: 1)))) {
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
        prGridInfo.add(datacell);
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

class PrTable extends StatefulWidget {
  final String account;
  final DateTimeRange? date;

  const PrTable({Key? key, required this.account, required this.date})
      : super(key: key);

  @override
  _PrTableState createState() => _PrTableState();
}

class _PrTableState extends State<PrTable> {
  late Map items;
  late String acc;
  late DateTimeRange date;
  final cf = NumberFormat("##,##,##0.00", "en_US");
  List<String> prColunm = ['Products', 'Count', 'Amount'];
  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();

  @override
  void initState() {
    acc = widget.account;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    date = widget.date!;
    items = LocalData().getItem(acc);
    return Scaffold(
      body: SfDataGridTheme(
        data: SfDataGridThemeData(
          gridLineStrokeWidth: 1.5,
          frozenPaneElevation: 0.0,
          frozenPaneLineWidth: 1.5,
        ),
        child: SfDataGrid(
          key: key,
          footer: Align(
              alignment: Alignment.center,
              child: Text(
                'Total:  \u{20B9} ${cf.format(PrGridSource(account: acc, date: date, column: prColunm).total)}',
                style: GoogleFonts.rajdhani(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              )),
          source: PrGridSource(account: acc, date: date, column: prColunm),
          columns: getPrColumn(),
          verticalScrollPhysics: const BouncingScrollPhysics(),
          horizontalScrollPhysics: const BouncingScrollPhysics(),
          allowSorting: true,
          frozenColumnsCount: 1,
          columnWidthMode: ColumnWidthMode.auto,
          allowPullToRefresh: true,
          headerGridLinesVisibility: GridLinesVisibility.horizontal,
          gridLinesVisibility: GridLinesVisibility.none,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Text(
            'PDF',
            style: GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            PdfDocument document = key.currentState!.exportToPdfDocument();
            final List<int> bytes = document.save();
            File('Statement.pdf').writeAsBytes(bytes);
          }),
    );
  }

  List<GridColumn> getPrColumn() {
    return prColunm
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
}

class PrGridSource extends DataGridSource {
  PrGridSource(
      {required this.account,
      required DateTimeRange date,
      required this.column}) {
    prGridRows = getRows(GridSource(account: account, date: date).prGridInfo);
  }
  late List<DataGridRow> prGridRows;
  String account;
  List<String> column;
  final cf = NumberFormat("#,##,##0.00", "en_US");
  int total = 0;

  @override
  List<DataGridRow> get rows => prGridRows;

  List<DataGridRow> getRows(List<List> prGridInfo) {
    Map items = LocalData().getItem(account);
    List<List> row =
        List.generate(items.length, (index) => List.generate(3, (index) => 0));

    int i = 0;
    for (var key in items.keys) {
      row[i][0] = key.toString().toUpperCase();
      i++;
    }
    for (var x in prGridInfo) {
      for (int i = 2; i < x.length; i++) {
        row[i - 2][1] = row[i - 2][1] + int.parse(x[i].toString());
      }
    }
    i = 0;
    for (var value in items.values) {
      row[i][2] = row[i][1] * int.parse(value.toString());
      i++;
    }
    for (var x in row) {
      total += int.parse(x[2].toString());
      x[2] = '\u{20B9} ' + cf.format(x[2]);
    }

    return row
        .map((list) => DataGridRow(
            cells: list
                .map((e) =>
                    DataGridCell(columnName: column[list.indexOf(e)], value: e))
                .toList()))
        .toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) => DataGridRowAdapter(
          cells: row.getCells().map((e) {
        return Center(
            child: Text(
          e.value.toString(),
          style: GoogleFonts.rajdhani(
              fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ));
      }).toList());
}
