import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecodrive/Homepage/Appointment.dart';
import 'package:ecodrive/Homepage/direction_screen.dart';
import 'package:ecodrive/Opening/Welcomepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'help.dart';

import 'messagesScreen.dart';
import 'profile.dart';
import 'driverlicence.dart';
import 'package:ecodrive/globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double maxdistance = 4; //kmeter distance
  final String ekoid = globals.currentEkoId;
  List<Map<String, dynamic>> nearusers = [];
  var username;
  bool isDriver = false; // Check Driver or Passenger initial value is PASSENGER


  @override
  void initState() {
    super.initState();
    fetchUserData();
    _nearUsers(); // CALLED FOR FİRESTORE DATAS
  }

  void fetchUserData() async {
    String ekoid = globals.currentEkoId;
    final userDoc =
    await FirebaseFirestore.instance.collection('users').doc(ekoid).get();
    setState(() {
      username = userDoc['name'] ?? "User"; //  SHOW "name" FİELD
    });
  }

  void signout() {
    FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const Welcomepage();
      }));
    }
  }

  Future<void> _nearUsers() async {
    final userDocs = await FirebaseFirestore.instance.collection('users').get();
    Position position = await Geolocator.getCurrentPosition();
    LatLng currentUserLocation = LatLng(position.latitude, position.longitude);

    List<Map<String, dynamic>> users = [];

    for (var doc in userDocs.docs) {
      final data = doc.data();
      final userEkoid = data['ekoid'];
      if (data['latitude'] != null && data['longitude'] != null && userEkoid!= globals.currentEkoId) {   // CHECKING ME OR NOT
        double distancemet = Geolocator.distanceBetween(
          currentUserLocation.latitude,
          currentUserLocation.longitude,
          data['latitude'],
          data['longitude'],
        );
        double distancekm = distancemet/1000;   // Distance to km
        if (distancekm <= maxdistance) {
          users.add({
            'ekoid': userEkoid,
            'name': data['name'] ?? 'Unknown',
            'latitude': data['latitude'],
            'longtitude': data['longitude'],
            'distance': distancekm.toStringAsFixed(2),
          });
        }
      }
    }
    setState(() {
      nearusers = users;
    });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "WELCOME, $username !",
              style: const TextStyle(
                fontSize: 40,
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDriver ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isDriver = true;
                    });
                  },
                  child: const Text('Driver'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDriver ? Colors.grey : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isDriver = false;
                    });
                  },
                  child: const Text('Passenger'),
                ),
                const SizedBox(width: 20),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 150),
                  backgroundColor: Colors.lightBlueAccent),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return DirectionScreen(isDriver: isDriver);
                    },
                  ),
                );
              },
              child: const Text(
                "Direction Screen",
                style: TextStyle(fontSize: 24, color: Colors.brown),
              ),
            ),
            SizedBox(height: 20),
            const Text("Users Close To You"),
            SizedBox(height: 10),
            Expanded(                          // if near user is empty we can show a circle for loading
                child: nearusers.isEmpty      // if near users isn't empty we can list on myhomepage
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                    itemCount: nearusers.length,
                    itemBuilder: (context, index) {
                      final users = nearusers[index];
                      return  Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading:  Icon(Icons.person),
                          title: Text('${users['name']} (${users['ekoid']})'),
                          subtitle: Text(
                              'Distance: ${users['distance']} km'),
                        ),
                      );
                    }))
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
                  return Appointment();
                },
              ),
            );
          }

          if (i == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MessagesScreen(
                      currentEkoId : globals.currentEkoId
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
