import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../pages/adminMainApp.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: 90,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bsu-header.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(123, 6, 3, 3),
              ),
            ),
            Center(
              child: Container(
                height: 75,
                color: const Color.fromARGB(188, 185, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20,), 
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 10, 5, 10),
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/BatStateU-NEU-Logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BatStateU',
                          style: GoogleFonts.merriweather(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Library Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(2, 3),
              )
            ]
          ),
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 60,
                color: Colors.red,
              ),
              SizedBox(height: 20),
              Text(
                'ADMIN LOGIN',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 15),
              Text(
                '* Please login with admin credentials',
                style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 25),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Admin Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter admin email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Admin Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter admin password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });


                      Map<String, dynamic> result = await AuthService.adminLogin(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                  

                      setState(() {
                        _isLoading = false;
                      });

                      if (result['success']) {
                    
                        // Navigate to admin interface
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminMainApp(),
                          ),
                        );
                      } else {
                     
                        // Show enhanced error dialog with debug info
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text('Login Failed'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(result['message']),
                                  SizedBox(height: 10),
                                  Text(
                                    'Debug Info:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Email: ${_emailController.text.trim()}'),
                                  Text('Expected: admin@batstate-u.edu.ph'),
                                  Text('Password: ${_passwordController.text.trim()}'),
                                  Text('Expected: admin123'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Logging in...'),
                          ],
                        )
                      : Text(
                          'Login as Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to Student Login',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
