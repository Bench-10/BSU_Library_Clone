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
      child: Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Library System',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )
          ),

          SizedBox(height: 7,),

          SizedBox(
            height: 30,
            
            child: Row(
              children: [
                Icon(Icons.book, size: 30, color: Colors.red),

                Text(
                  'Bookmarks',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )

              ],
            ),
          ),

          SizedBox(height: 25),

        ]
      )
     )
      
    );
    
  }
}



