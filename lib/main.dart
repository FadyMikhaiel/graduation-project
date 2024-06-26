// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
import 'package:progress_project/auth/login.dart';
import 'package:progress_project/auth/signup.dart';
import 'package:progress_project/todolist/todolist.dart';
import 'package:progress_project/web_scraping/scraped_data.dart';
// import 'package:progress_project/web_scraping/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp>{
  // int selectedIndex = 0;
  // final List<Widget> _pages = [
  //   const MyHomePage(),
  //   const Todolist(),
  // ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Progress App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "todolist": (context) => const Todolist(),
        "scrapeddata": (context) => const MyHomePage()
      },
      home: const SignUp(),
    );
  }
}
