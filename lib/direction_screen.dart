import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ecodrive/globals.dart' as globals;
import '../globals.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({super.key, required this.isDriver});

  final bool isDriver;    // isDriverı myhomepage kısmında tanımlayıp burda kullanıyoruz

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};
  late GoogleMapController mapController;
  late bool isDriver; // ana ekranda seçtik o yüzden burası late artık ekran içinde dğişim olursa kullanılacak

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(38.397471597337535, 27.070379359995695),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {       // bunu ana ekrana koymaya çalışıcaz
    //   _driverQuestion();
    // });

    isDriver = widget.isDriver; // ANA EKRANDA SESÇİLENİ BURADA BAŞLATMAK İÇİN KULLANDIK
    _addSampleMarkers(); //Add sample marker
    _listenToFirestoreLocations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _driverMarkerColorChanging(isDriver:isDriver);          // buraya aldık çünkü haritaya girince marker rengi hemen güncellemeli
    });
  }

  // Future<void> _driverQuestion() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     Eğer kullanıcı seçim yapmazsa ilerleyemeyecek
  //
  // builder: (context) => AlertDialog(
  //   title: const Text('Are you a driver?'),
  //   content: const Text('Please select your role.'),
  //   actions: [
  //     TextButton(
  //       onPressed: () async {
  //         Navigator.pop(context);
  //         try {
  //           await _driverMarkerColorChanging(
  //               isDriver:
  //                   true); //BURDA ASENKRON YAPINCA SORUN OLUYOR UYGULAMA BAZEN HATA VERİYOR    DÜZELDİ
  //         } catch (e) {
  //           print('Error in setting driver marker: $e');
  //         }
  //       },
  //       child: const Text('Yes'),
  //     ),
  //     TextButton(
  //       onPressed: () {
  //         Navigator.pop(
  //             context); // Hiçbir değişiklik yapmadık böylece kırmızı olarak kalacak marker
  //       },
  //       child: const Text('No'),
  //     ),
  //   ],
  // ),
  // );
  // }

  Future<void> _driverMarkerColorChanging({bool isDriver = true}) async {
    try {
      Position position = await currentPosition();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      await _saveLocationToFireStore(currentLocation);

      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentLocation,
            icon: isDriver
                ? BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow)
                : BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: isDriver ? 'Driver' : 'Passenger',
              snippet: 'This location is your current location.',
            ),
          ),
        );
      });

      await _goToLocation(currentLocation); // Haritada kamera kullanıcının konumuna gider ve gösterir.
    } catch (e) {
      print('Driver marker update failed: $e');
    }
  }

  void _updateMarkerColor() async{
    Position position = await currentPosition();
    LatLng currentLocation = LatLng(position.latitude, position.longitude);

    Marker updatedMarker = Marker(
      markerId: const MarkerId('currentLocation'),
      position: currentLocation,
      icon: isDriver
          ? BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow)
          : BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: isDriver ? 'Driver' : 'Passenger',
        snippet: 'This location is your current location.',
      ),
    );

    setState(() {
      markers.removeWhere((marker) => marker.markerId.value == 'currentLocation' ); //Eski marker silindi bu sayaede markerlar üst üste oluşmayacak
      markers.add(updatedMarker);      // yenisi eklenecek
    });
    await _goToLocation(currentLocation);   // konumu gösterecek sonra
  }



  void _addSampleMarkers() {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('school'),
          position: const LatLng(38.38791939521493, 27.0446597217389),
          infoWindow: InfoWindow(
            title: 'İzmir Ekonomi Üniversitesi',
            snippet: 'Do you want to go to here?',
            onTap: () {
              _showDirectionDialog('İzmir Ekonomi Üniversitesi');
            },
          ),
        ),
      );
    });
  }

  // Future<void> _getCurrentLocation() async {
  //   Position position = await currentPosition();
  //   LatLng currentLocation = LatLng(position.latitude, position.longitude);
  //
  //   await _saveLocationToFireStore(currentLocation);
  //
  //   setState(() {
  //     markers.add(
  //       Marker(
  //         markerId: const MarkerId('currentLocation'),
  //         position: currentLocation,
  //         infoWindow: InfoWindow(
  //           title: currentEkoId,
  //           snippet: 'Click for options.',
  //           onTap: () {
  //             _showInfoDialog('Current Location');
  //           },
  //         ),
  //       ),
  //     );
  //   });
  //   await _goToLocation(currentLocation);
  // }

  Future<void> _saveLocationToFireStore(LatLng location) async {
    try {
      String ekoid = globals.currentEkoId;
      if (ekoid.isEmpty) {
        print('Error: EkoId is empty.');
        return;
      }
      await FirebaseFirestore.instance.collection('users').doc(ekoid).update({
        'latitude': location.latitude,
        'longitude': location.longitude,
        //'location': ( location.latitude,location.longitude),
      });
      print("Location saved successfully!");
    } catch (e) {
      print('Error: Ekoid and location is not working.');
    }
  }

  void _listenToFirestoreLocations() {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        for (var doc in snapshot.docs) {
          final data = doc.data();
          if (data['latitude'] != null && data['longitude'] != null) {
            markers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(data['latitude'], data['longitude']),
                infoWindow: InfoWindow(
                  title: 'User',
                  snippet: 'User: ${doc.id}',
                  onTap: () {
                    _showInfoDialog('User: ${doc.id}');
                  },
                ),
              ),
            );
          }
        }
      });
    });
  }

  Future<void> _goToLocation(LatLng target) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16),
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
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Text('Choose an option for go to this location '),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print('Send message pressed');
            },
            child: const Text('Send Message'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              print('Get direction pressed');
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
      builder: (context) => AlertDialog(
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
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kInitialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
              },
              markers: markers,
              myLocationEnabled: true,
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "driverButton",  // ********************** heroTag added and fixed(multiple floating action button issue due hero)
                    onPressed: () {
                      setState(() {
                        isDriver = true;
                      });
                      _updateMarkerColor();
                    },
                    backgroundColor: isDriver ? Colors.yellow : Colors.grey,
                    child: const Icon(Icons.directions_car),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: "passengerButton",   // ********************** heroTag added and fixed(multiple floating action button issue due hero)
                    onPressed: () {
                      setState(() {
                        isDriver = false;
                      });
                      _updateMarkerColor();
                    },
                    backgroundColor: !isDriver ? Colors.red : Colors.grey,
                    child: const Icon(Icons.person),
                  ),
                ],
              ),
            ),
          ],
        ),

        floatingActionButton: Padding(
          padding:const EdgeInsets.only(left: 16, bottom: 16),       // kenarlardan boşluk koyduk ekrandan taşamasın diye
          child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: _driverMarkerColorChanging,
                backgroundColor: Colors.white,
                child: const Icon(Icons.my_location),
              )

          ),
        )


    );



    // floatingActionButton: Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     FloatingActionButton(
    //       onPressed: _getCurrentLocation,
    //       backgroundColor: Colors.white,
    //       child: const Icon(Icons.my_location),

  }
}
