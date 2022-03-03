import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sales_records/screens/2_products_entry/entry_screen.dart';
import 'package:sales_records/storage/firebase_database.dart';

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
  Color _color = Colors.amber;
  Color _txtColor = Colors.black;

  @override
  void initState() {
    super.initState();
    // contoller.addListener(() => setState(() {}));
    isChecked = List.generate(acc.length, (index) => false);
    isDeleteClicked = false;
  }

  void addAccound() {
    Navigator.of(context).pop();
    contoller.text.isNotEmpty ? setAccount(contoller.text) : null;
    contoller.clear();
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
                        isDeleteClicked = false;
                        isChecked = List.generate(acc.length, (index) => false);
                        _color = Colors.amber;
                        _txtColor = Colors.black;
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
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getAccountStream(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                Map<String, dynamic>? data = snapshot.data!.data();
                acc = [];
                currentAccounts = [];
                if (data != null) {
                  List<dynamic> list = data['accounts'];
                  for (var element in list) {
                    acc.add(element.toString());
                    currentAccounts.add(element.toString());
                  }
                  (isChecked.length != acc.length)
                      ? isChecked = List.generate(acc.length, (index) => false)
                      : null;
                }
              } else {
                acc = [];
                (isChecked.length != acc.length)
                    ? isChecked = List.generate(acc.length, (index) => false)
                    : null;
              }
              return acc.isEmpty
                  ? Center(
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 25),
                        duration: const Duration(seconds: 1),
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return Text(
                            'No Accounts yet\nCreate a new one',
                            style: GoogleFonts.rajdhani(
                                fontSize: value,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        },
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
                                      builder: (context) =>
                                          Account(name: acc[index]))),
                          onLongPress: () => setState(
                            () {
                              isDeleteClicked = true;
                            },
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(width: 0.5),
                                color: _color),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.account_balance_rounded,
                                  color: _txtColor,
                                ),
                                const SizedBox(
                                  width: 15.0,
                                ),
                                Expanded(
                                  child: Hero(
                                    tag: acc[index],
                                    child: Text(
                                      acc[index],
                                      style: GoogleFonts.rajdhani(
                                          fontSize: 25.0,
                                          color: _txtColor,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                isDeleteClicked
                                    ? Checkbox(
                                        fillColor: MaterialStateProperty.all(
                                            Colors.white),
                                        checkColor: Colors.red,
                                        value: isChecked[index],
                                        onChanged: (value) {
                                          setState(() {
                                            isChecked[index] = value!;
                                            if (value) {
                                              _color = Colors.red;
                                              _txtColor = Colors.white;
                                            } else {
                                              _color = Colors.amber;
                                              _txtColor = Colors.black;
                                            }
                                          });
                                        })
                                    : Container(
                                        width: 0,
                                      )
                              ],
                            ),
                          ),
                        );
                      });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went worng'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: !isDeleteClicked
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _scaleDialogAdd(),
            )
          : FloatingActionButton(
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.black,
              ),
              onPressed: () => _scaleDialogDelete(),
            ),
    );
  }

  Future<void> _scaleDialogAdd() {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, a1, a2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _buildAddDialog(context),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildAddDialog(BuildContext context) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 500),
      elevation: 50.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
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
                      onPressed: () =>
                          {Navigator.of(context).pop(), contoller.clear()},
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
  }

  Future<void> _scaleDialogDelete() {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, a1, a2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _buildDeleteAlert(context),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildDeleteAlert(BuildContext context) {
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
                      isChecked = List.generate(acc.length, (index) => false);
                      _color = Colors.amber;
                      _txtColor = Colors.black;
                    });
                  },
                  child: Text("No",
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, fontSize: 20.0))),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    List<String> delAcc = [];
                    for (var i = 0; i < isChecked.length; i++) {
                      if (isChecked[i]) {
                        delAcc.add(acc[i]);
                      }
                    }
                    for (var x in delAcc) {
                      acc.remove(x);
                      deleteAccount(x);
                    }
                    setState(() {
                      isDeleteClicked = false;
                      _color = Colors.amber;
                      _txtColor = Colors.black;
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
                      _color = Colors.amber;
                      _txtColor = Colors.black;
                    });
                  },
                  child: Text("OK",
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, fontSize: 20.0)))
            ],
          );
  }
}
