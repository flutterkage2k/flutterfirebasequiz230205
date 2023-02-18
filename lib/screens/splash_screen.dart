import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int timeLeft = 4;

  void _startCountDown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startCountDown();
    _navigatepage();
  }

  _navigatepage() async {
    await Future.delayed(Duration(seconds: 4), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/icons/appicon.png',
                height: 100,
                width: 100,
              ),
            ),
            Container(
              child: Text(
                "Korean workbook",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Container(
              child: Text("한국어 문제집"),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Text("문제는 계속 업데이트 됩니다.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Container(
              child: Text("홈화면으로 넘어가는 남은 시간(초) :  " + timeLeft.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
