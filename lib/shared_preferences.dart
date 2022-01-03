import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static late SharedPreferences account;

  Future init() async {
    return account = await SharedPreferences.getInstance();
  }

  Future<void> setAccount(List<String> acc) async {
    await account.setStringList('Account', acc);
  }

  List<String>? getAccount() {
    return account.getStringList('Account');
  }
}
