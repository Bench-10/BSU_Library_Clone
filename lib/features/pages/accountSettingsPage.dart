import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';


class AccountSettingsPage extends StatefulWidget{
  const AccountSettingsPage({super.key});


  @override
  State<AccountSettingsPage> createState() => _MyAppState();
}


class _MyAppState extends State<AccountSettingsPage> {
  Map<String, dynamic>? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = AuthService.currentUserData;
  }
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    if (!AuthService.isLoggedIn() || currentUser == null) {
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please login to view account settings',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

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

          Expanded(
            child: Container(
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
                          backgroundColor: Colors.red.shade100,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(width: 20,),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser!['full_name']?.toString().toUpperCase() ?? 'USER NAME',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),

                              SizedBox(height: 10,),

                              Row(
                                children: [
                                  Text(
                                    'SR-Code:',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),

                                  SizedBox(width: 10,),

                                  Text(
                                    currentUser!['sr_code']?.toString() ?? 'N/A',
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

                        Expanded(
                          child: Text(
                            currentUser!['full_name']?.toString() ?? 'Not specified',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 13
                            ),
                            textAlign: TextAlign.right,
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

                        Expanded(
                          child: Text(
                            currentUser!['email']?.toString() ?? 'Not specified',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 13
                            ),
                            textAlign: TextAlign.right,
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

                        Expanded(
                          child: Text(
                            currentUser!['contact_info']?.toString() ?? 'Not specified',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 13
                            ),
                            textAlign: TextAlign.right,
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
                          'SR Code',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                          ),
                        ),

                        Text(
                          currentUser!['sr_code']?.toString() ?? 'Not specified',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 13
                          ),
                        ),
                        
                      ],
                    ),

                    SizedBox(height: 30,),

                  ],
              )
            ),
          ),

        ],
      ),

    );
  }
}


