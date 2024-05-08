// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:progress_project/auth/login.dart';
import 'package:progress_project/auth/signup.dart';
import 'package:progress_project/homepage.dart';
import 'package:progress_project/todolist/todolist.dart';
import 'package:progress_project/web_scraping/scraped_data.dart';
// import 'package:progress_project/web_scraping/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Call Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (context) => const Homepage(),
        "todolist": (context) => const Todolist(),
        "scrapeddata":(context) => const MyHomePage()
      },
      home: const Todolist(),
    );
  }
}

