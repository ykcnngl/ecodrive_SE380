import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kDefaultLocation = CameraPosition(
    target: LatLng(38.38793312431735, 27.044607696153015),
    zoom: 14.4746,
  );

  static const CameraPosition _kIUE = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(38.38793312431735, 27.044607696153015),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kDefaultLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheSchool,
        label: const Text('To The IEU!'),
        icon: const Icon(Icons.school),
      ),
    );
  }

  Future<void> _goToTheSchool() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kIUE));
  }
}