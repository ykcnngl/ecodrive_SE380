import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/Appointment.dart';
import 'package:ecodrive/Homepage/Messages.dart';
import 'package:ecodrive/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = " ";
  String surname = " ";
  String birthday = " ";
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
          name = data?['name'] ?? "";
          surname = data?['surname'] ?? "";
          birthday = data?['birthday'] ?? "";
          ekoid = data?['ekoid'] ?? "";
          password = data?['password'] ?? "";
        });
      }
    });
  }

  void showEditDialog(String field, String currentValue) {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'New $field',
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(ekoid)
                    .update({field.toLowerCase(): controller.text});
                setState(() {});
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
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
              child: Icon(Icons.person, size: 70),
            ),
            const SizedBox(height: 20),
            itemProfile('Name:', name, CupertinoIcons.person, 'name', showSettings: false),
            const SizedBox(height: 20),
            itemProfile('Surname:', surname, CupertinoIcons.person_solid, 'surname', showSettings: false),
            const SizedBox(height: 20),
            itemProfile('Birthday:', birthday, CupertinoIcons.calendar, 'birthday', showSettings: false),
            const SizedBox(height: 20),
            itemProfile('EcoID:', ekoid, CupertinoIcons.creditcard, 'ekoid', showSettings: false),
            const SizedBox(height: 20),
            itemProfile('Password:', password, CupertinoIcons.padlock_solid, 'password'),
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
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Appointment(),
              ),
            );
          } else if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Messages(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget itemProfile(
      String title,
      String value,
      IconData icon,
      String fieldKey, {
        bool showSettings = true,
      }) {
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
            Expanded(
              child: Column(
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
            ),
            if (showSettings)
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.grey),
                onPressed: () => showEditDialog(fieldKey, value),
              ),
          ],
        ),
      ),
    );
  }
}
