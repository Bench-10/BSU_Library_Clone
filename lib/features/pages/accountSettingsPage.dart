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
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 247, 250, 252),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
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
                SizedBox(height: 7),
                Row(
                  children: [
                    Icon(Icons.settings, size: 30, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Account Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ],
                ),
                SizedBox(height: 45),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ]
                  ),
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
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
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
              SizedBox(height: 7),
              Row(
                children: [
                  Icon(Icons.settings, size: 30, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Account Settings',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    )
                  )
                ],
              ),
              SizedBox(height: 25),
             
              // Responsive layout
              LayoutBuilder(
                builder: (context, constraints) {
                  // Mobile layout (width < 600px)
                  if (constraints.maxWidth < 600) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          // Profile header
                          Column(
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
                              SizedBox(height: 20),
                              Text(
                                currentUser!['full_name']?.toString().toUpperCase() ?? 'USER NAME',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'SR-Code: ${currentUser!['sr_code']?.toString() ?? 'N/A'}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                         
                          // User details
                          _buildDetailRow('Full Name', currentUser!['full_name']?.toString() ?? 'Not specified'),
                          _buildDetailRow('Email Address', currentUser!['email']?.toString() ?? 'Not specified'),
                          _buildDetailRow('Contact Info', currentUser!['contact_info']?.toString() ?? 'Not specified'),
                          _buildDetailRow('SR Code', currentUser!['sr_code']?.toString() ?? 'Not specified'),
                        ],
                      ),
                    );
                  } else {
                    // Desktop layout (width >= 600px)
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          // Profile header
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
                              SizedBox(width: 20),
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
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          'SR-Code:',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        SizedBox(width: 10),
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
                          SizedBox(height: 30),
                         
                          // User details
                          _buildDetailRow('Full Name', currentUser!['full_name']?.toString() ?? 'Not specified'),
                          _buildDetailRow('Email Address', currentUser!['email']?.toString() ?? 'Not specified'),
                          _buildDetailRow('Contact Info', currentUser!['contact_info']?.toString() ?? 'Not specified'),
                          _buildDetailRow('SR Code', currentUser!['sr_code']?.toString() ?? 'Not specified'),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 13
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.black,  
            thickness: 1,
          ),
        ],
      ),
    );
  }
}







