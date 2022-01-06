import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences account;
  Map itemmap = {};

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
    account.setString(acc, jsonEncode(itemmap));
  }

  Map getItem(String acc) {
    return jsonDecode(account.getString(acc) ?? jsonEncode(itemmap));
  }
}
