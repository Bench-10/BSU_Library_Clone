import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'features/pages/mainApp.dart';
import './features/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  runApp(LibraryApp());
}

class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BatStateU Library System',
      home: FutureBuilder(
        future: _checkFirebaseConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Connecting to Firebase...'),
                  ],
                ),
              ),
            );
          }
          
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 20),
                    Text('Firebase Connection Error'),
                    SizedBox(height: 10),
                    Text('${snapshot.error}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Restart the app
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LibraryApp()),
                        );
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return const Login();
        },
      ),
    );
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      // Test Firebase connection by trying to access Firestore
      await Future.delayed(Duration(seconds: 1)); // Give Firebase time to initialize
      print('Firebase connection check completed');
    } catch (e) {
      print('Firebase connection check failed: $e');
      throw e;
    }
  }
}
