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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Maintenance Icon
            Icon(
              Icons.construction,
              size: 100,
              color: Colors.amber.shade700,
            ),
            const SizedBox(height: 30),
            // Headline
            Text(
              'Page Under Maintenance',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Message
            Text(
              'We are currently working on this feature. Please check back later or contact the library for assistance.',
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}




