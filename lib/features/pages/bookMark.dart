import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class BookMarksPage extends StatefulWidget{
  const BookMarksPage({super.key});

  @override
  State<BookMarksPage> createState() => _MyAppState();
}

class _MyAppState extends State<BookMarksPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark, size: 80, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Bookmarks',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Your saved bookmarks appear here',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}



