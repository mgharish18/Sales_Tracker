import 'dart:convert';
import "dart:collection";

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    String key = acc + 'SalesLog';
    temp = jsonDecode(account.getString(key) ?? jsonEncode(value));
    temp.forEach((key, values) {
      value[key] = values;
    });
    return value;
  }
}
