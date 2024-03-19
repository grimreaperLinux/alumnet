import 'package:alumnet/home.dart';
import 'package:alumnet/screens/home/create_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Alumnet',
        debugShowCheckedModeBanner: false,
        home: AlumnetHome(),
        routes: {PostCreationScreen.routename: (context) => PostCreationScreen()},
      ),
    );
  }
}
