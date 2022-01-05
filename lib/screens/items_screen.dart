import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sales_records/shared_preferences.dart';

class Items extends StatefulWidget {
  final String name;
  const Items({Key? key, required this.name}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  late final String acc;
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    acc = widget.name;
    items = LocalData().getItem() ?? [];
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
              );
            });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          acc,
          style:
              GoogleFonts.rajdhani(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                              Icons.add_box,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "Add item",
                              style: GoogleFonts.rajdhani(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ))
                  ])
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'Add new item',
                style: GoogleFonts.rajdhani(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
