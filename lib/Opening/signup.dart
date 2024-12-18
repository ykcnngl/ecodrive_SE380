import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/myhomepage.dart';
import 'package:ecodrive/Opening/myloginbutton.dart';
import 'package:flutter/material.dart';
import 'mytextfield.dart';
import 'package:ecodrive/globals.dart' as globals;

class Signup extends StatelessWidget {
  final EkoIdController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final passwordController = TextEditingController();
  final birthdayController = TextEditingController();

  Signup({super.key});

  void SignupUser(BuildContext context) async {
    final ekoid = EkoIdController.text.trim();
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final password = passwordController.text.trim();
    final birthday = birthdayController.text.trim();

    if (ekoid.isEmpty || password.isEmpty || birthday.isEmpty || name.isEmpty || surname.isEmpty ) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
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
    final DateTime birthDate = DateTime.parse(birthday);
    final DateTime today = DateTime.now();
    final int age = today.year-birthDate.year-((today.month < birthDate.month|| (today.month == birthDate.month && today.day<birthDate.day))? 1:0);
    if(age<18){
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
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
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(ekoid)
          .get();
      if (userDoc.exists ){
        if(userDoc['name'] == name && userDoc['surname'] == surname && userDoc['birthday']==birthday) {
          await FirebaseFirestore.instance.collection('users').doc(ekoid).update({'password':password,
          });

          globals.currentEkoId = ekoid;

          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: const Text("ERROR"),
                  content: const Text("Please fill in your information in the same way as on your school card. "),
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
        builder: (context) =>
            AlertDialog(
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
        Center(
          child: Column(
            children: [
              const SizedBox(height: 200),
              Text("Welcome  ",
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

              //pasword
              const SizedBox(height: 10),
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
                  SignupUser(context);
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}