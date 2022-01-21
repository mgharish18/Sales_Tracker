import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_records/storage/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class GraphPage extends StatefulWidget {
  final String name;
  const GraphPage({Key? key, required this.name}) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late String acc;
  static late List<GraphData> gDataList;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    acc = widget.name;
    gDataList = getGraphData();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Sales Graph',
            style: GoogleFonts.rajdhani(
                fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => setState(() {
                      gDataList = getGraphData();
                    }),
                icon: const Icon(Icons.refresh_rounded))
          ],
        ),
        body: SafeArea(
          child: SfCartesianChart(
            title: ChartTitle(
              text: 'Daily Sales Analysis',
              textStyle: GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
            ),
            legend: Legend(
              isVisible: true,
            ),
            tooltipBehavior: _tooltipBehavior,
            zoomPanBehavior:
                ZoomPanBehavior(enablePinching: true, zoomMode: ZoomMode.x),
            series: <ChartSeries>[
              LineSeries<GraphData, dynamic>(
                  name: 'Total Sales',
                  dataSource: gDataList,
                  xValueMapper: (GraphData data, _) => data.date,
                  yValueMapper: (GraphData data, _) => data.count,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, color: Colors.black))),
            ],
            primaryXAxis: DateTimeAxis(
                labelStyle: GoogleFonts.rajdhani(
                    fontWeight: FontWeight.bold, color: Colors.black),
                dateFormat: DateFormat('d/M'),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                title: AxisTitle(
                  text: 'Date',
                  textStyle: GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
                )),
            primaryYAxis: NumericAxis(
                labelStyle: GoogleFonts.rajdhani(
                    fontWeight: FontWeight.bold, color: Colors.black),
                title: AxisTitle(
                  text: 'Total Sales Count',
                  textStyle: GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
                )),
          ),
        ));
  }

  List<GraphData> getGraphData() {
    Map data = LocalData().getSalesLog(acc);
    List<String> allDates = [];
    List<List> allCounts = [];
    for (var key in data.keys) {
      allDates.add(DateFormat('yyyy-MM-dd').format(DateTime.parse(key)));
      allCounts.add(data[key]);
    }
    return processData(allDates, allCounts);
  }

  List<GraphData> processData(List<String> allDates, List<List> allCounts) {
    List<GraphData> gDataList = [];
    while (allDates.isNotEmpty) {
      List<int> idx = [];
      List<List> specificCount = [];
      int count = 0;
      String date = allDates[0];
      for (int i = 0; i < allDates.length; i++) {
        if (allDates[0] == allDates[i]) {
          idx.add(i);
        }
      }
      for (int i in idx) {
        specificCount.add(allCounts[i]);
        allDates.remove(date);
        allCounts[i] = [];
      }
      allCounts.removeWhere((element) => element.isEmpty);
      for (var x in specificCount) {
        for (int e in x) {
          count += e;
        }
      }
      gDataList.add(GraphData(DateTime.parse(date), count));
    }
    return gDataList;
  }
}

class GraphData {
  DateTime date;
  int count;
  GraphData(this.date, this.count);
}
