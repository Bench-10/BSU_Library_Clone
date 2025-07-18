import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/mainApp.dart';
import '../../services/auth_service.dart';
import 'adminLogin.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 61, 62, 170)),
      ),
      home: const MyHomePage(title: 'BatStateU'),
    );  
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  // Helper method to clear all form fields
  void _clearForm() {
    _formKey.currentState?.reset();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      appBar: AppBar(
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
                          widget.title,
                          style: GoogleFonts.merriweather(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Library',
                          style: TextStyle(
                            color: Colors.white
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
              Text('LOGIN', 
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, 
                color: Colors.black,
                fontSize: 33
                )
              ),

              SizedBox(height: 25),

              Text('* Please login your credentials',
               style: GoogleFonts.poppins(
                fontStyle: FontStyle.italic,
                fontSize: 10
               ),
              ),

              SizedBox(height: 25),

              // Login Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter Email',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.black, 
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
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

                      Map<String, dynamic> result = await AuthService.loginUser(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      if (result['success']) {
                        // Clear form after successful login
                        _clearForm();

                        // Show login success dialog and navigate
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(
                                'Success!',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              content: Text(
                                'Login successful! Welcome back.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => mainApp(),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = Offset(1.0, 0.0); 
                                          const end = Offset.zero;
                                          const curve = Curves.ease;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                        transitionDuration: Duration(milliseconds: 500), 
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 230, 12, 12),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Show error dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(
                                'Login Failed',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              content: Text(
                                result['message'] ?? 'Unknown error occurred',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
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
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Logging in...'),
                        ],
                      )
                    : Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),

              SizedBox(height: 20),

              // Admin Login Link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLogin()),
                  );
                },
                child: Text(
                  'Admin Login',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    decoration: TextDecoration.underline,
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
