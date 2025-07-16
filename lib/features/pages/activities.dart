import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});
  

  @override
  State<MyActivityPage> createState() => _MyAppState();
}


class _MyAppState extends State<MyActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Activities Page'),
    );
  }
}
