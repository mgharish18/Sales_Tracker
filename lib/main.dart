import 'package:flutter/material.dart';
import 'package:sales_records/screens/home.dart';

import 'package:sales_records/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalData().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
