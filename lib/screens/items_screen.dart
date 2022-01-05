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
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller1.addListener(() {
      setState(() {});
    });
    acc = widget.name;
    items = LocalData().getItem() ?? [];
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
                  height: 145.0,
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
                            width: (MediaQuery.of(context).size.width - 30) / 2,
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
                              onPressed: null,
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
