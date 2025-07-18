import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/bookmark_service.dart';
import '../../services/auth_service.dart';


class BookMarksPage extends StatefulWidget{
  const BookMarksPage({super.key});

  @override
  State<BookMarksPage> createState() => _MyAppState();
}

class _MyAppState extends State<BookMarksPage> {
  List<Map<String, dynamic>> bookmarks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    
    
    if (!AuthService.isLoggedIn()) {

      setState(() {
        isLoading = false;
      });
      return;


    }

    

    try {
      List<Map<String, dynamic>> userBookmarks = await BookmarkService.getUserBookmarks();
     
      
      setState(() {
        bookmarks = userBookmarks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bookmarks: $e')),
      );
    }
  }

  Future<void> _removeBookmark(String bookId, int index) async {
    Map<String, dynamic> result = await BookmarkService.removeBookmark(bookId);
    
    if (result['success']) {
      setState(() {
        bookmarks.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Library System',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )
          ),

          SizedBox(height: 8,),

          SizedBox(
            height: 30,
            
            child: Row(
              children: [
                Icon(Icons.bookmark, size: 30, color: Colors.red),

                Text(
                  'My Bookmarks',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )

              ],
            ),
          ),

          SizedBox(height: 25),

          // Check if user is logged in
          if (!AuthService.isLoggedIn())
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please login to view bookmarks',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              'Loading your bookmarks...',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : bookmarks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bookmark_border,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No bookmarks yet',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Search for books and bookmark them to see them here',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              // Header with count
                              Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.bookmark, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '${bookmarks.length} Bookmarked Books',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Bookmarked books list
                              Expanded(
                                child: ListView.builder(
                                  itemCount: bookmarks.length,
                                  itemBuilder: (context, index) {
                                    final bookmark = bookmarks[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 249, 249, 249),
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(color: Colors.red.shade100),
                                      ),
                                      margin: EdgeInsets.only(bottom: 8),
                                      child: ListTile(
                                        
                                        title: Text(
                                          bookmark['book_title'] ?? 'No Title',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 6),
                                            Text(
                                              'Author: ${bookmark['book_author'] ?? 'Unknown'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              'Subject: ${bookmark['book_subject'] ?? 'General'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              'Campus: ${bookmark['book_campus'] ?? 'Not specified'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.blue.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red.shade400,
                                                size: 20,
                                              ),
                                              onPressed: () => _removeBookmark(bookmark['book_id'], index),
                                              tooltip: 'Remove bookmark',
                                            ),
                                          
                                          ],
                                        ),
                                        onTap: () {
                                          _showBookmarkDetails(bookmark);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
            ),

        ]
      )
    );
    
  }

  // Show bookmark details dialog
  void _showBookmarkDetails(Map<String, dynamic> bookmark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),  
          ),
          title: Text(
            bookmark['book_title'] ?? 'Book Details',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Title', bookmark['book_title']),
                _buildDetailRow('Author', bookmark['book_author']),
                _buildDetailRow('Subject', bookmark['book_subject']),
                _buildDetailRow('Campus', bookmark['book_campus']),
                _buildDetailRow('Material Type', bookmark['book_material_type']),
                _buildDetailRow('Series', bookmark['book_series']),
                SizedBox(height: 8),
                Text(
                  'Bookmarked on: ${_formatDate(bookmark['bookmarked_at'])}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: GoogleFonts.poppins(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not specified',
              style: GoogleFonts.poppins(),
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
      return 'Unknown';
    }
  }
}



