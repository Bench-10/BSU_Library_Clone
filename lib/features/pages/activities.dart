import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/borrow_service.dart';
import '../../services/auth_service.dart';


class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});
  

  @override
  State<MyActivityPage> createState() => _MyAppState();
}


class _MyAppState extends State<MyActivityPage> {
  List<Map<String, dynamic>> borrowRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBorrowRequests();
  }

  Future<void> _loadBorrowRequests() async {
    if (!AuthService.isLoggedIn()) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> requests = await BorrowService.getUserBorrowRequests();
    
    setState(() {
      borrowRequests = requests;
      isLoading = false;
    });
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

          SizedBox(height: 7,),

          SizedBox(
            height: 30,
            
            child: Row(
              children: [
                Icon(Icons.timeline, size: 30, color: Colors.red),

                Text(
                  'Borrowing Activities',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )

              ],
            ),
          ),

          SizedBox(height: 25),

          // Borrowed Books List
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                : borrowRequests.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.library_books_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No borrowed books yet',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Request books from the search page to see them here',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: borrowRequests.length,
                        itemBuilder: (context, index) {
                          final request = borrowRequests[index];
                          return _buildBorrowRequestCard(request);
                        },
                      ),
          ),




        ],
      ),
    );
  }

  Widget _buildBorrowRequestCard(Map<String, dynamic> request) {
    Color statusColor = _getStatusColor(request['status']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
    
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          color: statusColor,   // border color
          width: 2.0,            // border thickness
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request['book_title'] ?? 'Unknown Book',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getStatusText(request['status']),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8),
            
            // Book details
            if (request['book_author'] != null)
              Text(
                'Author: ${request['book_author']}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            if (request['book_subject'] != null)
              Text(
                'Subject: ${request['book_subject']}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            
            SizedBox(height: 8),
            
            // Request date
            if (request['requested_at'] != null)
              Text(
                'Requested: ${_formatDate(request['requested_at'])}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            
            // Access end date if granted
            if (request['status'] == 'granted' && request['access_end_date'] != null)
              Text(
                'Access until: ${_formatDate(request['access_end_date'])}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'granted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String? status) {
    switch (status) {
      case 'pending':
        return 'PENDING APPROVAL';
      case 'granted':
        return 'GRANTED';
      case 'rejected':
        return 'REJECTED';
      default:
        return 'UNKNOWN';
    }
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
}
