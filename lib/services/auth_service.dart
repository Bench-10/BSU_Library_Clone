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

  // Register a new user
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String fullName,
    required String srCode,
    required String contactInfo,
  }) async {
    try {
      // Check if user already exists
      QuerySnapshot existingUser = await _usersCollection
          .where('email', isEqualTo: email.toLowerCase())
          .get();
      
      if (existingUser.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'User with this email already exists'
        };
      }

      
      QuerySnapshot existingSrCode = await _usersCollection
          .where('sr_code', isEqualTo: srCode)
          .get();
      
      if (existingSrCode.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'User with this SR code already exists'
        };
      }

      // Create new user
      DocumentReference userDoc = await _usersCollection.add({
        'email': email.toLowerCase(),
        'password': _hashPassword(password),
        'full_name': fullName,
        'sr_code': srCode,
        'contact_info': contactInfo,
        'created_at': FieldValue.serverTimestamp(),
        'last_login': null,
      });

      return {
        'success': true,
        'message': 'User registered successfully',
        'user_id': userDoc.id
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error registering user: $e'
      };
    }
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

  // Update user profile
  static Future<bool> updateUserProfile({
    required String userId,
    String? fullName,
    String? contactInfo,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      
      if (fullName != null) updates['full_name'] = fullName;
      if (contactInfo != null) updates['contact_info'] = contactInfo;
      
      if (updates.isNotEmpty) {
        await _usersCollection.doc(userId).update(updates);
        
        // Update current user data if it isthe logged-in user
        if (userId == _currentUserId) {
          _currentUserData?.addAll(updates);
        }
      }
      
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }
}
