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
            return Dismissible(
                key: ValueKey(tasks[index]),
                onDismissed: (direction) {
                  setState(() {
                    // Remove the dismissed item from the data source
                    tasks.removeAt(index);
                  });
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
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                    ),
                  ),
                ));
          }),
    );
  }
}
