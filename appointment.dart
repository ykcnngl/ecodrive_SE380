import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appointment extends StatelessWidget {
  const Appointment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Appointments"),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('appointments').doc("driverEkoId").snapshots(),
          builder: (context,snapshot) {
        if(!snapshot.hasData){
          return const Center(
          child: CircularProgressIndicator()
          );
    }
        final appointmentData = snapshot.data!.data() as Map<String, dynamic>;
        final passengers = appointmentData['passengers'] as List<dynamic>;

        return ListView.builder(
    itemCount: passengers.length,
          itemBuilder: (context, index) {
            final passengerId = passengers[index];
            return ListTile(
    title: Text("Passenger $passengerId"),
    );
    }

    );


    },
    ));
  }
}

//