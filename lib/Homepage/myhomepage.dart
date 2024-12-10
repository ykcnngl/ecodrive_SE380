import 'package:ecodrive/Homepage/Appointment.dart';
import 'package:flutter/material.dart';
import '../view/direction_screen.dart';
import 'help.dart';
import 'Messages.dart';
import 'personalinfo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("ECODRIVE"),
          actions: [
            IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  /*Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const personalinfo();
                      },
                    ),
                  ); */
                })
          ]),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        //Köşelerden 24 birim boşluk bırakmak için
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: Text("Direction Screen"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const DirectionScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(children: [
          ListTile(title: const Text("SETTINGS"), onTap: () {}),
          ListTile(title: const Text("BECOME A DRIVER"), onTap: () {}),
          ListTile(
              title: const Text("HELP & CONTACT"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const Help();
                }));
              }),
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
                  return const Messages();
                },
              ),
            );
          }
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
