import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  List<String> tasks = [];
  String inputTask = "";
  @override
  void initState() {
    super.initState();
    // Call getUserTasks() when the page is initialized
    getUserTasks().then((userTasks) {
      setState(() {
        tasks = userTasks;
      });
    }).catchError((error) {
      print("Error fetching user tasks: $error");
    });
  }

  createTask(String inputTask) async {
    // Get the current user's UID
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if (inputTask != "") {
      // Reference to the document with user's UID as part of the path
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("tasks")
          .doc(inputTask);

      Map<String, String> taskData = {"taskTitle": inputTask, "status": "todo"};

      // Set the task document with the data
      await documentReference
          .set(taskData)
          .then((_) => print("$inputTask created"))
          .catchError((error) => print("Failed to create task: $error"));
    }
  }

  Future<List<String>> getUserTasks() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Reference to the tasks collection for the user
    CollectionReference tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks");

    // Query tasks and retrieve their titles
    QuerySnapshot querySnapshot = await tasksRef.get();
    List<String> tasks = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null && data['taskTitle'] != null) {
        tasks.add(data['taskTitle'] as String);
      }
    });

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
        tasks.remove(task);
      });
      print("Task deleted successfully");
    }).catchError((error) => print("Failed to delete task: $error"));
  }

// Function to update task status
  Future<void> updateTaskStatus(String task, bool isChecked) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference tasksRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("tasks");

    try {
      await tasksRef.doc(task).update({'status': isChecked ? 'done' : 'todo'});
      // setState(() {
      //   tasks.firstWhere((task) => task['taskTitle'] == task)['status'] = isChecked ? 'done' : 'todo';
      // });
      print("Task status updated successfully");
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
                        createTask(inputTask);
                        setState(() {
                          tasks.add(inputTask);
                        });
                        Navigator.of(context).pop();
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
            String task = tasks[index];

            return Dismissible(
                key: ValueKey(tasks[index]),
                onDismissed: (direction) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete Task"),
                        content:
                            Text("Are you sure you want to delete this task?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteTask(task);
                              Navigator.pop(context);
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.orange,
                      ),
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
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteTask(task);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ));
          }),
    );
  }
}
