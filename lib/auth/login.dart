import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_project/components/custombuttonauth.dart';
import 'package:progress_project/components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20),
              const Text("Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Container(height: 10),
              Container(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(height: 10),
              CustomTextForm(hinttext: "Enter Your Email", mycontroller: email),
              Container(height: 10),
              const Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Container(height: 10),
              CustomTextForm(
                  hinttext: "Enter Your Password", mycontroller: password),
              Container(height: 30),
            ],
          ),
          CustomButtonAuth(
              title: "login",
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                  if (credential.user!.emailVerified) {
                    Navigator.of(context).pushNamed("scrapeddata");
                    // Get and print the user ID
                    String? userID = await getUserID();
                    if (userID != null) {
                      print('User ID: $userID');
                    } else {
                      print('User ID not found.');
                    }
                  } else {
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.scale,
                      title: 'Sorry',
                      desc:
                          'you have to verify your Email from your Gmail by press on the link that we sent to you!',
                    ).show();
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    if (kDebugMode) {
                      print('No user found for that email.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.scale,
                        title: 'Sorry',
                        desc:
                            'No user found for that email,try to SignUp if you have not to',
                      ).show();
                    }
                  } else if (e.code == 'wrong-password') {
                    if (kDebugMode) {
                      print('Wrong password provided for that user.');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.scale,
                        title: 'Sorry',
                        desc: 'Wrong password provided for that user',
                      ).show();
                    }
                  }
                }
              }),
          Container(height: 20),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed("signup");
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Don't Have An Account ? ",
                ),
                TextSpan(
                    text: "SignUp",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
