import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/firebase_options.dart';
import 'package:flutterfirebasequiz230205/screens/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korean testing',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: SplashScreen(),
    );

    // return MaterialApp(
    //   theme: ThemeData(primarySwatch: Colors.teal),
    //   home: StreamBuilder<User?>(
    //     stream: AuthService().authState,
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (snapshot.connectionState == ConnectionState.done ||
    //           snapshot.connectionState == ConnectionState.active) {
    //         if (snapshot.hasData) {
    //           return const NewHomePage();
    //         } else {
    //           return const LoginScreen();
    //         }
    //       } else {
    //         return Center(
    //           child: Text('State: ${snapshot.connectionState}'),
    //         );
    //       }
    //     },
    //   ),
    // );
  }
}
