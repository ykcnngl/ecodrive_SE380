import 'package:ecodrive/main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class map_traking extends StatefulWidget {
  const map_traking({super.key});

  @override
  State<map_traking> createState() => _MapTrackingState();

}


class _MapTrackingState extends State<map_traking> {
  late GoogleMapController mapController;
  Location location = Location();
  late LatLng _currentLocation;

  void initState() {
    super.initState();
    _currentLocation = const LatLng(30.854, -84.652);
    _getCurrentLocation();
  }

  LocationData  currentLocationData= await location.getLocation();

    setState(() {
      _currentLocation = LatLng(currentLocationData.latitude!, currentLocationData.longitude!);
      );

    mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

