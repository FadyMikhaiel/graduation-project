import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_project/auth/login.dart';
import 'package:progress_project/auth/signup.dart';
import 'package:progress_project/homepage.dart';
import 'package:progress_project/todolist/todolist.dart';
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
      title: 'API Call Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "signup": (context) => const SignUp(),
        "login": (context) => const Login(),
        "homepage": (context) => const Homepage(),
        "todolist": (context) => const Todolist(),
      },
      home: const SignUp(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name = '';
  String _lectures = '';
  String _workshops = '';

  Future<void> fetchData() async {
    String apiUrl = 'http://127.0.0.1:8000/scrape/'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final data = jsonDecode(response.body);
        // Extract the name, lectures, and workshops fields
        final name = data['name'][0];
        final lectures = data['lecture'][0];
        final workshops = data['workshop'][0];
        // Update the UI with the extracted data
        setState(() {
          _name = name != null ? name.toString() : '';
          _lectures = lectures != null ? lectures.toString() : '';
          _workshops = workshops != null ? workshops.toString() : '';
        });
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Call Button'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Call API'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Lectures:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _lectures,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Workshops:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _workshops,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
