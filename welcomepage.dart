import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class Welcomepage extends StatelessWidget {
  const Welcomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[50],
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 300),
                  const Text("   ECODRIVE",
                      style: TextStyle(
                          fontSize: 60,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange)),
                  Row(children: [
                    SizedBox(height: 380),
                    const SizedBox(width: 30),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return  Login();
                          }));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 32.0,horizontal: 32.0),
                          side: const BorderSide(color: Colors.deepOrange,width: 1.5),
                        ),
                        child: const Text("Login",style: TextStyle(fontSize: 22),)),


                    const SizedBox(width: 70),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return  Signup();
                          }));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 32.0,horizontal: 32.0),
                          side: const BorderSide(color: Colors.deepOrange,width: 1.5),
                        ),
                        child: const Text("Sign Up",
                            style: TextStyle(fontSize: 22))),
                  ]),
                ])));
  }
}

//