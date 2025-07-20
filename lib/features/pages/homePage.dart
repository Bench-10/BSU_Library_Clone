import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/book_service.dart';
import '../../services/bookmark_service.dart';
import '../../services/borrow_service.dart';
import '../../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCampus;
  String? selectedMaterialType;
  String? selectedOption;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  Map<String, bool> bookmarkedItems = {}; // Track bookmark status by book ID
  Map<String, String?> borrowRequestStatus = {}; // Track borrow request status
  Map<String, bool> hardCopyAvailability = {}; // Track hard copy availability
  
  final List<String> campuses = [
    'ARASOF-Nasugbu',
    'BatStateU TNEU-Alangilan',
    'BatStateU TNEU-Balayan',
    'BatStateU TNEU-Lemery',
    'BatStateU TNEU-Mabini',
    'BatStateU TNEU-Malvar',
    'BatStateU TNEU-San Juan',
  ];
  
  final List<String> materialTypes = [
    'Book',
    'E-book',
    'Journal',
    'Magazine',
    'Thesis',
    'Research Paper',
    'Reference Material',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = ''; // Start with empty search field
    // Remove initial data loading - start with empty results
  }

  // Load bookmark status for search results
  Future<void> _loadBookmarkStatus() async {
    if (!AuthService.isLoggedIn()) return;
    
    for (int i = 0; i < searchResults.length; i++) {
      final item = searchResults[i];
      final bookId = item['id']?.toString() ?? '';
      if (bookId.isNotEmpty) {
        bool isBookmarked = await BookmarkService.isBookmarked(bookId);
        setState(() {
          bookmarkedItems[bookId] = isBookmarked;
        });
      }
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

  // Show book details dialog
  void _showBookDetails(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 500,
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.book, color: Colors.red, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Book Details',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // Book Title
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    book['title'] ?? 'Unknown Title',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                
                // Details
                ..._buildDetailRows(book),
                
                SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Close',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build detail rows for the dialog
  List<Widget> _buildDetailRows(Map<String, dynamic> book) {
    return [
      _buildDetailRow('Author', book['author']),
      _buildDetailRow('Subject', book['subject']),
      _buildDetailRow('Campus', book['campus']),
      _buildDetailRow('Material Type', book['material_type']),
      _buildDetailRow('Series', book['series']),
    ];
  }

  // Build a single detail row
  Widget _buildDetailRow(String label, dynamic value) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value?.toString() ?? 'Not specified',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Perform search based on selected criteria
  Future<void> _performSearch() async {
    String searchQuery = _searchController.text.trim();
    bool hasSearchQuery = searchQuery.isNotEmpty;
    bool hasSearchType = selectedOption != null;
    bool hasCampus = selectedCampus != null;
    bool hasMaterialType = selectedMaterialType != null;

    // Validation logic
    if (hasSearchQuery && !hasSearchType) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a search type (Title, Author, Subject, or Series) when entering search text')),
      );
      return;
    }

    if (hasSearchType && !hasSearchQuery) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter search text when a search type is selected')),
      );
      return;
    }

    if (!hasSearchQuery && !hasSearchType && !hasCampus && !hasMaterialType) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter search criteria: either search text with type, or select campus/material')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<Map<String, dynamic>> results = [];
      results = await BookService.getAllBooks();
      
      // Apply case-insensitive text search if both query and type are provided
      if (hasSearchQuery && hasSearchType) {
        String queryLower = searchQuery.toLowerCase();
        results = results.where((book) {
          String fieldValue = '';
          switch (selectedOption) {
            case 'Title':
              fieldValue = book['title']?.toString() ?? '';
              break;
            case 'Author':
              fieldValue = book['author']?.toString() ?? '';
              break;
            case 'Subject':
              fieldValue = book['subject']?.toString() ?? '';
              break;
            case 'Series':
              fieldValue = book['series']?.toString() ?? '';
              break;
          }
          return fieldValue.toLowerCase().contains(queryLower);
        }).toList();
      }

      // Apply filters
      if (hasCampus) {
        results = results.where((book) => 
          book['campus']?.toString().toLowerCase().contains(selectedCampus!.toLowerCase()) == true
        ).toList();
      }

      if (hasMaterialType) {
        results = results.where((book) =>
          book['material_type']?.toString().toLowerCase().contains(selectedMaterialType!.toLowerCase()) == true
        ).toList();
      }

      setState(() {
        searchResults = results;
        isLoading = false;
      });

      // Load bookmark status for the results
      await _loadBookmarkStatus();
      await _loadBorrowRequestStatus();
      await _loadHardCopyAvailability();

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error performing search: $e')),
        );
      }
    }
  }

  void _clearFields() {
     _searchController.clear();
     setState(() {
      selectedCampus = null;
      selectedMaterialType = null;
      selectedOption = null;
      searchResults = []; // Clear search results
      bookmarkedItems.clear(); // Clear bookmark status
      borrowRequestStatus.clear(); // Clear borrow status
      hardCopyAvailability.clear(); // Clear availability status
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All fields cleared successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _toggleBookmark(Map<String, dynamic> item) async {
    if (!AuthService.isLoggedIn()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please login to bookmark books'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final bookId = item['id']?.toString() ?? '';
    if (bookId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid book ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isCurrentlyBookmarked = bookmarkedItems[bookId] ?? false;

    try {
      Map<String, dynamic> result;
      if (isCurrentlyBookmarked) {
        // Remove bookmark
        result = await BookmarkService.removeBookmark(bookId);
      } else {
        // Add bookmark
        result = await BookmarkService.addBookmark(item);
      }

      if (result['success']) {
        setState(() {
          bookmarkedItems[bookId] = !isCurrentlyBookmarked;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error managing bookmark: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildRequestButton(Map<String, dynamic> book) {
    String? status = borrowRequestStatus[book['id']];

    if (status == 'pending') {
      return Container(
        width: 60,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Pending',
                  style: GoogleFonts.poppins(
            color: Colors.white,
                    fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (status == 'granted') {
      return Container(
        width: 60,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Granted',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 15,
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
            minimumSize: Size(60, 40), //DITO
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () => {
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
          },          
          child: Text(
            'Borrow',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HomePage build method called'); // Debug print
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  // Stack vertically if width is less than 800px (mobile/tablet)
                  if (constraints.maxWidth < 800) {
                    return Column(
                      children: [
                        // Search Library Panel
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Icon(Icons.search, color: Colors.red, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Search Library',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Find books and resources in the library system.',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 25),

                              // Search Term
                              Text(
                                'Search Term',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Enter search term...',
                                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                              ),
                              SizedBox(height: 20),

                              // Campus Dropdown
                              Text(
                                'Campus',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedCampus,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.school, color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                hint: Text(
                                  'Select Campus',
                                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                                ),
                                items: campuses.map((String campus) {
                                  return DropdownMenuItem<String>(
                                    value: campus,
                                    child: Text(
                                      campus,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCampus = newValue;
                                  });
                                },
                              ),
                              SizedBox(height: 20),

                              // Material Type Dropdown
                              Text(
                                'Material Type',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: selectedMaterialType,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.library_books, color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                hint: Text(
                                  'Select Material Type',
                                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                                ),
                                items: materialTypes.map((String material) {
                                  return DropdownMenuItem<String>(
                                    value: material.toLowerCase(),
                                    child: Text(
                                      material,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMaterialType = newValue;
                                  });
                                },
                              ),
                              SizedBox(height: 25),

                              // Search By Options
                              Text(
                                'Search By:',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Fixed grid layout instead of Wrap
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildSearchOptionButton('Title')),
                                      SizedBox(width: 8),
                                      Expanded(child: _buildSearchOptionButton('Author')),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _buildSearchOptionButton('Subject')),
                                      SizedBox(width: 8),
                                      Expanded(child: _buildSearchOptionButton('Series')),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),

                              // Search Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 2,
                                  ),
                                  onPressed: isLoading ? null : _performSearch,
                                  child: isLoading 
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text('Searching...'),
                                        ],
                                      )
                                    : Text(
                                        'Search',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                ),
                              ),
                              
                              SizedBox(height: 12),
                              
                              // Clear Button
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 1,
                                  ),
                                  onPressed: _clearFields,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.clear, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Clear All',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Search Results Panel
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Search Results',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              
                              // Show results or no results message
                              if (isLoading)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Loading books from Firebase...',
                                        style: GoogleFonts.poppins(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                )
                              else if (searchResults.isEmpty)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No results found',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Try searching for books or resources',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Column(
                                  children: [
                                    Text(
                                      'Found ${searchResults.length} results',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ...searchResults.map((item) {
                                      final bookId = item['id']?.toString() ?? '';
                                      final isBookmarked = bookmarkedItems[bookId] ?? false;
                                      
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0, 1),
                                            )
                                          ]
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${item['title'] ?? 'Unknown Title'} [${item['material_type'] ?? 'Unknown Type'}]',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        item['author'] ?? 'Unknown Author',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        'Subject: ${item['subject'] ?? 'Unknown Subject'}',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: Colors.grey[500],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                    color: isBookmarked ? Colors.amber : Colors.grey,
                                                  ),
                                                  onPressed: () => _toggleBookmark(item),
                                                  tooltip: isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.grey[300],
                                                      foregroundColor: Colors.black,
                                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      minimumSize: Size(60, 40),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                    ),
                                                    onPressed: () => _showBookDetails(item),
                                                    child: Text(
                                                      'DETAILS',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: _buildRequestButton(item),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Side-by-side layout for desktop (width >= 800px)
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Panel - Search Library
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header
                                Row(
                                  children: [
                                    Icon(Icons.search, color: Colors.red, size: 24),
                                    SizedBox(width: 8),
                                    Text(
                                      'Search Library',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Find books and resources in the library system.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 25),

                                // Search Term
                                Text(
                                  'Search Term',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter search term...',
                                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Campus Dropdown
                                Text(
                                  'Campus',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: selectedCampus,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.school, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  hint: Text(
                                    'Select Campus',
                                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                                  ),
                                  items: campuses.map((String campus) {
                                    return DropdownMenuItem<String>(
                                      value: campus,
                                      child: Text(
                                        campus,
                                        style: GoogleFonts.poppins(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedCampus = newValue;
                                    });
                                  },
                                ),
                                SizedBox(height: 20),

                                // Material Type Dropdown
                                Text(
                                  'Material Type',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  value: selectedMaterialType,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.library_books, color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  hint: Text(
                                    'Select Material Type',
                                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                                  ),
                                  items: materialTypes.map((String material) {
                                    return DropdownMenuItem<String>(
                                      value: material.toLowerCase(),
                                      child: Text(
                                        material,
                                        style: GoogleFonts.poppins(),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMaterialType = newValue;
                                    });
                                  },
                                ),
                                SizedBox(height: 25),

                                // Search By Options
                                Text(
                                  'Search By:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // Fixed grid layout instead of Wrap
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: _buildSearchOptionButton('Title')),
                                        SizedBox(width: 8),
                                        Expanded(child: _buildSearchOptionButton('Author')),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(child: _buildSearchOptionButton('Subject')),
                                        SizedBox(width: 8),
                                        Expanded(child: _buildSearchOptionButton('Series')),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),

                                // Search Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: isLoading ? null : _performSearch,
                                    child: isLoading 
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Text('Searching...'),
                                          ],
                                        )
                                      : Text(
                                          'Search',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                  ),
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Clear Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 1,
                                    ),
                                    onPressed: _clearFields,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.clear, size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'Clear All',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        // Right Panel - Search Results
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Search Results',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                
                                // Show results or no results message
                                if (isLoading)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Loading books from Firebase...',
                                          style: GoogleFonts.poppins(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (searchResults.isEmpty)
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 64,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No results found',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Try searching for books or resources',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Column(
                                    children: [
                                      Text(
                                        'Found ${searchResults.length} results',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      ...searchResults.map((item) {
                                        final bookId = item['id']?.toString() ?? '';
                                        final isBookmarked = bookmarkedItems[bookId] ?? false;
                                        
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 12),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.05),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 1),
                                              )
                                            ]
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${item['title'] ?? 'Unknown Title'} [${item['material_type'] ?? 'Unknown Type'}]',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          item['author'] ?? 'Unknown Author',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            color: Colors.grey[600],
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          'Subject: ${item['subject'] ?? 'Unknown Subject'}',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            color: Colors.grey[500],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                                      color: isBookmarked ? Colors.amber : Colors.grey,
                                                    ),
                                                    onPressed: () => _toggleBookmark(item),
                                                    tooltip: isBookmarked ? 'Remove Bookmark' : 'Add Bookmark',
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.grey[300],
                                                        foregroundColor: Colors.black,
                                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                        minimumSize: Size(60, 40),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(6),
                                                        ),
                                                      ),
                                                      onPressed: () => _showBookDetails(item),
                                                      child: Text(
                                                        'DETAILS',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: _buildRequestButton(item),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchOptionButton(String option) {
    final isSelected = selectedOption == option;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.red : Colors.white,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: isSelected ? 2 : 1,
      ),
      onPressed: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Text(
        option,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


