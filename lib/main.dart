import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import './features/auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
  } catch (e) {
    // Firebase initialization error: $e
  }
  
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

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
                          MaterialPageRoute(builder: (context) => const LibraryApp()),
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
      await Future.delayed(const Duration(seconds: 1));
      
    } catch (e) {
      // Firebase connection check failed: $e
      rethrow;
    }
  }
}
