import 'dart:convert';

import 'package:demo_project/auth/signup_screen.dart';
import 'package:demo_project/home_data_model.dart';
import 'package:demo_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  var homeData = HomeData();
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _getHomeApiData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                _signOut();
              },
              child: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: _homeView(),
    );
  }

  _homeView() {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : (homeData.data ?? []).isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: homeData.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                              homeData.data![index]["ecom_ae_vendor_id"] ?? ""),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(homeData.data![index]["ecom_ae_vendor_name"] ??
                              ""),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(homeData.data![index]["ecom_ae_vendor_status"] ??
                              ""),
                        ],
                      ),
                    ),
                  );
                })
            : const Center(
                child: Text("No data found..."),
              );
  }

  Future _getHomeApiData() async {
    try {
      await http
          .get(Uri.parse("https://mybar.sg/uatnew/index.php/api/get_vendors"))
          .then((value) {
        if (value.statusCode == 200) {
          var res = jsonDecode(value.body);
          homeData = HomeData.fromJson(res);
          isLoading = false;
          setState(() {});
        } else {
          isLoading = false;
          if (mounted) {
            setState(() {});
          }
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

  void _signOut() async {
    await auth.signOut().then((value) {
      prefs?.clear();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SignupScreen()));
    });
  }
}
