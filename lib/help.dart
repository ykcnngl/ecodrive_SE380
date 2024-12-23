import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELP & CONTACT"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildExpansionTile(question: "What is Ecodrive ?", answer: "Our aim is to create a platform accessible exclusively to our university's students, "
              "providing a car-sharing service. Through this initiative, we hope to ensure: Safe, Efficient, and Cost-effective transportation options. Additionally, the app offers a wonderful opportunity to foster new friendships.   ",backgroundColor: Colors.blue[50]),
          _buildExpansionTile(question: " How can I contact to you ?", answer: " You can call : +90 534 495 93 43 or     mail us through the ecodrive@gmail.com",backgroundColor: Colors.green[50]),
          _buildExpansionTile(question: " How can I delete my account ?", answer: " We're sorry to hear that you want to delete your Ecodrive account.To delete your account, click the 'list icon' on the upper left corner of the app. Then click the 'Delete My Account' button which is at the bottom of the app to delete your account from the system.  ",backgroundColor: Colors.red[50])
        ],
      )
    );
  }

  Widget _buildExpansionTile({
    required String question,
    required String answer,
    Color? backgroundColor,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
          title: Text(
            question,
            style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold),
          ),
        childrenPadding: const EdgeInsets.all(16),
        backgroundColor: backgroundColor,
        children: [
          Text(answer,style: const TextStyle(fontSize: 20,color: Colors.black),)
        ],
      ),
    );
  }

}