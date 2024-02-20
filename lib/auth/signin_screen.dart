import 'package:demo_project/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _getPrefrenceInstance();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _signinView(),
    );
  }

  _signinView() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sign In",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            _emailView(),
            const SizedBox(
              height: 10,
            ),
            _passwordView(),
            const SizedBox(
              height: 20,
            ),
            _signinButton()
          ],
        ),
      ),
    );
  }

  _emailView() {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(hintText: "Enter Email"),
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter email";
        } else if (!RegExp(
                r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
            .hasMatch(val)) {
          return 'Invalid Email';
        } else {
          return null;
        }
      },
    );
  }

  _passwordView() {
    return TextFormField(
      controller: passwordController,
      decoration: const InputDecoration(hintText: "Enter Password"),
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter email";
        } else {
          return null;
        }
      },
    );
  }

  _signinButton() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            _signIn();
          }
        },
        child: const Text("SignIn"));
  }

  _signIn() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    try {
      await auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        if (value.user != null) {
          prefs?.setBool("isLogin", true);
          isLoading = false;
          if (mounted) {
            setState(() {});
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });
    } catch (e) {
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
      throw e.toString();
    }
  }

  _getPrefrenceInstance() async {
    prefs = await SharedPreferences.getInstance();
  }
}
