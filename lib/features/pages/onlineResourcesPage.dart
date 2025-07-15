import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class OnlineResourcesPage extends StatefulWidget{
  const OnlineResourcesPage({super.key});


  @override
  State<OnlineResourcesPage> createState() => _MyAppState();
}

class _MyAppState extends State<OnlineResourcesPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud, size: 80, color: Colors.purple),
          SizedBox(height: 20),
          Text(
            'Online Resources',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Access online library resources',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}




