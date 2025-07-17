import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  // Get reference to your book_details collection
  static final CollectionReference _booksCollection = 
      FirebaseFirestore.instance.collection('book_details');

  // 1. Get all books
  static Future<List<Map<String, dynamic>>> getAllBooks() async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection.get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error getting books: $e');
      return [];
    }
  }

  // 2. Search books by title
  static Future<List<Map<String, dynamic>>> searchByTitle(String title) async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThanOrEqualTo: '$title\uf8ff')
          .get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  // 3. Search books by author
  static Future<List<Map<String, dynamic>>> searchByAuthor(String author) async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection
          .where('author', isEqualTo: author)
          .get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error searching by author: $e');
      return [];
    }
  }

  // 4. Get books by campus
  static Future<List<Map<String, dynamic>>> getBooksByCampus(String campus) async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection
          .where('campus', isGreaterThanOrEqualTo: campus)
          .get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error getting books by campus: $e');
      return [];
    }
  }

  // 5. Get books by subject
  static Future<List<Map<String, dynamic>>> getBooksBySubject(String subject) async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection
          .where('subject', isEqualTo: subject)
          .get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error getting books by subject: $e');
      return [];
    }
  }

  // 6. Get books by material type
  static Future<List<Map<String, dynamic>>> getBooksByMaterialType(String materialType) async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection
          .where('material_type', isEqualTo: materialType)
          .get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error getting books by material type: $e');
      return [];
    }
  }

  // 7. Search books by series
  static Future<List<Map<String, dynamic>>> searchBySeries(String series) async {
    try {
      QuerySnapshot querySnapshot = await _booksCollection
          .where('series', isEqualTo: series)
          .get();
      
      List<Map<String, dynamic>> books = [];
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
        bookData['id'] = doc.id;
        books.add(bookData);
      }
      
      return books;
    } catch (e) {
      print('Error searching by series: $e');
      return [];
    }
  }

  // ======= ADMIN FUNCTIONS =======
  
  // 8. Add a new book (Admin only)
  static Future<Map<String, dynamic>> addBook({
    required String author,
    required String title,
    required String subject,
    required String series,
    required String campus,
    required String materialStyle,
  }) async {
    try {
      // Add the book to Firestore (using the same collection as existing books)
      DocumentReference bookDoc = await _booksCollection.add({
        'author': author.trim(),
        'title': title.trim(),
        'subject': subject.trim(),
        'series': series.trim(),
        'campus': campus.trim(),
        'material_type': materialStyle.trim(), // Using material_type to match existing schema
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'message': 'Book added successfully',
        'book_id': bookDoc.id
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error adding book: $e'
      };
    }
  }

  // 9. Update an existing book (Admin only)
  static Future<Map<String, dynamic>> updateBook({
    required String bookId,
    String? author,
    String? title,
    String? subject,
    String? series,
    String? campus,
    String? materialStyle,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updated_at': FieldValue.serverTimestamp(),
      };
      
      if (author != null) updates['author'] = author.trim();
      if (title != null) updates['title'] = title.trim();
      if (subject != null) updates['subject'] = subject.trim();
      if (series != null) updates['series'] = series.trim();
      if (campus != null) updates['campus'] = campus.trim();
      if (materialStyle != null) updates['material_type'] = materialStyle.trim();
      
      await _booksCollection.doc(bookId).update(updates);
      
      return {
        'success': true,
        'message': 'Book updated successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating book: $e'
      };
    }
  }

  // 10. Delete a book (Admin only)
  static Future<Map<String, dynamic>> deleteBook(String bookId) async {
    try {
      await _booksCollection.doc(bookId).delete();
      
      return {
        'success': true,
        'message': 'Book deleted successfully'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error deleting book: $e'
      };
    }
  }
}
