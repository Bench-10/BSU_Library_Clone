import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class BookmarkService {
  static final CollectionReference _bookmarksCollection = 
      FirebaseFirestore.instance.collection('bookmarks');

  // Add a book to user's bookmarks
  static Future<Map<String, dynamic>> addBookmark(Map<String, dynamic> book) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'message': 'Please login to bookmark books'
        };
      }

      String userId = AuthService.currentUserId!;
      
      // Check if book is already bookmarked by this user
      QuerySnapshot existingBookmark = await _bookmarksCollection
          .where('user_id', isEqualTo: userId)
          .where('book_id', isEqualTo: book['id'])
          .get();
      
      if (existingBookmark.docs.isNotEmpty) {
        return {
          'success': false,
          'message': 'Book is already bookmarked'
        };
      }

      // Add bookmark
      await _bookmarksCollection.add({
        'user_id': userId,
        'book_id': book['id'],
        'book_title': book['title'],
        'book_author': book['author'],
        'book_subject': book['subject'],
        'book_campus': book['campus'],
        'book_material_type': book['material_type'],
        'book_series': book['series'],
        'bookmarked_at': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Book bookmarked successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error bookmarking book: $e'
      };
    }
  }

  // Remove a book from user bookmarks
  static Future<Map<String, dynamic>> removeBookmark(String bookId) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return {
          'success': false,
          'message': 'Please login to manage bookmarks'
        };
      }

      String userId = AuthService.currentUserId!;
      
      QuerySnapshot bookmarkQuery = await _bookmarksCollection
          .where('user_id', isEqualTo: userId)
          .where('book_id', isEqualTo: bookId)
          .get();
      
      if (bookmarkQuery.docs.isEmpty) {
        return {
          'success': false,
          'message': 'Bookmark not found'
        };
      }

      // Remove bookmark
      await bookmarkQuery.docs.first.reference.delete();

      return {
        'success': true,
        'message': 'Bookmark removed successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error removing bookmark: $e'
      };
    }
  }

  // Get all bookmarks for current user
  static Future<List<Map<String, dynamic>>> getUserBookmarks() async {
    try {
      
      
      if (!AuthService.isLoggedIn()) {
        print('🔖 Debug: User not logged in, returning empty list');
        return [];
      }

      String userId = AuthService.currentUserId!;
      
      
      // Remove orderBy to avoid index requirement for now
      QuerySnapshot bookmarkQuery = await _bookmarksCollection
          .where('user_id', isEqualTo: userId)
          .get();
      
      
      
      List<Map<String, dynamic>> bookmarks = [];
      for (var doc in bookmarkQuery.docs) {
        Map<String, dynamic> bookmarkData = doc.data() as Map<String, dynamic>;
        bookmarkData['bookmark_id'] = doc.id;
        bookmarks.add(bookmarkData);
        
      }
      
      // Sort in memory by timestamp (newest first)
      bookmarks.sort((a, b) {
        if (a['bookmarked_at'] == null) return 1;
        if (b['bookmarked_at'] == null) return -1;
        return b['bookmarked_at'].compareTo(a['bookmarked_at']);
      });
      
      
      return bookmarks;
    } catch (e) {
      print('🔖 Debug: Error getting user bookmarks: $e');
      return [];
    }
  }

  // Check if a book is bookmarked by current user
  static Future<bool> isBookmarked(String bookId) async {
    try {
      if (!AuthService.isLoggedIn()) {
        return false;
      }

      String userId = AuthService.currentUserId!;
      
      QuerySnapshot bookmarkQuery = await _bookmarksCollection
          .where('user_id', isEqualTo: userId)
          .where('book_id', isEqualTo: bookId)
          .get();
      
      return bookmarkQuery.docs.isNotEmpty;
    } catch (e) {
      
      return false;
    }
  }

  // Get bookmark count for current user
  static Future<int> getBookmarkCount() async {
    try {
      if (!AuthService.isLoggedIn()) {
        return 0;
      }

      String userId = AuthService.currentUserId!;
      
      QuerySnapshot bookmarkQuery = await _bookmarksCollection
          .where('user_id', isEqualTo: userId)
          .get();
      
      return bookmarkQuery.docs.length;
    } catch (e) {
      print('Error getting bookmark count: $e');
      return 0;
    }
  }
}
