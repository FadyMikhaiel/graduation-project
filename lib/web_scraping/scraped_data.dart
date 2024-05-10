import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _name = '';
  List<String> _lectureDetails = [];
  List<String> _workshopDetails = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String apiUrl = 'http://127.0.0.1:8000/scrape/'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final data = jsonDecode(response.body);

        // Extract name
        final name = data['name'][0];
        setState(() {
          _name = name != null ? name.toString() : '';
        });

        // Extract lectures
        if (data['lecture'] != null) {
          List lectures = data['lecture'];
          setState(() {
            _lectureDetails = lectures.map<String>((lecture) {
              final parts = lecture.split(',');
              if (parts.length >= 4) {
                return '${parts[0].trim()} - ${parts[1].trim()} - ${parts[2].trim()} - ${parts[3].trim()}';
              }
              return '';
            }).toList();
          });
        }

        // Extract workshops
        if (data['workshop'] != null) {
          List workshops = data['workshop'];
          setState(() {
            _workshopDetails = workshops.map<String>((workshop) {
              final parts = workshop.split(',');
              if (parts.length >= 4) {
                return '${parts[0].trim()} - ${parts[1].trim()} - ${parts[2].trim()} - ${parts[3].trim()}';
              }
              return '';
            }).toList();
          });
        }
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            const SizedBox(height: 20),
           Container(

            ),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              _name,
              style: const TextStyle(fontSize: 16),
            ),
            //const SizedBox(height: 10),
            const Text(
              'Lecture Details:',
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: _lectureDetails.map((detail) {
                return Text(
                  detail,
                  style: const TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            const Text(
              'Workshop Details:',
              style: TextStyle(fontSize: 20),
            ),
            Column(
              children: _workshopDetails.map((detail) {
                return Text(
                  detail,
                  style: const TextStyle(fontSize: 16),
                );
              }).toList(),
            ),
          ],
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tasks',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
       if (index == 0) {
          setState(() {
              _selectedIndex = index;
            });
            Navigator.of(context).pushNamed("scrapeddata");

          } else {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.of(context).pushNamed("todolist");
          }
        },
      ),
      
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MyHomePage(),
  ));
}
