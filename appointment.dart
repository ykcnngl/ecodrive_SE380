import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Appointment extends StatefulWidget {
  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  List<Map<String, dynamic>> waypoints = [];      //list to store waypoints (users)
  Position? _currentPosition;                     // store current position

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchAppointments();
  }

  // Gets the user's current location
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are not enabled.';
      }
          // Check request and permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission is denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permission is permanently denied.';
      }
      // Get the current position of the user
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // Fetches all appointments (drivers and passengers) from Firestore
  Future<void> _fetchAppointments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .get();

      List<Map<String, dynamic>> fetchedWaypoints = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();

        // Sürücüyü durak olarak ekle
        if (data['latitude'] != null && data['longitude'] != null) {
          fetchedWaypoints.add({
            'name': data['ekoId'],
            'latitude': data['latitude'],
            'longitude': data['longitude'],
            'docId': doc.id, // delete for appointment
          });
        }

        // Add passengers as stations
        if (data['passengers'] != null) {
          for (var passengerId in List<String>.from(data['passengers'])) {
            var passengerDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(passengerId)
                .get();

            if (passengerDoc.exists) {
              fetchedWaypoints.add({
                'name': passengerDoc['name'] ?? 'Unknown',
                'latitude': passengerDoc['latitude'],
                'longitude': passengerDoc['longitude'],
              });
            }
          }
        }
      }
      // Update the waypoints list in the state
      setState(() {
        waypoints = fetchedWaypoints;
      });
    } catch (e) {
      print("Error fetching waypoints: $e");
    }
  }

  // add new passenger
  Future<void> _addPassengerToAppointment(String passengerId, String appointmentId) async {
    try {
      // Check if the passenger is already in another appointment
      final querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('passengers', arrayContains: passengerId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the passenger is in another appointment, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passenger is already assigned to another appointment.")),
        );
        return;
      }

      // Add the passenger to the current appointment
      final appointmentRef = FirebaseFirestore.instance.collection('appointments').doc(appointmentId);
      await appointmentRef.update({
        'passengers': FieldValue.arrayUnion([passengerId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passenger added successfully.")),
      );
    } catch (e) {
      print("Error adding passenger: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add passenger.")),
      );
    }
  }

  // Delete all appointments
  Future<void> _removeAllAppointments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        waypoints.clear(); // clear list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All appointments removed successfully.")),
      );
    } catch (e) {
      print("Error removing appointments: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove appointments.")),
      );
    }
  }

  // Creates a route on Google Maps
  Future<void> _createRoute() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Current location not found. Please try again.")));
      return;
    }

    if (waypoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No waypoints available.")));
      return;
    }

    //  Sort waypoints by distance from the current position
    waypoints.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        a['latitude'],
        a['longitude'],
      );
      double distanceB = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        b['latitude'],
        b['longitude'],
      );
      return distanceA.compareTo(distanceB);
    });

    //  Construct the Google Maps URL
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&travelmode=driving';

    googleMapsUrl +=
    '&origin=${_currentPosition!.latitude},${_currentPosition!.longitude}';

    // add waypoints to route
    String waypointsParam = waypoints
        .map((waypoint) => '${waypoint["latitude"]},${waypoint["longitude"]}')
        .join('|');

    googleMapsUrl += '&waypoints=$waypointsParam';

    // Add the last waypoint as the destination
    googleMapsUrl +=
    '&destination=${waypoints.last["latitude"]},${waypoints.last["longitude"]}';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: waypoints.isEmpty
                ? Center(child: Text('No appointments available.'))
                : ListView.builder(
              itemCount: waypoints.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(waypoints[index]["name"]),
                  subtitle: Text(
                    "Lat: ${waypoints[index]["latitude"]}, Lng: ${waypoints[index]["longitude"]}",
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _createRoute,
                child: Text("Create Route"),
              ),
              ElevatedButton(
                onPressed: _removeAllAppointments,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Remove All"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
