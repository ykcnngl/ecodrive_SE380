import 'package:flutter/material.dart';

class myTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const myTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,        //hidepassword
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.orange),
          ),
          fillColor: (Colors.white70),
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}


//
