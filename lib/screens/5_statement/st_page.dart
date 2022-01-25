import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sales_records/storage/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class StatementPage extends StatefulWidget {
  final String name;
  const StatementPage({Key? key, required this.name}) : super(key: key);

  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage>
    with SingleTickerProviderStateMixin {
  late String acc;
  DateTimeRange? date;
  late Map items;
  List header = [];
  late TabController controller;

  @override
  void initState() {
    acc = widget.name;
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildRangePicker() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => pickDateRange(context),
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  )),
              TextButton(
                child: date == null
                    ? Text('From',
                        style: GoogleFonts.rajdhani(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))
                    : Text(
                        DateFormat('dd-MM-yyyy').format(date!.start),
                        style: GoogleFonts.rajdhani(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: () => pickDateRange(context),
              ),
              IconButton(
                  onPressed: () => pickDateRange(context),
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
        const Center(
          child: Icon(Icons.arrow_downward_rounded),
        ),
        Container(
          margin: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => pickDateRange(context),
                  icon: const Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white,
                  )),
              TextButton(
                child: date == null
                    ? Text('To',
                        style: GoogleFonts.rajdhani(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ))
                    : Text(
                        DateFormat('dd-MM-yyyy').format(date!.end),
                        style: GoogleFonts.rajdhani(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: () => pickDateRange(context),
              ),
              IconButton(
                  onPressed: () => pickDateRange(context),
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStTable(DateTimeRange date) {
    items = LocalData().getItem(acc);
    return items.isNotEmpty
        ? SfDataGridTheme(
            data: SfDataGridThemeData(
              gridLineColor: Colors.black54,
              gridLineStrokeWidth: 1.5,
              frozenPaneElevation: 0.0,
              frozenPaneLineColor: Colors.black54,
              frozenPaneLineWidth: 1.5,
            ),
            child: SfDataGrid(
                columns: getColumns(),
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Statement',
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
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildRangePicker(),
              TabBar(
                mouseCursor: MouseCursor.uncontrolled,
                controller: controller,
                enableFeedback: false,
                labelColor: Colors.black,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.greenAccent),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.note_alt_rounded),
                  ),
                  Tab(
                    icon: Icon(Icons.price_change_rounded),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: TabBarView(controller: controller, children: [
                  date != null
                      ? buildStTable(date!)
                      : const SizedBox(
                          height: 0,
                        ),
                  const Text('No content'),
                ]),
              )
            ],
          ),
        ));
  }

  void pickDateRange(BuildContext context) async {
    final initialDate = DateTimeRange(
        start: DateTime.now().subtract(const Duration(hours: 24 * 7)),
        end: DateTime.now());
    final DateTimeRange? dateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: date ?? initialDate);

    if (dateRange != null) {
      setState(() {
        date = dateRange;
      });
    }
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
}

class GridSource extends DataGridSource {
  GridSource({required String account, required DateTimeRange date}) {
    dataGridRowsList = getRows(account, date);
  }
  late List<DataGridRow> dataGridRowsList;
  @override
  List<DataGridRow> get rows => dataGridRowsList;

  List<DataGridRow> getRows(String acc, DateTimeRange date) {
    List<DataGridRow> dataRow = [];
    Map countMap = LocalData().getSalesLog(acc);

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