import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  Messages({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Messages"),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 700),
        ElevatedButton(
          onPressed: () {
            /*Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              //return ();
            }));*/
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: Text(
            "Create a New Message",
            style: TextStyle(fontSize: 20),
          ),
        )
      ]),
    );
  }
}
