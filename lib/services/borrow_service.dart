import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class BorrowService {
  static final CollectionReference _borrowRequestsCollection = 
      FirebaseFirestore.instance.collection('borrow_requests');

  // Submit a borrow request
  static Future<Map<String, dynamic>> requestBook(Map<String, dynamic> book, String format) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'message': 'Please login to request books'
        };
      }

      String userId = AuthService.currentUserId!;
      String userName = AuthService.currentUserData!['full_name'];
      String userEmail = AuthService.currentUserData!['email'];
      
      // Check if user already has a pending or granted request for this book
      QuerySnapshot existingRequest = await _borrowRequestsCollection
          .where('user_id', isEqualTo: userId)
          .where('book_id', isEqualTo: book['id'])
          .where('status', whereIn: ['pending', 'granted'])
          .get();
      
      if (existingRequest.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'You already have a request for this book'
        };
      }

      // Create borrow request
      await _borrowRequestsCollection.add({
        'user_id': userId,
        'user_name': userName, // Will be updated when we get user data
        'user_email': userEmail, // Will be updated when we get user data
        'book_id': book['id'],
        'book_title': book['title'],
        'book_author': book['author'],
        'book_subject': book['subject'],
        'book_campus': book['campus'],
        'book_material_type': book['material_type'],
        'book_series': book['series'],
        'format': format, // 'pdf' or 'hard_copy'
        'status': 'pending',
        'requested_at': FieldValue.serverTimestamp(),
        'access_end_date': null,
        'granted_at': null,
        'is_returned': false, // Track if hard copy is returned
      });

      return {
        'success': true,
        'message': 'Book request submitted successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error submitting request: $e'
      };
    }
  }

  // Get user's borrow requests
  static Future<List<Map<String, dynamic>>> getUserBorrowRequests() async {
    try {
      if (!AuthService.isLoggedIn()) {
        return [];
      }

      String userId = AuthService.currentUserId!;
      
      QuerySnapshot requestQuery = await _borrowRequestsCollection
          .where('user_id', isEqualTo: userId)
          .get();
      
      List<Map<String, dynamic>> requests = [];
      for (var doc in requestQuery.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['request_id'] = doc.id;
        requests.add(requestData);
      }
      
      // Sort by requested date (newest first)
      requests.sort((a, b) {
        if (a['requested_at'] == null) return 1;
        if (b['requested_at'] == null) return -1;
        return b['requested_at'].compareTo(a['requested_at']);
      });
      
      return requests;
    } catch (e) {
      print('Error getting user borrow requests: $e');
      return [];
    }
  }

  // Check if user has already requested a book
  static Future<String?> getRequestStatus(String bookId) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return null;
      }

      String userId = AuthService.currentUserId!;
      
      QuerySnapshot requestQuery = await _borrowRequestsCollection
          .where('user_id', isEqualTo: userId)
          .where('book_id', isEqualTo: bookId)
          .where('status', whereIn: ['pending', 'granted'])
          .get();
      
      if (requestQuery.docs.isNotEmpty) {
        Map<String, dynamic> requestData = requestQuery.docs.first.data() as Map<String, dynamic>;
        return requestData['status'];
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check if hard copy is available for a book
  static Future<bool> isHardCopyAvailable(String bookId) async {
    try {
      QuerySnapshot requestQuery = await _borrowRequestsCollection
          .where('book_id', isEqualTo: bookId)
          .where('format', isEqualTo: 'hard_copy')
          .where('status', isEqualTo: 'granted')
          .where('is_returned', isEqualTo: false)
          .get();
      
      return requestQuery.docs.isEmpty; // Available if no unreturned hard copies
    } catch (e) {
      return true; // Default to available if error
    }
  }

  // Admin functions
  
  // Get all pending borrow requests for admin
  static Future<List<Map<String, dynamic>>> getAllBorrowRequests() async {
    try {
      QuerySnapshot requestQuery = await _borrowRequestsCollection
          .orderBy('requested_at', descending: true)
          .get();
      
      List<Map<String, dynamic>> requests = [];
      for (var doc in requestQuery.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['request_id'] = doc.id;
        requests.add(requestData);
      }
      
      return requests;
    } catch (e) {
      print('Error getting all borrow requests: $e');
      return [];
    }
  }

  // Grant access to a book request
  static Future<Map<String, dynamic>> grantAccess(String requestId, DateTime? accessEndDate) async {
    try {
      Map<String, dynamic> updateData = {
        'status': 'granted',
        'granted_at': FieldValue.serverTimestamp(),
      };
      
      // Only set access end date for hard copy requests
      if (accessEndDate != null) {
        updateData['access_end_date'] = Timestamp.fromDate(accessEndDate);
      }
      
      await _borrowRequestsCollection.doc(requestId).update(updateData);

      return {
        'success': true,
        'message': 'Access granted successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error granting access: $e'
      };
    }
  }

  // Get all returned books (hard copies that are still granted but need to be marked as returned)
  static Future<List<Map<String, dynamic>>> getReturnedBooks() async {
    try {
      QuerySnapshot requestQuery = await _borrowRequestsCollection
          .where('format', isEqualTo: 'hard_copy')
          .where('status', isEqualTo: 'granted')
          .where('is_returned', isEqualTo: false)
          .get();
      
      List<Map<String, dynamic>> requests = [];
      for (var doc in requestQuery.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestData['request_id'] = doc.id;
        requests.add(requestData);
      }
      
      return requests;
    } catch (e) {
      print('Error getting returned books: $e');
      return [];
    }
  }

  // Mark a hard copy book as returned
  static Future<Map<String, dynamic>> markAsReturned(String requestId) async {
    try {
      await _borrowRequestsCollection.doc(requestId).update({
        'is_returned': true,
        'returned_at': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Book marked as returned successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error marking book as returned: $e'
      };
    }
  }

  // Reject a book request
  static Future<Map<String, dynamic>> rejectRequest(String requestId) async {
    try {
      await _borrowRequestsCollection.doc(requestId).update({
        'status': 'rejected',
        'rejected_at': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Request rejected successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error rejecting request: $e'
      };
    }
  }

  // Get borrow requests count for admin
  static Future<Map<String, int>> getRequestCounts() async {
    try {
      QuerySnapshot pendingQuery = await _borrowRequestsCollection
          .where('status', isEqualTo: 'pending')
          .get();
      
      QuerySnapshot grantedQuery = await _borrowRequestsCollection
          .where('status', isEqualTo: 'granted')
          .get();
      
      QuerySnapshot rejectedQuery = await _borrowRequestsCollection
          .where('status', isEqualTo: 'rejected')
          .get();
      
      return {
        'pending': pendingQuery.docs.length,
        'granted': grantedQuery.docs.length,
        'rejected': rejectedQuery.docs.length,
        'total': pendingQuery.docs.length + grantedQuery.docs.length + rejectedQuery.docs.length,
      };
    } catch (e) {
      print('Error getting request counts: $e');
      return {
        'pending': 0,
        'granted': 0,
        'rejected': 0,
        'total': 0,
      };
    }
  }
}
