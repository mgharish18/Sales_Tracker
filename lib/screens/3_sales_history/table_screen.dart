import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    acc = widget.name;
    items = LocalData().getItem(acc);
  }

  List<DataColumn> getColumns() {
    List header = ['DATE', 'TIME'];
    Map itemMap = LocalData().getItem(acc);
    for (var element in itemMap.keys) {
      header.add(element.toString().toUpperCase());
    }
    return header
        .map((e) => DataColumn(
            label: Text(e,
                style: GoogleFonts.rajdhani(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold))))
        .toList();
  }

  List<DataRow> getRows() {
    List<DataRow> dataRow = [];
    Map countMap = LocalData().getSalesLog(acc);

    for (var key in countMap.keys) {
      DateTime datetime = DateTime.parse(key);
      List<String> datacell = [];
      datacell.add(DateFormat('d/M/yy').format(datetime));
      datacell.add(DateFormat.jm().format(datetime));
      items = LocalData().getItem(acc);
      for (var x in countMap[key]) {
        datacell.add('$x');
      }
      while (datacell.length < items.length + 2) {
        datacell.add('0');
      }
      dataRow
          .add(DataRow(cells: datacell.map((e) => DataCell(Text(e))).toList()));
    }

    return List.from(dataRow.reversed);
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
          style:
              GoogleFonts.rajdhani(fontSize: 25.0, fontWeight: FontWeight.bold),
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
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: DataTable(
                  dividerThickness: 3.0,
                  columns: getColumns(),
                  rows: getRows(),
                  dataTextStyle: GoogleFonts.rajdhani(
                      fontSize: 15.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              )),
    );
  }
}
