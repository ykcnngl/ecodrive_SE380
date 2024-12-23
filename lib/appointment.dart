import 'package:flutter/material.dart';

class Appointment extends StatelessWidget {
  const Appointment({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Appointments"),

      ),
    );
  }
}