import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/book_service.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _seriesController = TextEditingController();
  final _campusController = TextEditingController();
  final _materialStyleController = TextEditingController();
  
  bool _isLoading = false;

  // Predefined options for dropdowns
  final List<String> _campusOptions = [
    'ARASOF-Nasugbu',
    'BatStateU TNEU-Alangilan',
    'BatStateU TNEU-Balayan',
    'BatStateU TNEU-Lemery',
    'BatStateU TNEU-Mabini',
    'BatStateU TNEU-Malvar',
    'BatStateU TNEU-San Juan',
  ];

  final List<String> _materialStyleOptions = [
    'Book',
    'E-book',
    'Journal',
    'Magazine',
    'Thesis',
    'Research Paper',
    'Reference Material',
  ];

  String? _selectedCampus;
  String? _selectedMaterialStyle;

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    _subjectController.dispose();
    _seriesController.dispose();
    _campusController.dispose();
    _materialStyleController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _authorController.clear();
    _titleController.clear();
    _subjectController.clear();
    _seriesController.clear();
    _campusController.clear();
    _materialStyleController.clear();
    setState(() {
      _selectedCampus = null;
      _selectedMaterialStyle = null;
    });
  }

  Future<void> _addBook() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, dynamic> result = await BookService.addBook(
        author: _authorController.text.trim(),
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        series: _seriesController.text.trim(),
        campus: _selectedCampus ?? _campusController.text.trim(),
        materialStyle: _selectedMaterialStyle ?? _materialStyleController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (result['success']) {
        
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text('Success'),
                ],
              ),
              content: Text('Book has been added successfully!'),
              actions: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 49, 200, 8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), 
                    )
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearForm(); 
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
       
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Error'),
                ],
              ),
              content: Text(result['message']),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            
            padding: EdgeInsets.symmetric(horizontal: 35, vertical: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_box,
                      size: 35,
                      color: Colors.red,
                    ),
                    SizedBox(width: 15),
                    Text(
                      'Add New Book',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Fill in the details to add a new book to the library system',
                  style: GoogleFonts.poppins(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Book Title
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Book Title *',
                          prefixIcon: Icon(Icons.book),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the book title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Author
                      TextFormField(
                        controller: _authorController,
                        decoration: InputDecoration(
                          labelText: 'Author *',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the author name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Subject
                      TextFormField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          labelText: 'Subject *',
                          prefixIcon: Icon(Icons.subject),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the subject';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Series
                      TextFormField(
                        controller: _seriesController,
                        decoration: InputDecoration(
                          labelText: 'Series',
                          prefixIcon: Icon(Icons.library_books),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          hintText: 'Optional - Book series if applicable',
                        ),
                      ),
                      SizedBox(height: 20),

                      // Campus Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedCampus,
                        decoration: InputDecoration(
                          labelText: 'Campus *',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        items: _campusOptions.map((String campus) {
                          return DropdownMenuItem<String>(
                            value: campus,
                            child: Text(campus),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCampus = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a campus';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),

                      // Material Style Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedMaterialStyle,
                        decoration: InputDecoration(
                          labelText: 'Material Type *',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        items: _materialStyleOptions.map((String materialStyle) {
                          return DropdownMenuItem<String>(
                            value: materialStyle,
                            child: Text(materialStyle),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMaterialStyle = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a material type';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading ? null : _clearForm,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                side: BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Clear Form',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _addBook,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text('Adding Book...'),
                                      ],
                                    )
                                  : Text(
                                      'Add Book',
                                      style: TextStyle(
                                        fontSize: 16,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
