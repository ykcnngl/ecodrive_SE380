import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/myhomepage.dart';
import 'package:ecodrive/Opening/Myloginbutton.dart';
import 'package:ecodrive/Opening/signup.dart';
import 'package:flutter/material.dart';
import 'package:ecodrive/globals.dart' as globals;
import 'mytextfield.dart';

class Login extends StatelessWidget {
  final EkoIdController = TextEditingController();
  final passwordController = TextEditingController();

  Login({super.key});

  void LoginUser(BuildContext context) async {
    final ekoid = EkoIdController.text.trim();
    final password = passwordController.text.trim();

    if (ekoid.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ERROR"),
          content: const Text("Please fill  all the spaces"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }
    print('EkoID: $ekoid');
    print('Password: $password');
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(ekoid).get();
      if (userDoc.exists && userDoc['password'] == password) {
        globals.currentEkoId = ekoid;
        print("Current EkoID: ${globals.currentEkoId}");

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()));
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("ERROR"),
            content: const Text("Incorrect EkoID or password."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Okay"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ERROR"),
          content: const Text("Incorrect EkoID or password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okey"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 50),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        SingleChildScrollView(                 // We added scroll for pixel issues according to phone from phone
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                Text(
                    "Welcome Back ,"
                    "\nYou've Been Missed!",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[700])),
                //ekoid
                const SizedBox(height: 25),
                myTextfield(
                  controller: EkoIdController,
                  hintText: "EkoID",
                  obscureText: false,
                ),
                //pasword
                const SizedBox(height: 10),
                myTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                //Login
                const SizedBox(height: 25),
                Myloginbutton(
                  onTap: () {
                    LoginUser(context);
                  },
                ),

                //Sign up
                const SizedBox(height: 205),
                const Text(
                  "Not a member ?",
                  style: TextStyle(color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Signup();
                    }));
                  },
                  child: const Text("Register now",
                      style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}


//