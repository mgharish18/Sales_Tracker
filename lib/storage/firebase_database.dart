import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

List<String> currentAccounts = [];

CollectionReference collRef = FirebaseFirestore.instance.collection('Accounts');

String getDocId(String acc) {
  return FirebaseAuth.instance.currentUser!.uid + acc.toUpperCase();
}

DocumentReference docRef(String acc) {
  return collRef.doc(getDocId(acc));
}

Future<void> saveAllAccounts(List<String> accounts) async {
  await collRef
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set({'accounts': accounts});
}

Future setAccount(String account) async {
  if (currentAccounts.any((element) => element == account.toUpperCase())) {
    return;
  } else {
    currentAccounts.add(account.toUpperCase());
    await saveAllAccounts(currentAccounts);
    final document = docRef(account);
    final Map<String, dynamic> data = {
      'account': account,
      'product': {},
      'supply': {}
    };
    await document.set(data);
  }
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getAccountStream() =>
    FirebaseFirestore.instance
        .collection('Accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

Future deleteAccount(String acc) async {
  final document = docRef(acc);
  await document.delete();
  DocumentSnapshot data =
      await collRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
  currentAccounts = [];
  for (var element in data['accounts']) {
    currentAccounts.add(element.toString());
  }
  currentAccounts.remove(acc.toUpperCase());
  saveAllAccounts(currentAccounts);
}

Future<void> setItem(String acc, String item, int price) async {
  DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
      .collection('Accounts')
      .doc(getDocId(acc))
      .get();
  Map<String, dynamic> product = data['product'];
  product[item] = price;

  await FirebaseFirestore.instance
      .collection('Accounts')
      .doc(getDocId(acc))
      .update({'product': product});
}

Future<void> saveSupply(
    String acc, DateTime date, TimeOfDay time, List<int> count) async {
  DateTime dateAndTime =
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
  DocumentSnapshot data = await docRef(acc).get();
  Map temp = data['supply'];
  temp[dateAndTime.toIso8601String()] = count;
  await docRef(acc).update({'supply': temp});
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getDocStream(String acc) =>
    FirebaseFirestore.instance
        .collection('Accounts')
        .doc(getDocId(acc))
        .snapshots();
