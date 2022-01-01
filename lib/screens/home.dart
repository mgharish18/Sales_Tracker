import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
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
          style: GoogleFonts.rajdhani(fontSize: 25.0),
        ),
      ),
      body: Center(
        child: Text(
          'No Accounts yet\nCreate a new one',
          style: GoogleFonts.rajdhani(
              fontSize: 25.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  height: 175.0,
                  width: MediaQuery.of(context).size.width - 10,
                  child: Column(
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height / 3) / 20,
                      ),
                      Text(
                        'Account',
                        style: GoogleFonts.rajdhani(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height / 3) / 20,
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
                      SizedBox(
                        height: (MediaQuery.of(context).size.height / 3) / 25,
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
                            onPressed: null,
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

void addAccound() async {
  SharedPreferences accounts = await SharedPreferences.getInstance();
}
