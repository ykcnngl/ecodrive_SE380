import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ECODRIVE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'ECODRIVE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const LatLng sourceLocation = LatLng(78.3954953, 48.0703596);

  LocationData? currentlocation;

  void getCurrentLocation() async {
    Location location = Location();
    try {
      currentlocation = await location.getLocation();
      setState(() {});
    } catch (e){
      print("Location can not get");
    }
      }

  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.title),
        leading: Icon(Icons.menu),
        actions: [IconButton(icon: Icon(Icons.person), onPressed: () {})],
      ),
      body: currentlocation == null
          ? const Center(child: Text("Loading"))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentlocation!.latitude!, currentlocation!.longitude!),
              zoom: 14,
              ),
              markers: {
                  Marker(
                    markerId: MarkerId("Current"),
                    position: LatLng(currentlocation!.latitude!, currentlocation!.longitude!),
                  ),
                }),

      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange, // Arka plan rengi
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_car),
              label: " ",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: " ",
            )
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
