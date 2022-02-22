import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_records/main.dart';

Future<void> sigin(context, email, password) async {
  FocusScope.of(context).unfocus();
  showDialog(
      context: context,
      builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
      barrierDismissible: false);
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    mainNavigatorKey.currentState!.pop();
    return Utils.showSnackBar(e.message);
  }
  mainNavigatorKey.currentState!.popUntil((route) => route.isFirst);
}

Future sigup(context, formKey, email, password) async {
  FocusScope.of(context).unfocus();
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;

  showDialog(
      context: context,
      builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
      barrierDismissible: false);
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    mainNavigatorKey.currentState!.popUntil((route) => route.isFirst);
    return Utils.showSnackBar(e.message);
  }
  mainNavigatorKey.currentState!.popUntil((route) => route.isFirst);
  const snackbar = SnackBar(
      content: Text(
    'Account Created Successfully',
    style: TextStyle(fontWeight: FontWeight.bold),
  ));

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Future resetPassword(context, formKey, email) async {
  FocusScope.of(context).unfocus();
  final isValid = formKey.currentState!.validate();
  if (!isValid) return;
  showDialog(
      context: context,
      builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
      barrierDismissible: false);
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } on FirebaseAuthException catch (e) {
    mainNavigatorKey.currentState!.pop();
    return Utils.showSnackBar(e.message);
  }
  mainNavigatorKey.currentState!.popUntil((route) => route.isFirst);
  const snackbar = SnackBar(
      content: Text(
    'Email sent Successfully',
    style: TextStyle(fontWeight: FontWeight.bold),
  ));

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

Future sendVerificationEmail() async {
  try {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  } catch (e) {
    Utils.showSnackBar(e.toString());
  }
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static showSnackBar(String? text) {
    if (text == null) {
      return;
    }
    final snackbar = SnackBar(
        content: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
