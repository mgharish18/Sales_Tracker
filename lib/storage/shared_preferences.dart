import 'dart:convert';
import "dart:collection";

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LocalData {
  static late SharedPreferences account;
  Map itemmap = {};
  Map temp = {};
  SplayTreeMap value = SplayTreeMap();

  Future init() async {
    return account = await SharedPreferences.getInstance();
  }

  Future<void> setAccount(List<String> acc) async {
    await account.setStringList('Account', acc);

    // setItem(acc[0], 'VEG', 20);
    // setItem(acc[0], 'EGG', 20);
    // setItem(acc[0], 'CHI', 25);
    // setItem(acc[0], 'SP', 25);
    // setItem(acc[0], 'SAM', 10);
    // for (int i = 1; i < 30; i++) {
    //   if (i % 2 == 0) {
    //     saveCount(acc[0], DateFormat('yy-m-d').parse('22-1-$i'),
    //         TimeOfDay.fromDateTime(DateTime.now()), [
    //       100 + (3 * i),
    //       50 + (3 * i),
    //       50 + (3 * i),
    //       25 + (3 * i),
    //       10 + (3 * i)
    //     ]);
    //   } else {
    //     saveCount(acc[0], DateFormat('yy-m-d').parse('2022-1-$i'),
    //         TimeOfDay.fromDateTime(DateTime.now()), [
    //       100 + (2 * i),
    //       50 + (2 * i),
    //       50 + (2 * i),
    //       25 + (2 * i),
    //       10 + (2 * i)
    //     ]);
    //   }
    // }
  }

  List<String>? getAccount() {
    return account.getStringList('Account');
  }

  Future<void> setItem(String acc, String item, int price) async {
    itemmap = getItem(acc);
    itemmap[item] = price;
    await account.setString(acc, jsonEncode(itemmap));
  }

  Map getItem(String acc) {
    return jsonDecode(account.getString(acc) ?? jsonEncode(itemmap));
  }

  Future<void> saveCount(
      String acc, DateTime date, TimeOfDay time, List<int> count) async {
    String log = 'SalesLog';
    String key = acc + log;
    DateTime dateAndTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    value = getSalesLog(acc);
    value[dateAndTime.toIso8601String()] = count;
    await account.setString(key, jsonEncode(value));
  }

  SplayTreeMap getSalesLog(String acc) {
    SplayTreeMap value = SplayTreeMap();
    String key = acc + 'SalesLog';
    temp = jsonDecode(account.getString(key) ?? jsonEncode(value));
    temp.forEach((key, values) {
      value[key] = values;
    });
    return value;
  }

  void deleteAccount(acc) {
    account.remove(acc);
    account.remove(acc + 'SalesLog');
  }
}
