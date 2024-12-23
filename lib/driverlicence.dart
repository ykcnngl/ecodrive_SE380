import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecodrive/globals.dart' as globals;

import 'package:flutter/material.dart';

class Driverlicence extends StatefulWidget {
  const Driverlicence({super.key});

  @override
  State<Driverlicence> createState() => _DriverlicenceState();
}

class _DriverlicenceState extends State<Driverlicence> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 50),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Center(
            child: Column(
          children: [
            const SizedBox(height: 200),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                onPressed: () {
                  _pickImageFromGallery();
                },
                child: const Text("Choose image from gallery",
                    style: TextStyle(color: Colors.black))),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent),
                onPressed: () {
                  _pickImageFromCamera();
                },
                child: const Text("Take a photo with camera",
                    style: TextStyle(color: Colors.black))),
            const SizedBox(
              height: 20,
            ),
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : Text("Please select an image"),
            const SizedBox(
              height: 200,
            ),
            if (_selectedImage != null)
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done),
                color: Colors.green,
              ),
          ],
        ))
      ]),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
