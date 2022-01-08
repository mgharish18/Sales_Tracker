import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class ItemsList extends StatefulWidget {
  final Map items;
  const ItemsList({Key? key, required this.items}) : super(key: key);

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  late Map items;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    items = widget.items;
    return Container(
      height: MediaQuery.of(context).size.height - 269,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Container(
                padding: const EdgeInsets.only(left: 20.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 0.5),
                    color: Colors.white),
                margin: const EdgeInsets.all(5.0),
                width: 250.0,
                height: 80.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      items.keys.toList()[index],
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.blue),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      width: 100.0,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Count",
                        ),
                        controller: _controller,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
