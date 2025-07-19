import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/bookmark_service.dart';
import '../../services/borrow_service.dart';
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
  Map<String, bool> bookmarkStatus = {};
  Map<String, String?> borrowRequestStatus = {};
  Map<String, bool> hardCopyAvailability = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize with passed search results
    if (widget.searchResults != null) {
      searchResults = widget.searchResults!;
      _loadBookmarkStatus();
      _loadBorrowRequestStatus();
      _loadHardCopyAvailability();
    }
  }

  // Load hard copy availability for all books
  Future<void> _loadHardCopyAvailability() async {
    for (var book in searchResults) {
      if (book['id'] != null) {
        bool isAvailable = await BorrowService.isHardCopyAvailable(book['id']);
        setState(() {
          hardCopyAvailability[book['id']] = isAvailable;
        });
      }
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

  // Load borrow request status for all books
  Future<void> _loadBorrowRequestStatus() async {
    if (!AuthService.isLoggedIn()) return;
    
    for (var book in searchResults) {
      if (book['id'] != null) {
        String? status = await BorrowService.getRequestStatus(book['id']);
        setState(() {
          borrowRequestStatus[book['id']] = status;
        });
      }
    }
  }

  // Request to borrow a book
  Future<void> _requestBook(Map<String, dynamic> book, String format) async {
    if (!AuthService.isLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please login to request books')),
      );
      return;
    }

    Map<String, dynamic> result = await BorrowService.requestBook(book, format);

    if (result['success']) {
      setState(() {
        borrowRequestStatus[book['id']] = 'pending';
      });
      
      // Show different confirmation messages based on format
      if (format == 'pdf') {
        _showPdfConfirmationDialog();
      } else {
        _showHardCopyConfirmationDialog();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  void _showFormatSelectionDialog(Map<String, dynamic> book) {
    bool hardCopyAvailable = hardCopyAvailability[book['id']] ?? true;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            'Select Format',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How would you like to borrow this book?',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              SizedBox(height: 20),
              
              // PDF Option
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _requestBook(book, 'pdf');
                  },
                  child: Text(
                    'PDF Copy',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              
              SizedBox(height: 12),
              
              // Hard Copy Option
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hardCopyAvailable ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: hardCopyAvailable ? () {
                    Navigator.of(context).pop();
                    _requestBook(book, 'hard_copy');
                  } : null,
                  child: Text(
                    hardCopyAvailable ? 'Hard Copy' : 'Hard Copy (Unavailable)',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
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
          ],
        );
      },
    );
  }

  void _showPdfConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            'PDF Request Submitted',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Your PDF copy request has been submitted. You will be notified via email once approved.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showHardCopyConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(
            'Hard Copy Request Submitted',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Your hard copy request has been submitted. The admin will set a return date upon approval. You will be notified via email.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
                               
                      

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                         Text(
                                          book['title'] ?? 'No Title',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),

                                        IconButton(
                                          icon: Icon(
                                            Icons.star,
                                            color: bookmarkStatus[book['id']] == true 
                                              ? const Color.fromARGB(255, 226, 202, 20) 
                                              : const Color.fromARGB(255, 186, 186, 186),
                                            size: 20,
                                          ),
                                          onPressed: () => _toggleBookmark(book),
                                          tooltip: bookmarkStatus[book['id']] == true 
                                            ? 'Remove bookmark' 
                                            : 'Add bookmark',
                                        ),
                                      ],

                                    ),

                                    SizedBox(height: 14,),

                                    Text(
                                      'Author: ${book['author'] ?? 'Unknown'}',
                                      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      'Subject: ${book['subject'] ?? 'General'}',
                                      style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic),
                                    ),

                                    SizedBox(height: 5,),


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

                                    SizedBox(height: 5,),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                 
                                    _buildRequestButton(book),
                                    
          
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

  Widget _buildRequestButton(Map<String, dynamic> book) {
    String? status = borrowRequestStatus[book['id']];

    
    if (status == 'pending') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          'Pending',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (status == 'granted') {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          'Granted',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {

      return Container(
        margin: EdgeInsets.only(right: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size(60, 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
                      onPressed: () =>{
            showDialog(context: context,
              builder: (BuildContext borrowConfirmition) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),  
                    ),
                    title: Text(
                      'Are you sure you want to borrow this book?',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600,
                        fontSize: 16
                      ),
                    ),

                    actions: [
                      ElevatedButton(
                        onPressed: () => {
                          Navigator.of(borrowConfirmition).pop(),
                          _showFormatSelectionDialog(book),
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 3, 185, 3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), 
                          )
                          
                        ),
                        child: Text('Yes')
                      ),

                      ElevatedButton(
                        onPressed: () => Navigator.of(borrowConfirmition).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 230, 12, 12),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), 
                          )
                        ),
                        child: Text('Cancel')
                      ),


                    ],

                  );
              }
            )
          },          child: Text(
            'Borrow',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

}