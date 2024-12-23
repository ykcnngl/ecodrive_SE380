import 'package:ecodrive/firebase_options.dart';
import 'package:flutter/material.dart';
import 'Homepage/myhomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Opening/Welcomepage.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ECODRIVE',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange)),
      home:  const Welcomepage(),
    );
  }
}