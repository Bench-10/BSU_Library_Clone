import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/bookmark_service.dart';
import '../../services/auth_service.dart';


class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>>? searchResults;
  final String? searchQuery;
  final String? searchType;
  final String? selectedCampus;
  final String? selectedMaterialType;

  const SearchPage({
    super.key,
    this.searchResults,
    this.searchQuery,
    this.searchType,
    this.selectedCampus,
    this.selectedMaterialType,
  });
  

  @override
  State<SearchPage> createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  Map<String, bool> bookmarkStatus = {}; // Track bookmark status for each book

  @override
  void initState() {
    super.initState();
    
    // Initialize with passed search results
    if (widget.searchResults != null) {
      searchResults = widget.searchResults!;
      _loadBookmarkStatus();
    }
  }

  // Load bookmark status for all books
  Future<void> _loadBookmarkStatus() async {
    if (!AuthService.isLoggedIn()) return;
    
    for (var book in searchResults) {
      if (book['id'] != null) {
        bool isBookmarked = await BookmarkService.isBookmarked(book['id']);
        setState(() {
          bookmarkStatus[book['id']] = isBookmarked;
        });
      }
    }
  }

  // Toggle bookmark for a book
  Future<void> _toggleBookmark(Map<String, dynamic> book) async {
    if (!AuthService.isLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please login to bookmark books')),
      );
      return;
    }

    bool isCurrentlyBookmarked = bookmarkStatus[book['id']] ?? false;
    
    Map<String, dynamic> result;
    if (isCurrentlyBookmarked) {
      result = await BookmarkService.removeBookmark(book['id']);
    } else {
      result = await BookmarkService.addBookmark(book);
    }

    if (result['success']) {
      setState(() {
        bookmarkStatus[book['id']] = !isCurrentlyBookmarked;
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 90,
        backgroundColor: Color.fromARGB(255, 185, 0, 0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Results',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.searchQuery != null)
              Text(
                'for "${widget.searchQuery}"',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
      body: Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Library Books',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )
          ),

          SizedBox(height: 7,),

          SizedBox(
            height: 30,
            child: Row(
              children: [
                Icon(Icons.search, size: 30, color: Colors.red),
                Text(
                  'Search results (${searchResults.length} books)',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )
              ],
            ),
          ),

          SizedBox(height: 20),

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
                            'Loading books from Firebase...',
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No books found',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try a different search term',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final book = searchResults[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 239, 239),
                                borderRadius: BorderRadius.circular(7)
                              ),
                              margin: EdgeInsets.only(bottom: 9),
                              child: ListTile(
                               
                                title: Text(
                                  book['title'] ?? 'No Title',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 14,),

                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14) ,
                                      color: const Color.fromARGB(255, 79, 79, 79),
                                      child: Text(
                                        'DETAILS',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,

                                        ),
                                      ),
                                      
                                    ),


                                    SizedBox(height: 4),
                                    Text(
                                      'Author: ${book['author'] ?? 'Unknown'}',
                                      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      'Subject: ${book['subject'] ?? 'General'}',
                                      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      'Campus: ${book['campus'] ?? 'Not specified'}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    if (book['material_type'] != null)
                                      Text(
                                        'Type: ${book['material_type']}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.green.shade600,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Bookmark button
                                    IconButton(
                                      icon: Icon(
                                        bookmarkStatus[book['id']] == true 
                                          ? Icons.bookmark 
                                          : Icons.bookmark_border,
                                        color: bookmarkStatus[book['id']] == true 
                                          ? Colors.red 
                                          : Colors.grey,
                                        size: 24,
                                      ),
                                      onPressed: () => _toggleBookmark(book),
                                      tooltip: bookmarkStatus[book['id']] == true 
                                        ? 'Remove bookmark' 
                                        : 'Add bookmark',
                                    ),
                                    // Details arrow
                                    Icon(Icons.arrow_forward_ios, size: 16),
                                  ],
                                ),
                                onTap: () {
                                  _showBookDetails(book);
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    ), 
    );
  }

  // Show book details dialog
  void _showBookDetails(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),  
          ),
          title: Text(
            book['title'] ?? 'Book Details',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Title', book['title']),
                _buildDetailRow('Author', book['author']),
                _buildDetailRow('Subject', book['subject']),
                _buildDetailRow('Campus', book['campus']),
                _buildDetailRow('Material Type', book['material_type']),
                _buildDetailRow('Series', book['series']),
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
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not specified',
              style: GoogleFonts.poppins(),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}