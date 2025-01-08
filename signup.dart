import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/myhomepage.dart';
import 'package:ecodrive/Opening/myloginbutton.dart';
import 'package:flutter/material.dart';
import 'mytextfield.dart';
import 'package:ecodrive/globals.dart' as globals;

class Signup extends StatelessWidget {
  final EkoIdController = TextEditingController();            // controllers for the text fielders
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();
  final birthdayController = TextEditingController();


  Signup({super.key});

  void SignupUser(BuildContext context) async {
    final ekoid = EkoIdController.text.trim();              // Delete the spaces between the words
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final password = passwordController.text.trim();
    final birthday = birthdayController.text.trim();


    if (ekoid.isEmpty ||
        password.isEmpty ||                    // Checking empty or not
        birthday.isEmpty ||
        name.isEmpty ||
        surname.isEmpty ) {
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
    final DateTime birthDate = DateTime.parse(birthday);          // String to date time
    final DateTime today = DateTime.now();                        // Current Time
    final int age = today.year -                                  //  Calculate age
        birthDate.year -
        ((today.month < birthDate.month ||
            (today.month == birthDate.month && today.day < birthDate.day))
            ? 1
            : 0);
    if (age < 18) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("ERROR"),
          content: const Text("You must be at least 18 years old "),
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

    try {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(ekoid).get();
      if (userDoc.exists) {
        if (userDoc['name'] == name &&
            userDoc['surname'] == surname &&
            userDoc['birthday'] == birthday) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(ekoid)
              .update({
            'password': password,

          });

          globals.currentEkoId = ekoid;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("ERROR"),
              content: const Text(
                  "Please fill in your information in the same way as on your school card. "),
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
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[50],
      ),
      body: Stack(children: [
        SingleChildScrollView(
          // we added scroll due to same issue from login page
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Text("Welcome to ECODRIVE ",
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
                //name
                const SizedBox(height: 10),
                myTextfield(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),
                //surname
                const SizedBox(height: 10),
                myTextfield(
                  controller: surnameController,
                  hintText: "Surname",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                //pasword
                myTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2006),
                      firstDate: DateTime(1960),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      birthdayController.text =
                      "${selectedDate.toLocal()}".split(' ')[0];
                    }
                  },
                  child: AbsorbPointer(
                      child: myTextfield(
                        controller: birthdayController,
                        hintText: "Birthday",
                        obscureText: false,
                      )),
                ),
                //Login
                const SizedBox(height: 25),
                Myloginbutton(
                  onTap: () {
                    print("button tapped");
                    SignupUser(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
