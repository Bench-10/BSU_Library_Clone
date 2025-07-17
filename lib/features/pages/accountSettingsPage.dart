import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AccountSettingsPage extends StatefulWidget{
  const AccountSettingsPage({super.key});


  @override
  State<AccountSettingsPage> createState() => _MyAppState();
}


class _MyAppState extends State<AccountSettingsPage> {
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

          SizedBox(
            height: 30,
            
            child: Row(
              children: [
                Icon(Icons.settings, size: 30, color: Colors.red),

                Text(
                  'Account Settings',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )

              ],
            ),
          ),

          SizedBox(height: 45),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),

                      SizedBox(width: 20,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DELA LUNA, BENCH CHRISTIAN A.',
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),

                            SizedBox(height: 10,),

                            Row(
                              children: [
                                Text(
                                  'Sr-code:',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),

                                SizedBox(width: 10,),

                                Text(
                                  '22-04617',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )



                    ],
                  ),

                  SizedBox(height: 70,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Full Name',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),

                      Text(
                        'Bench Christian A. Dela Luna',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                        ),
                      ),

                     
                      
                    ],
                  ),

                  SizedBox(height: 30,),

                  Divider(
                    color: Colors.black,  
                    thickness: 1, 
                  ),

                  SizedBox(height: 30,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Email Address',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),

                      Text(
                        '22-04617@g.batstate-u.edu.ph',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                        ),
                      ),

              
                      
                    ],
                  ),

                  SizedBox(height: 30,),

                  Divider(
                    color: Colors.black,  
                    thickness: 1, 
                  ),

                  SizedBox(height: 30,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contact Info',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                        ),
                      ),

                      Text(
                        '0935426375564',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 13
                        ),
                      ),

              
                      
                    ],
                  ),

                  SizedBox(height: 30,),



                  //NEXT



                ],
            )
          )

        ],
      ),

    );
  }
}


