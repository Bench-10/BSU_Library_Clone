import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';

// This script creates sample users in Firestore
void main() async {
  try {
    // Initialize Firebase
    print('🔥 Initializing Firebase...');
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully!');

    final firestore = FirebaseFirestore.instance;
    final usersCollection = firestore.collection('users');

    // Sample users data
    final sampleUsers = [
      {
        'email': 'bench.deluna@g.batstate-u.edu.ph',
        'password': 'password123',
        'full_name': 'Bench De Luna',
        'sr_code': '20-65432',
        'contact_info': '+63 912 345 6789',
      },
      {
        'email': 'maria.santos@g.batstate-u.edu.ph',
        'password': 'password123',
        'full_name': 'Maria Santos',
        'sr_code': '20-12345',
        'contact_info': '+63 987 654 3210',
      },
      {
        'email': 'john.cruz@g.batstate-u.edu.ph',
        'password': 'password123',
        'full_name': 'John Cruz',
        'sr_code': '21-54321',
        'contact_info': '+63 998 765 4321',
      },
      {
        'email': 'admin@batstate-u.edu.ph',
        'password': 'admin123',
        'full_name': 'Library Administrator',
        'sr_code': 'ADMIN001',
        'contact_info': '+63 956 123 4567',
      },
    ];

    print('\n👥 Creating sample users...');

    for (var userData in sampleUsers) {
      try {
        // Check if user already exists
        final existingUser = await usersCollection
            .where('email', isEqualTo: userData['email'])
            .get();

        if (existingUser.docs.isNotEmpty) {
          print('⚠️  User ${userData['email']} already exists, skipping...');
          continue;
        }

        // Hash password
        final hashedPassword = _hashPassword(userData['password']!);

        // Create user document
        await usersCollection.add({
          'email': userData['email']?.toLowerCase(),
          'password': hashedPassword,
          'full_name': userData['full_name'],
          'sr_code': userData['sr_code'],
          'contact_info': userData['contact_info'],
          'created_at': FieldValue.serverTimestamp(),
          'last_login': null,
        });

        print('✅ Created user: ${userData['full_name']} (${userData['email']})');
      } catch (e) {
        print('❌ Error creating user ${userData['email']}: $e');
      }
    }

    print('\n🎉 Sample users creation completed!');
    print('\n📋 Login Credentials:');
    print('1. bench.deluna@g.batstate-u.edu.ph / password123');
    print('2. maria.santos@g.batstate-u.edu.ph / password123');
    print('3. john.cruz@g.batstate-u.edu.ph / password123');
    print('4. admin@batstate-u.edu.ph / admin123');
    
    exit(0);
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}

// Hash password function (same as in AuthService)
String _hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
