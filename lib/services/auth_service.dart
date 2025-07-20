import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  static final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');
  
  static String? _currentUserId;
  static Map<String, dynamic>? _currentUserData;

  // Get current user ID
  static String? get currentUserId => _currentUserId;
  
  // Get current user data
  static Map<String, dynamic>? get currentUserData => _currentUserData;

  // Hash password for security
  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Login user and admin
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      String hashedPassword = _hashPassword(password); 
      
      QuerySnapshot userQuery = await _usersCollection
          .where('email', isEqualTo: email.toLowerCase())
          .where('password', isEqualTo: hashedPassword)
          .get();
      
      if (userQuery.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Invalid email or password'
        };
      }

      DocumentSnapshot userDoc = userQuery.docs.first;
      
      // Update last login
      await userDoc.reference.update({
        'last_login': FieldValue.serverTimestamp(),
      });

      // Set current user
      _currentUserId = userDoc.id;
      _currentUserData = userDoc.data() as Map<String, dynamic>;
      _currentUserData!['id'] = userDoc.id;

      return {
        'success': true,
        'message': 'Login successful',
        'user_data': _currentUserData
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error during login: $e'
      };
    }
  }

  // Check if    current user is admin
  static bool isAdmin() {
    if (!isLoggedIn()) return false;
    return _currentUserData?['user_type'] == 'admin';
  }

  // Admin login with hardcoded credentials
  static Future<Map<String, dynamic>> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      // Hardcoded admin credentials
      const String adminEmail = 'admin@batstate-u.edu.ph';
      const String adminPassword = 'admin123';
      
      if (email.toLowerCase().trim() == adminEmail && password == adminPassword) {
        // Set current user as admin
        _currentUserId = 'admin';
        _currentUserData = {
          'id': 'admin',
          'email': adminEmail,
          'full_name': 'System Administrator',
          'user_type': 'admin',
        };
        
        return {
          'success': true,
          'message': 'Admin login successful',
          'user_data': _currentUserData
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid admin credentials'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error during admin login: $e'
      };
    }
  }

  // Logout user
  static void logoutUser() {
    _currentUserId = null;
    _currentUserData = null;
  }

  // Check if uuser is logged in
  static bool isLoggedIn() {
    return _currentUserId != null && _currentUserData != null;
  }

  // Get user data by Id
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        userData['id'] = userDoc.id;
        return userData;
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
  
}
