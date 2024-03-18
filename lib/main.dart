import 'package:alumnet/home.dart';
import 'package:alumnet/screens/home/create_post_screen.dart';
import 'package:flutter/material.dart';

void main() {
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
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: AlumnetHome(),
        routes: {
          PostCreationScreen.routename: (context) => PostCreationScreen()
        },
      ),
    );
  }
}
