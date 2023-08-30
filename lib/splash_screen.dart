import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      body: Center(
          child: Container(
        decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(300), bottomRight: Radius.circular(300)),
        ),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        child: const Text(
          " To-Do ",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 60, color: Colors.white),
        ),
      )),
    );
  }
}
