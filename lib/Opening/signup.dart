import 'package:ecodrive/Opening/Welcomepage.dart';
import 'package:flutter/material.dart';

import 'Myloginbutton.dart';
import 'mytextfield.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

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
       /* Center(
          child: Column(
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
                //controller: EkoIdController,
                hintText: "EkoID",
                obscureText: false,
              ),
              //pasword
              const SizedBox(height: 10),
              myTextfield(
                //controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),

              //Login
              const SizedBox(height: 25),
              Myloginbutton(onTap: LoginUser),

              //Sign up
              const SizedBox(height: 205),

            ],
          ),
        ),*/
      ]),
    );
  }
}
