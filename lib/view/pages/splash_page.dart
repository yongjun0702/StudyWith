import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_with/config/color/color.dart';
import 'package:study_with/view/pages/home_page.dart';
import 'package:study_with/view/widgets/tab_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /// <1.5초 뒤 로그인 페이지로 이동>
    Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              child: Image.asset("assets/img/logo.png"),
            ),
          ],
        ),
      ),
    );
  }
}
