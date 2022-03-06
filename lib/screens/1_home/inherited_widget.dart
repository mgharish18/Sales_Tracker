import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sales_records/storage/firebase_database.dart';

class StateWidget extends StatefulWidget {
  final Widget child;

  const StateWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _StateWidgetState createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  late List<String> acc;
  List<bool> isChecked = [];
  bool isDeleteClicked = false;

  @override
  void initState() {
    super.initState();
  }

  void setIsChecked(List<bool> isChecked) {
    setState(() {
      this.isChecked = isChecked;
    });
  }

  void setIsDeleteClicked(bool bool) {
    setState(() {
      isDeleteClicked = bool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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

                if (isChecked.length != acc.length) {
                  isChecked = List.generate(acc.length, (index) => false);
                }
              }
            } else {
              acc = [];
              (isChecked.length != acc.length)
                  ? isChecked = List.generate(acc.length, (index) => false)
                  : null;
            }

            return StateInheritedWidget(
              child: widget.child,
              acc: acc,
              isChecked: isChecked,
              isDeleteClicked: isDeleteClicked,
              stateWidget: this,
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went worng'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class StateInheritedWidget extends InheritedWidget {
  final List<String> acc;
  final List<bool> isChecked;
  final bool isDeleteClicked;
  final _StateWidgetState stateWidget;

  const StateInheritedWidget({
    Key? key,
    required Widget child,
    required this.acc,
    required this.isChecked,
    required this.isDeleteClicked,
    required this.stateWidget,
  }) : super(key: key, child: child);

  static StateInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateInheritedWidget>()!;
  }

  @override
  bool updateShouldNotify(StateInheritedWidget oldWidget) => true;
}
