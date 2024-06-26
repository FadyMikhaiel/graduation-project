import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:progress_project/alarm/alarm.dart';

class Todolist extends StatefulWidget {
  const Todolist({Key? key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  String _name = '';
  List<String> _lectureDetails = [];
  List<String> _workshopDetails = [];
  int _selectedIndex = 1;

  List<Map<String, dynamic>> tasks = [];
  String inputTask = "";

  @override
  void initState() {
    super.initState();
    // AlarmService.mainFun();

    // Call fetchData() to get lecture and workshop details
    fetchData();

    // Call getUserTasks() when the page is initialized
    getUserTasks().then((userTasks) {
      setState(() {
        tasks = userTasks;
      });
    }).catchError((error) {
      print("Error fetching user tasks: $error");
    });
  }

// Function to get user ID
  Future<String?> getUserID() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Retrieve user document from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        // Get the userID field from the document
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? userID = userData['userID'];

        return userID;
      } else {
        // User is not logged in
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user ID: $e');
      }
      return null;
    }
  }

  Future<void> fetchData() async {
    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now);
    String? userID = await getUserID();
    String apiUrl = 'http://127.0.0.1:8000/scrape/${userID}/';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final data = jsonDecode(response.body);
        // Extract lectures
        if (data['lecture'] != null) {
          List lectures = data['lecture'];
          setState(() {
            _lectureDetails = lectures.map<String>((lecture) {
              final parts = lecture.split(',');
              if (parts.length >= 4) {
                if (parts[1].trim().split(':')[1].trim() == dayName) {
                  AlarmService.scheduleAlarm(
                      'Attention',
                      'You have: ${parts[0].trim().split(':')[1].trim()} today!');
                  createTask(
                      'Study ${parts[0].trim().split(':')[1].trim()} lecture');
                }
              }

              return '';
            }).toList();
            print('fetchdata tasks: $tasks');
          });
        }

        // Extract workshops
        if (data['workshop'] != null) {
          List workshops = data['workshop'];
          setState(() {
            _workshopDetails = workshops.map<String>((workshop) {
              final parts = workshop.split(',');
              if (parts.length >= 4) {
                if (parts[1].trim().split(':')[1].trim() == dayName) {
                  AlarmService.scheduleAlarm('Attention', 'You have: ${parts[0].trim().split(':')[1].trim()} today!');
                  createTask(
                      'Study ${parts[0].trim().split(':')[1].trim()} Workshop');
                }
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

  void createTask(String inputTask) async {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (inputTask.isNotEmpty) {
      // Check if the task already exists in the tasks list
      bool taskExists = tasks.any((task) => task['taskTitle'] == inputTask);

      if (!taskExists) {
        // Reference to the document with user's UID as part of the path
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("tasks")
            .doc(inputTask);

        Map<String, dynamic> taskData = {
          "taskTitle": inputTask,
          "status": "todo" // Initial status is set to "todo"
        };

        // Set the task document with the data
        await documentReference.set(taskData).then((_) {
          print("$inputTask created");
          // Add the new task to the tasks list and update the UI
          print("create task tasks :$tasks");
          setState(() {
            tasks.add({'taskTitle': inputTask, 'status': 'todo'});
          });
        }).catchError((error) => print("Failed to create task: $error"));
      } else {
        print('Task already exists.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Empty task is not allowed.'),
      ));
    }
  }

  Future<List<Map<String, dynamic>>> getUserTasks() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Reference to the tasks collection for the user
    CollectionReference tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks");

    // Query tasks and retrieve their titles
    QuerySnapshot querySnapshot = await tasksRef.get();
    List<Map<String, dynamic>> tasks = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['taskTitle'] != null) {
        tasks.add({
          'taskTitle': data['taskTitle'] as String,
          'status': data['status'] as String
        });
      }
    });
    setState(() {
      this.tasks = tasks;
    });
    print("getUserTasks: $tasks");
    return tasks;
  }

  // Function to delete task from Firebase
  Future<void> deleteTask(String task) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks");

    await tasksRef.doc(task).delete().then((_) {
      setState(() {
        tasks.removeWhere((element) => element['taskTitle'] == task);
      });
      print("Task deleted successfully");
      print("deleteTask: $tasks");
    }).catchError((error) => print("Failed to delete task: $error"));
  }

  // Function to update task status
  Future<void> updateTaskStatus(String task, bool isChecked) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks");

    String newStatus = isChecked
        ? 'done'
        : 'todo'; // Determine the new status based on isChecked

    try {
      await tasksRef.doc(task).update({'status': newStatus});
      print("Task status updated successfully");
      setState(() {
        tasks.firstWhere((element) => element['taskTitle'] == task)['status'] =
            newStatus;
      });
    } catch (error) {
      print("Failed to update task status: $error");
      // Throw the error to handle it further if needed
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: const Text("Add Task"),
                  content: TextField(
                    onChanged: (String value) {
                      inputTask = value;
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        if (inputTask.isNotEmpty) {
                          createTask(inputTask);
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Empty task is not allowed.'),
                          ));
                        }
                      },
                      child: const Text("Add"),
                    )
                  ],
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.orange,
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          String taskTitle = tasks[index]['taskTitle'];
          String status = tasks[index]['status'];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(taskTitle),
              subtitle: Text(status),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: status == 'done',
                    onChanged: (isChecked) {
                      setState(() {
                        updateTaskStatus(taskTitle, isChecked!);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete Task"),
                            content: Text(
                                "Are you sure you want to delete this task?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // tasks.removeWhere((element) => element['taskTitle'] == taskTitle);
                                  deleteTask(taskTitle);
                                  Navigator.pop(context);
                                  print(
                                      "/////////////////////////////////////////////////$tasks");
                                },
                                child: Text("Delete"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
            Navigator.of(context).pushReplacementNamed("scrapeddata");
          } else {
            setState(() {
              _selectedIndex = index;
            });
            Navigator.of(context).pushReplacementNamed("todolist");
          }
        },
      ),
    );
  }
}
