import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkersScreen extends StatefulWidget {
  const MarkersScreen({super.key});

  @override
  State<MarkersScreen> createState() => _MarkersScreenState();
}

class _MarkersScreenState extends State<MarkersScreen> {
  final CameraPosition _kIue = const CameraPosition(
      target: LatLng(38.42036493983698, 27.148381599981537), //İZMİR's LOCATION
      zoom: 14);

  static const _iue = LatLng(38.38802783193236, 27.044565077684922);

  final Marker iueMarker = const Marker(
      markerId: MarkerId("Iue"),
      position: _iue,
      infoWindow: InfoWindow(title: "İzmir Ekonomi Üniversitesi"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Markers Sample")),
      body: GoogleMap(initialCameraPosition: _kIue,
      markers: {iueMarker},  // set olduğu için parametresi set ekledik.
      ),
    );
  }
}

// people can see other people's location.
