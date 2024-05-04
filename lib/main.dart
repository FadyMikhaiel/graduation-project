import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
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
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Call Button'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Call API'),
            ),
            SizedBox(height: 20),
            Text(
              'Name:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _name,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Lectures:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _lectures,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Workshops:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _workshops,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
