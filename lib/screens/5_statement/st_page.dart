import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sales_records/screens/5_statement/st_table.dart';

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
                  onPressed: () => pickDateRange(),
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
                onPressed: () => pickDateRange(),
              ),
              IconButton(
                  onPressed: () => pickDateRange(),
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
                  onPressed: () => pickDateRange(),
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
                onPressed: () => pickDateRange(),
              ),
              IconButton(
                  onPressed: () => pickDateRange(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Statement',
          style:
              GoogleFonts.rajdhani(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: Navigator.of(context).pop,
        ),
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
                    ? StTable(account: acc, date: date)
                    : const SizedBox(
                        height: 0,
                      ),
                date != null
                    ? PrTable(account: acc, date: date)
                    : const SizedBox(
                        height: 0,
                      ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void pickDateRange() async {
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
}
