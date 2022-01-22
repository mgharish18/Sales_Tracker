import "dart:collection";
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import 'package:sales_records/storage/shared_preferences.dart';

class GraphPage extends StatefulWidget {
  final String name;
  const GraphPage({Key? key, required this.name}) : super(key: key);

  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late String acc;
  static late List<GraphData> gDataList;
  late Map items;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    acc = widget.name;
    gDataList = getGraphData();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  List<FastLineSeries> getLineSeries(List<GraphData> gDataList, Map items) {
    List<FastLineSeries> lineseries = [];
    List<String> legend = [];
    for (var x in items.keys) {
      legend.add(x.toString().toUpperCase());
    }
    legend.add('Total Sales');
    for (int i = 0; i < legend.length; i++) {
      FastLineSeries<GraphData, dynamic> series =
          FastLineSeries<GraphData, dynamic>(
              name: legend[i],
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              dataSource: gDataList,
              xValueMapper: (GraphData data, _) => data.date,
              yValueMapper: (GraphData data, _) => data.count[i],
              dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  textStyle: GoogleFonts.rajdhani(
                      fontWeight: FontWeight.bold, color: Colors.black)));
      lineseries.add(series);
    }
    return lineseries;
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
          child: LocalData().getSalesLog(acc).isNotEmpty
              ? SfCartesianChart(
                  title: ChartTitle(
                    text: 'Daily Sales Analysis',
                    textStyle: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  legend: Legend(
                    isVisible: true,
                    textStyle: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                    isResponsive: true,
                  ),
                  tooltipBehavior: _tooltipBehavior,
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true, zoomMode: ZoomMode.x),
                  series: getLineSeries(gDataList, items),
                  primaryXAxis: DateTimeAxis(
                      labelStyle: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      dateFormat: DateFormat('d/M'),
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      title: AxisTitle(
                        text: 'Date',
                        textStyle:
                            GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
                      )),
                  primaryYAxis: NumericAxis(
                      labelStyle: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      title: AxisTitle(
                        text: 'Sales Count',
                        textStyle:
                            GoogleFonts.rajdhani(fontWeight: FontWeight.bold),
                      )),
                )
              : SfCartesianChart(),
        ));
  }

  List<GraphData> getGraphData() {
    SplayTreeMap data = LocalData().getSalesLog(acc);
    items = LocalData().getItem(acc);
    List<String> allDates = [];
    List<List> allCounts = [];
    data.forEach((key, value) {
      allDates.add(DateFormat('yyyy-MM-dd').format(DateTime.parse(key)));
      allCounts.add(value);
    });
    return processData(allDates, allCounts, items);
  }

  List<GraphData> processData(
      List<String> allDates, List<List> allCounts, Map items) {
    List<GraphData> gDataList = [];
    while (allDates.isNotEmpty) {
      List<int> idx = [];
      List<List> specificCount = [];
      List<int> itemCount = List.generate(items.length + 1, (index) => 0);
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
      for (List x in specificCount) {
        for (int i = 0; i < x.length; i++) {
          itemCount[itemCount.length - 1] += int.parse(x[i].toString());
          itemCount[i] += int.parse(x[i].toString());
        }
      }
      gDataList.add(GraphData(DateTime.parse(date), itemCount));
    }
    return gDataList;
  }
}

class GraphData {
  DateTime date;
  List<int> count;
  GraphData(this.date, this.count);
}
