import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key});

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {

  final Completer<GoogleMapController>_controller = Completer();
  Set<Marker> markers = {};
  late GoogleMapController mapController;

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(38.397471597337535, 27.070379359995695),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _addSampleMarkers(); //Add sample marker

  }

  void _addSampleMarkers() {
    markers.add(
      Marker(
        markerId: const MarkerId('school'),
        position: const LatLng(38.38791939521493, 27.0446597217389),
        infoWindow: InfoWindow(
          title: 'İzmir Ekonomi Üniiversitesi',
          snippet: 'Do you want to go to here?',
          onTap: () {
            _showDirectionDialog('İzmir Ekonomi Üniiversitesi');
          },
        ),
      ),

    );
    setState(() {

    });
  }


  Future<void> _getCurrentLocation() async {
    Position position = await currentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);


    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLocation,
          infoWindow: InfoWindow(
            title: 'My Current Location',
            snippet: 'Click for options.',
            onTap: () {
              _showInfoDialog('Current Location');
            },
          ),
        ),
      );
    });
    await _goToLocation(currentLocation);
  }

  Future<void> _goToLocation(LatLng target) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target,
            zoom: 16),
      ),
    );
  }

  // Function to determine the user's current position
  Future<Position> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Checking if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Checking the location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Requesting permission if it is denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    // Handling the case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Getting the current position of the user
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }


  void _showInfoDialog(String title) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title),
            content: const Text('Choose an option for go to this location '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Send Message'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Get Direction'),
              ),
            ],
          ),
    );
  }

  void _showDirectionDialog(String s) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('İzmir Ekonomi Üniversitesi'),
            content: const Text('Choose an option for go to this location '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Get Direction'),
              ),
            ],
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go to school together'),
        backgroundColor: Colors.orange,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kInitialPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
        },
        markers: markers,
        myLocationEnabled: true,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _getCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}