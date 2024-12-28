import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/Appointment.dart';


import 'package:flutter/cupertino.dart';
import 'package:ecodrive/globals.dart' as globals;
import 'package:flutter/material.dart';

import 'messagesScreen.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {
  String name = " ";
  String ekoid = globals.currentEkoId;
  String password = " ";



  @override
  void initState() {
    super.initState();
    _profileInfo();
  }
  void _profileInfo() {


    FirebaseFirestore.instance
        .collection('users')
        .doc(ekoid)
        .snapshots()
        .listen((snapshot) {

      if (snapshot.exists) {
        setState(() {
          final data = snapshot.data();
          name =( data?['name']) + " " + (data?['surname'] ?? "");
          ekoid = data?['ekoid'] ?? "";
          password = data?['password'] ?? "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("PROFILE"),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 70,
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 20),
            itemProfile('Name:', name, CupertinoIcons.person),
            const SizedBox(height: 20),
            itemProfile(
                'EcoID:', ekoid, CupertinoIcons.creditcard),
            const SizedBox(height: 20),
            itemProfile(
                'Password:', password, CupertinoIcons.phone),
            const SizedBox(height: 20),
          ],
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Appointment",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          )
        ],
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Appointment(),
              ),
            );
          }
          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MessagesScreen(currentEkoId: ekoid,),
              ),
            );
          }
        },
      ),
    );
  }

  Widget itemProfile(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}