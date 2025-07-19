import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/borrow_service.dart';

class ReturnedBooksPage extends StatefulWidget {
  const ReturnedBooksPage({super.key});

  @override
  State<ReturnedBooksPage> createState() => _ReturnedBooksPageState();
}

class _ReturnedBooksPageState extends State<ReturnedBooksPage> {
  List<Map<String, dynamic>> returnedBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReturnedBooks();
  }

  Future<void> _loadReturnedBooks() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> books = await BorrowService.getReturnedBooks();
    
    setState(() {
      returnedBooks = books;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.book_outlined, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text(
                  'Returned Books Confirmation',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          
          // Books list
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : returnedBooks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No hard copy books to process',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'All hard copies have been returned',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: returnedBooks.length,
                        itemBuilder: (context, index) {
                          final book = returnedBooks[index];
                          return _buildBookCard(book);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 223, 223, 223),
        borderRadius: BorderRadius.circular(10)

      ),
      
      
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          book['book_title'] ?? 'Unknown Book',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          book['user_email'] ?? 'Unknown Student',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: 16,
        ),
        onTap: () => _showBookReturnDialog(book),
      ),
    );
  }

  void _showBookReturnDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            'Book Return Confirmation',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Information Section
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color.fromARGB(255, 54, 54, 54)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book Information',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow('Title', book['book_title']),
                    _buildDetailRow('Author', book['book_author']),
                    _buildDetailRow('Subject', book['book_subject']),
                    if (book['access_end_date'] != null)
                      _buildDetailRow('Due Date', _formatDate(book['access_end_date'])),
                  ],
                ),
              ),
              
              SizedBox(height: 8),

              Divider(thickness: 2, color: Colors.black,),

              SizedBox(height: 8),
              
              // Student Information Section
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(6),
                   border: Border.all(color: const Color.fromARGB(255, 54, 54, 54)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Information',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildDetailRow('Name', book['user_name']),
                    _buildDetailRow('Email', book['user_email']),
                    if (book['granted_at'] != null)
                      _buildDetailRow('Borrowed On', _formatDate(book['granted_at'])),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _confirmReturn(book['request_id']);
              },
              child: Text(
                'Confirm',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: const Color.fromARGB(255, 34, 34, 34),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not specified',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    
    try {
      DateTime date = timestamp.toDate();
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  Future<void> _confirmReturn(String requestId) async {
    Map<String, dynamic> result = await BorrowService.markAsReturned(requestId);
    
    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Book marked as returned successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _loadReturnedBooks(); // Refresh the list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
