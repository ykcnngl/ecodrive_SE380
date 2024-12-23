import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecodrive/globals.dart' as globals;
import 'Appointment.dart';


class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Firestore verisini çekmek için çağırılır
  }
  void fetchUserData() async {
    String ekoid = globals.currentEkoId;
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(ekoid).get();
    setState(() {
      var username = userDoc['name'] + userDoc['surname']; //  "name" alanını  göster
    });
  }
  Widget itemProfile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
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
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
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
            itemProfile('Name & Surname:', "", CupertinoIcons.person),
            const SizedBox(height: 20),
            itemProfile('EcoID:', "", CupertinoIcons.creditcard),
            const SizedBox(height: 20),
            itemProfile('Birthday:', "", CupertinoIcons.phone),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}