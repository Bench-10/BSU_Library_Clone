import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/mainApp.dart';

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
                      mainAxisAlignment: MainAxisAlignment.center, // Add this line
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
        // Title is now inside the container above, so we can remove it from here
        // title: Text(...),
      ),
      body: Center(
          
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20), // 20 pixels on left and right
            padding: EdgeInsets.symmetric(horizontal: 35 , vertical: 30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // shadow color
                  spreadRadius: 2,  // how wide the shadow spreads
                  blurRadius: 5,    // how soft the shadow is
                  offset: Offset(2, 3), // position: x, y (right & down)
                )
              ]
            ),
            
            width: 420,
            constraints: BoxConstraints(
              maxHeight: 460
            ),
      
            child: Column(
              children: [
                Text('LOGIN', 
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, 
                  color: Colors.black,
                  fontSize: 33

                  )
                ),

                SizedBox(height: 30),

                Text('* Please login your credentials',
                 style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  fontSize: 10

                 ),
                ),


                SizedBox(height: 40),

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
                          labelText: 'Enter Email',
                          border: OutlineInputBorder(),
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

                      SizedBox(height: 45),

                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                          color: Colors.black, 
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          
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

                SizedBox(height: 35),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white, 
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 30), 
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                  
                    )
                  
                  
                  ),
                  onPressed: () {
                    print('Button pressed!'); 
                    
                    if (_formKey.currentState!.validate()) {
                      print('Form is valid!');
                      
                    
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
                              'Login successfully!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  // Clear form after dialog is closed
                                  _formKey.currentState!.reset();
                                  _emailController.clear();
                                  _passwordController.clear();

                                  Navigator.push(
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
                      print('Form validation failed!'); 
                    }
                  },

                  child: Text('Submit'),
                )
              ],
            ),
          )
        ),
    );
  }
}
  

