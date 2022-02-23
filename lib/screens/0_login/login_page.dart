import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sales_records/screens/1_home/home.dart';
import 'package:sales_records/storage/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData) {
          return const Sigin();
        } else if (snapshot.hasData) {
          return const VerifyEmailPage();
        } else {
          return const Center(
            child: Text(
              'Something went worng!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        }
      },
    );
  }
}

class Sigin extends StatefulWidget {
  const Sigin({Key? key}) : super(key: key);

  @override
  _SiginState createState() => _SiginState();
}

class _SiginState extends State<Sigin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                icon: const Icon(Icons.person),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                icon: const Icon(Icons.vpn_key_rounded),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0)),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
                onPressed: () => {
                      sigin(context, _emailController.text.trim(),
                          _passwordController.text.trim()),
                      _passwordController.text = ''
                    },
                child: const Text(
                  'Log in',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: const Text(
                    'Forget password',
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPassword())),
                ),
                GestureDetector(
                  child: const Text('New user?'),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Register())),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool isValid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create a New account',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    errorStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: const Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                textInputAction: TextInputAction.next,
                validator: (email) =>
                    email != null && EmailValidator.validate(email)
                        ? null
                        : 'Enter a valid Email',
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                  controller: _passwordController1,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      errorStyle: const TextStyle(fontWeight: FontWeight.bold),
                      icon: const Icon(Icons.vpn_key_rounded),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  textInputAction: TextInputAction.next,
                  validator: (password) {
                    if (password == null || password.length < 6) {
                      return 'Password must contain min of 6 character';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                  controller: _passwordController2,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: 'Re-enter Password',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      errorStyle: const TextStyle(fontWeight: FontWeight.bold),
                      icon: const Icon(Icons.vpn_key_rounded),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  textInputAction: TextInputAction.next,
                  validator: (password) {
                    if (password != _passwordController1.text) {
                      return "Password doesn't match";
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                  onPressed: () => sigup(
                      context,
                      formKey,
                      _emailController.text.trim(),
                      _passwordController1.text.trim()),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                  ),
                  GestureDetector(
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () => Navigator.of(context).pop()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late bool isValid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    errorStyle: const TextStyle(fontWeight: FontWeight.bold),
                    icon: const Icon(Icons.person),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(10.0)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                textInputAction: TextInputAction.next,
                validator: (email) =>
                    email != null && EmailValidator.validate(email)
                        ? null
                        : 'Enter a valid Email',
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                  onPressed: () => resetPassword(
                      context, formKey, _emailController.text.trim()),
                  child: const Text(
                    'Send Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
  }
}

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = true;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkVerified();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const HomeScreen()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'An verification Email was sent to your Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton.icon(
                      onPressed: () async {
                        if (canResendEmail) {
                          sendVerificationEmail();
                          setState(() {
                            canResendEmail = false;
                          });
                          await Future.delayed(const Duration(minutes: 1));
                          setState(() {
                            canResendEmail = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50.0)),
                      icon: const Icon(Icons.mail_rounded),
                      label: const Text(
                        'Resend Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () => FirebaseAuth.instance.signOut(),
                  )
                ],
              ),
            ),
          );
  }

  Future checkVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }
}
