import 'package:demo_project/auth/signin_screen.dart';
import 'package:demo_project/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _getPrefInstance();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _getPrefInstance() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs?.getBool("isLogin") ?? false) {
      Future.delayed(const Duration(seconds: 1)).then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: _signupView(),
    ));
  }

  _signupView() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Sign Up",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _signupButton(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SigninScreen()));
                    },
                    child: Text("Login"))
              ],
            )
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
                r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
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

  _signupButton() {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _signUp();
              }
            },
            child: const Text("SignUp"));
  }

  _signUp() async {
    isLoading = true;
    if (mounted) {
      setState(() {});
    }
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        if (value.user != null) {
          isLoading = false;
          if (mounted) {
            setState(() {});
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SigninScreen()));
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
}
