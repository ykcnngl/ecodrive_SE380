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

  var username;

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
      username = userDoc['name'] ?? "User"; //  "name" alanını  göster
    });
  }

  void signout() {
    FirebaseAuth.instance.signOut();
    if(context.mounted){
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) {
          return const Welcomepage();
        }));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("ECODRIVE"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const Profile();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        //Köşelerden 24 birim boşluk bırakmak için
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "WELCOME, $username !",
              style: const TextStyle(
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
        child: ListView(
          children: [
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
            ListTile(
              title: const Text("LOG OUT"),
              onTap: signout,
            ),
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
      ),
    );
  }
}
//updated version
