import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:sales_records/shared_preferences.dart';
import 'package:sales_records/widget/list_of_items.dart';

class Items extends StatefulWidget {
  final String name;
  const Items({Key? key, required this.name}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late final String acc;
  Map items = {};
  List<String> routine = [];
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    _controller1.addListener(() {
      setState(() {});
    });
    acc = widget.name;
    items = LocalData().getItem(acc);
  }

  void addItem() {
    if (_controller1.text.isNotEmpty & _controller2.text.isNotEmpty) {
      LocalData().setItem(acc, _controller1.text, int.parse(_controller2.text));
      Navigator.pop(context);
      items = LocalData().getItem(acc);
      setState(() {
        _controller1.text = '';
        _controller2.text = '';
      });
    }
  }

  void saveCount(String acc, List<int> countList) {
    LocalData().saveCount(acc, date, time, countList);
    print(LocalData().getSalesLog(acc).toString());
  }

  Future pickDate(BuildContext context) async {
    DateTime? dateValue = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1));
    if (dateValue != null) {
      setState(() {
        date = dateValue;
      });
    }
  }

  Future pickTime(BuildContext context) async {
    TimeOfDay? timeValue =
        await showTimePicker(context: context, initialTime: time);
    if (timeValue != null) {
      setState(() {
        time = timeValue;
      });
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  void onSelected(context, value) {
    switch (value) {
      case (0):
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  height: 170.0,
                  width: MediaQuery.of(context).size.width - 10.0,
                  child: Column(
                    children: [
                      Text(
                        "Add a new Item",
                        style: GoogleFonts.rajdhani(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width:
                                ((MediaQuery.of(context).size.width - 30) / 2) -
                                    7.0,
                            child: TextField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.fastfood_rounded),
                                suffixIcon: _controller1.text.isEmpty
                                    ? Container(
                                        width: 0,
                                      )
                                    : IconButton(
                                        onPressed: () => _controller1.clear(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: "Name",
                              ),
                              controller: _controller1,
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 30) / 3,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixIcon:
                                    const Icon(Icons.price_change_rounded),
                                suffixIcon: _controller2.text.isEmpty
                                    ? Container(
                                        width: 0,
                                      )
                                    : IconButton(
                                        onPressed: () => _controller2.clear(),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        )),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0)),
                                labelText: "Price",
                              ),
                              controller: _controller2,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () => addItem(),
                              child: Text(
                                "ADD",
                                style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.blue),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
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
            PopupMenuButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.all(10),
                tooltip: 'Menu',
                onSelected: (value) => onSelected(context, value),
                itemBuilder: (context) => [
                      PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.api_rounded,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "Add Product",
                                style: GoogleFonts.rajdhani(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ])
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
            : Container(
                margin: const EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: GoogleFonts.rajdhani(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50.0),
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => pickDate(context),
                                icon: const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Colors.white,
                                )),
                            TextButton(
                              child: Text(
                                DateFormat('dd-MM-yyyy').format(date),
                                style: GoogleFonts.rajdhani(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => pickDate(context),
                            ),
                            IconButton(
                                onPressed: () => pickDate(context),
                                icon: const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      'Time',
                      style: GoogleFonts.rajdhani(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50.0),
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => pickTime(context),
                                icon: const Icon(
                                  Icons.access_time_filled_rounded,
                                  color: Colors.white,
                                )),
                            TextButton(
                              child: Text(
                                localizations.formatTimeOfDay(time),
                                style: GoogleFonts.rajdhani(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => pickTime(context),
                            ),
                            IconButton(
                                onPressed: () => pickTime(context),
                                icon: const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ItemsList(items: items),
                  ],
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => saveCount(acc, ItemsList.countList),
          child: Text(
            'Save',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
