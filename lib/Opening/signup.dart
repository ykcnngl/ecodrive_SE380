import 'package:ecodrive/Opening/Welcomepage.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                Navigator.of(context).pop(MaterialPageRoute(builder: (context) {
                  return const Welcomepage();
                }));
              })
        ],
      ),
    );
  }
}

