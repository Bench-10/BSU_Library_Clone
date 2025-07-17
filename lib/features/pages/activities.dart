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
    return Container(
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

          Container(
            height: 30,
            
            child: Row(
              children: [
                Icon(Icons.timeline, size: 30, color: Colors.red),

                Text(
                  'My Activities',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )

              ],
            ),
          ),

          SizedBox(height: 25),

          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),   
                      ),
                      backgroundColor: Colors.white, 
                      foregroundColor: Colors.black,  
                    ),
                    onPressed: () => {
                      setState(() {
                        
                        
                      })
                    },
                    child: Text(
                      'Borrowed Books',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )
                      ,
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),   
                      ),
                      backgroundColor: Colors.white, 
                      foregroundColor: Colors.black,  
                    ),
                    onPressed: () => {
                      setState(() {
                        
                        
                      })
                    },
                    child: Text(
                      'Notifications / Reminders',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )
                      ,
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),   
                      ),
                      backgroundColor: Colors.white, 
                      foregroundColor: Colors.black,  
                    ),
                    onPressed: () => {
                      setState(() {
                        
                        
                      })
                    },
                    child: Text(
                      'Borrowing History',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),   
                      ),
                      backgroundColor: Colors.white, 
                      foregroundColor: Colors.black,  
                    ),
                    onPressed: () => {
                      setState(() {
                        
                        
                      })
                    },
                    child: Text(
                      'Reservation History',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      )
                      ,
                    ),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: 20,),

          Container(
            margin: EdgeInsets.fromLTRB(10,10,10,10),
            child: Text('try tom'),
          )




        ],
      ),
    );
  }
}
