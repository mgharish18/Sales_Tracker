import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sales_records/screens/2_products_entry/entry_screen.dart';
import 'package:sales_records/storage/shared_preferences.dart';
import 'package:sales_records/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final contoller = TextEditingController();
  List<String> acc = [];
  late bool isDeleteClicked;
  late List<bool> isChecked;

  @override
  void initState() {
    super.initState();
    // contoller.addListener(() => setState(() {}));
    acc = LocalData().getAccount() ?? [];
    isChecked = List.generate(acc.length, (index) => false);
    isDeleteClicked = false;
  }

  void addAccound() {
    Navigator.of(context).pop();
    contoller.text.isNotEmpty ? acc.add(contoller.text) : null;
    contoller.clear();
    LocalData().setAccount(acc);
    setState(() {
      acc = LocalData().getAccount()!;
      isChecked = List.generate(acc.length, (index) => false);
    });
  }

  @override
  void dispose() {
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
        centerTitle: true,
        actions: [
          isDeleteClicked
              ? IconButton(
                  onPressed: () => setState(() {
                        isDeleteClicked = !isDeleteClicked;
                      }),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded))
              : PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            'Logout',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () => {
                        FirebaseAuth.instance.signOut(),
                      },
                    )
                  ],
                )
        ],
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
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: acc.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => isDeleteClicked
                      ? null
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Account(name: acc[index]))),
                  onLongPress: () => setState(
                    () {
                      isDeleteClicked = !isDeleteClicked;
                    },
                  ),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    padding: const EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 0.5),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.account_balance_rounded),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          child: Text(
                            acc[index],
                            style: GoogleFonts.rajdhani(
                                fontSize: 25.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        isDeleteClicked
                            ? Checkbox(
                                fillColor:
                                    MaterialStateProperty.all(Colors.black),
                                checkColor: Colors.white,
                                value: isChecked[index],
                                onChanged: (value) {
                                  setState(() {
                                    isChecked[index] = value!;
                                  });
                                })
                            : Container(
                                width: 0,
                              )
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: !isDeleteClicked
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _buildAddDialog(),
            )
          : FloatingActionButton(
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.black,
              ),
              onPressed: () => _buildDeleteAlert(),
            ),
    );
  }

  Future _buildAddDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: FittedBox(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'Account',
                      style: GoogleFonts.rajdhani(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_balance_rounded),
                          suffixIcon: contoller.text.isEmpty
                              ? Container(
                                  width: 0,
                                )
                              : IconButton(
                                  onPressed: () => contoller.clear(),
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
                        controller: contoller,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Wrap(
                      spacing: MediaQuery.of(context).size.width * 0.4,
                      children: [
                        TextButton(
                            onPressed: () => {
                                  Navigator.of(context).pop(),
                                  contoller.clear()
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
            ),
          );
        });
  }

  Future _buildDeleteAlert() {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return isChecked.contains(true)
              ? AlertDialog(
                  title: Text("Do You Really Want to Delete",
                      style: GoogleFonts.rajdhani(fontWeight: FontWeight.bold)),
                  content: Text("Account data will also be lost",
                      style: GoogleFonts.rajdhani(fontWeight: FontWeight.bold)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            isDeleteClicked = false;
                            isChecked =
                                List.generate(acc.length, (index) => false);
                          });
                        },
                        child: Text("No",
                            style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.bold, fontSize: 20.0))),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          acc = LocalData().getAccount()!;
                          List<String> delAcc = [];
                          for (var i = 0; i < isChecked.length; i++) {
                            if (isChecked[i]) {
                              delAcc.add(acc[i]);
                            }
                          }
                          for (var x in delAcc) {
                            acc.remove(x);
                            LocalData().deleteAccount(x);
                          }

                          LocalData().setAccount(acc);
                          setState(() {
                            isDeleteClicked = false;
                            isChecked =
                                List.generate(acc.length, (index) => false);
                          });
                        },
                        child: Text("Delete",
                            style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.red)))
                  ],
                )
              : AlertDialog(
                  title: Text("Select the Account to delete",
                      style: GoogleFonts.rajdhani(fontWeight: FontWeight.bold)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            isDeleteClicked = false;
                          });
                        },
                        child: Text("OK",
                            style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.bold, fontSize: 20.0)))
                  ],
                );
        });
  }
}
