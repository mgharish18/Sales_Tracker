import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sales_records/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> acc = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    acc = LocalData().getAccount() ?? [];
  }

  void addAccound() {
    Navigator.of(context).pop();
    _controller.text.isNotEmpty ? acc.add(_controller.text) : null;
    _controller.clear();
    LocalData().setAccount(acc);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style:
              GoogleFonts.rajdhani(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: acc.isEmpty
          ? Center(
              child: Text(
                'No Accounts yet\nCreate a new one',
                style: GoogleFonts.rajdhani(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: acc
                  .map((e) => Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(width: 0.5),
                            color: Colors.grey.shade700),
                        child: Text(e,
                            style: GoogleFonts.rajdhani(
                                fontSize: 25.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ))
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 145.0,
                  width: MediaQuery.of(context).size.width - 10,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Account',
                        style: GoogleFonts.rajdhani(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          suffixIcon: _controller.text.isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : IconButton(
                                  onPressed: () => _controller.clear(),
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
                        controller: _controller,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () => {
                                    Navigator.of(context).pop(),
                                    _controller.clear()
                                  },
                              child: Text(
                                'Back',
                                style: GoogleFonts.rajdhani(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )),
                          TextButton(
                            onPressed: () => addAccound(),
                            child: Text(
                              'Create',
                              style: GoogleFonts.rajdhani(
                                  fontSize: 15.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
