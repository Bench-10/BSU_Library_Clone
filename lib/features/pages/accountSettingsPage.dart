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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 80, color: Colors.red),
          SizedBox(height: 20),
          Text(
            'Account Settings',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Manage your account preferences',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}


