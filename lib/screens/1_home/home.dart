import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sales_records/screens/1_home/inherited_widget.dart';

import 'package:sales_records/screens/2_products_entry/entry_screen.dart';
import 'package:sales_records/storage/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final contoller = TextEditingController();
  late List<String> acc;
  late bool isDeleteClicked;
  late List<bool> isChecked;

  @override
  void initState() {
    super.initState();

    // contoller.addListener(() => setState(() {}));
  }

  void addAccound() {
    Navigator.of(context).pop();
    contoller.text.isNotEmpty ? setAccount(contoller.text) : null;
    contoller.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateDeleteStatus() {
    Navigator.of(context).pop();
    StateInheritedWidget.of(context).stateWidget.setIsDeleteClicked(false);

    StateInheritedWidget.of(context)
        .stateWidget
        .setIsChecked(List.generate(acc.length, (index) => false));
  }

  void deleteAccountLocal() {
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

    StateInheritedWidget.of(context)
        .stateWidget
        .setIsChecked(List.generate(acc.length, (index) => false));
    StateInheritedWidget.of(context).stateWidget.setIsDeleteClicked(false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDeleteClicked = StateInheritedWidget.of(context).isDeleteClicked;
    acc = StateInheritedWidget.of(context).acc;
    isChecked = StateInheritedWidget.of(context).isChecked;
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
                  onPressed: () {
                    StateInheritedWidget.of(context).stateWidget.setIsChecked(
                        List.generate(acc.length, (index) => false));
                    StateInheritedWidget.of(context)
                        .stateWidget
                        .setIsDeleteClicked(false);
                  },
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
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 25),
                curve: Curves.bounceIn,
                duration: const Duration(seconds: 1),
                builder: (BuildContext context, double value, Widget? child) {
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
                return ListOfAccount(index: index);
              }),
      floatingActionButton: !isDeleteClicked
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _scaleDialogAdd(context),
            )
          : FloatingActionButton(
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.black,
              ),
              onPressed: () => _scaleDialogDelete(context),
            ),
    );
  }

  Future<void> _scaleDialogAdd(BuildContext context) {
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

  Future<void> _scaleDialogDelete(BuildContext context) {
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
                  onPressed: () => updateDeleteStatus(),
                  child: Text("No",
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, fontSize: 20.0))),
              TextButton(
                  onPressed: () => deleteAccountLocal(),
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
                  onPressed: () => updateDeleteStatus(),
                  child: Text("OK",
                      style: GoogleFonts.rajdhani(
                          fontWeight: FontWeight.bold, fontSize: 20.0)))
            ],
          );
  }
}

// ignore: must_be_immutable
class ListOfAccount extends StatefulWidget {
  int index;
  ListOfAccount({Key? key, required this.index}) : super(key: key);

  @override
  State<ListOfAccount> createState() => _ListOfAccountState();
}

class _ListOfAccountState extends State<ListOfAccount>
    with SingleTickerProviderStateMixin {
  late int index;
  late List<String> acc;
  late List<bool> isChecked;
  late bool isDeleteClicked;
  late AnimationController _animationController;
  late Animation iconColorAnimation;
  late Animation textColorAnimation;
  late Animation containerColorAnimation;
  late Animation leadingIconColorAnimation;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    iconColorAnimation = ColorTween(begin: Colors.white, end: Colors.red)
        .animate(_animationController);
    textColorAnimation = ColorTween(begin: Colors.black, end: Colors.white)
        .animate(_animationController);
    containerColorAnimation =
        ColorTween(begin: Colors.amberAccent, end: Colors.black54)
            .animate(_animationController);
    leadingIconColorAnimation = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animationController);
    sizeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 25, end: 15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 15, end: 35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 35, end: 25), weight: 30)
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    index = widget.index;
    acc = StateInheritedWidget.of(context).acc;
    isChecked = StateInheritedWidget.of(context).isChecked;
    isDeleteClicked = StateInheritedWidget.of(context).isDeleteClicked;
    if (!isChecked[index] &&
        _animationController.status == AnimationStatus.completed) {
      _animationController.reset();
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, _) {
        return GestureDetector(
          onTap: () => isDeleteClicked
              ? null
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Account(name: acc[index]))),
          onLongPress: () {
            StateInheritedWidget.of(context)
                .stateWidget
                .setIsDeleteClicked(true);
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            padding: const EdgeInsets.only(left: 10.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(width: 0.5),
                color: containerColorAnimation.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.account_balance_rounded,
                  color: leadingIconColorAnimation.value,
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
                          color: textColorAnimation.value,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                isDeleteClicked
                    ? IconButton(
                        icon: Icon(
                          Icons.delete_rounded,
                          color: iconColorAnimation.value,
                          size: sizeAnimation.value,
                        ),
                        onPressed: () {
                          isChecked[index] = !isChecked[index];
                          if (isChecked[index] == true) {
                            _animationController.forward();
                          } else {
                            _animationController.reverse();
                          }

                          StateInheritedWidget.of(context)
                              .stateWidget
                              .setIsChecked(isChecked);
                        })
                    : Container(
                        width: 0,
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
