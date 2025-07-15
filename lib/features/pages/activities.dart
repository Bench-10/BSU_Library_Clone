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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timeline, size: 80, color: Colors.green),
          SizedBox(height: 20),
          Text(
            'My Activity',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'View your recent activities here',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
