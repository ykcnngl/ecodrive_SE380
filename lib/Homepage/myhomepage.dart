import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/Appointment.dart';
import 'package:ecodrive/Opening/Welcomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../view/direction_screen.dart';
import 'help.dart';
import 'Messages.dart';
import 'profile.dart';
import 'driverlicence.dart';
import 'package:ecodrive/globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownValue = 'One';
  var username;

  void initState() {
    super.initState();
    fetchUserData(); // Firestore verisini çekmek için çağırılır
  }

  void fetchUserData() async {
    String ekoid = globals.currentEkoId;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(ekoid).get();
    setState(() {
      username = userDoc['name'] ?? "User"; // Eğer "name" alanı varsa göster
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("ECODRIVE"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.person),
              underline: const SizedBox(),
              // Alt çizgiyi kaldırır
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
                if (newValue == 'Two') {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                } else if (newValue == 'Three') {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Welcomepage()));
                }
              },
              items: const [
                DropdownMenuItem<String>(
                  value: 'One',
                  child: Text(''),
                ),
                DropdownMenuItem<String>(
                  value: 'Two',
                  child: Text(
                    'PROFILE',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'Three',
                  child: Text(
                    'LOG OUT',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        //Köşelerden 24 birim boşluk bırakmak için
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Hoşgeldin, $username !",
              style: TextStyle(
                fontSize: 40,
                fontStyle: FontStyle.italic,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 150),
                  backgroundColor: Colors.lightGreen),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const DirectionScreen();
                    },
                  ),
                );
              },
              child: const Text(
                "Direction Screen",
                style: TextStyle(fontSize: 24, color: Colors.brown),
              ),
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(children: [
          const SizedBox(height: 40),
          ListTile(
              title: const Text("BECOME A DRIVER"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const Driverlicence();
                }));
              }),
          ListTile(
              title: const Text("HELP & CONTACT"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const Help();
                }));
              }),
          ListTile(title: const Text("LOG OUT"), onTap: () {})
        ]),
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
            label: " Messages ",
          )
        ],
        onTap: (i) {
          if (i == 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const Appointment();
                },
              ),
            );
          }

          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Messages();
                },
              ),
            );
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
