import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/book_service.dart';
import './searchPage.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  String? selectedCampus;
  String? selectedMaterialType;
  String? selectedOption;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  
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
    'Books',
    'Journals',
    'Thesis',
    'Research Papers',
    'Magazines',
    'Digital Resources',
  ];

  // Perform search based on selected criteria
  Future<void> _performSearch() async {
    String searchQuery = _searchController.text.trim();
    bool hasSearchQuery = searchQuery.isNotEmpty;
    bool hasSearchType = selectedOption != null;
    bool hasCampus = selectedCampus != null;
    bool hasMaterialType = selectedMaterialType != null;

    // Validation logic according to requirements:
    // 1. If there is text in Find field, user must select at least one search type
    if (hasSearchQuery && !hasSearchType) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a search type (Title, Author, Subject, or Series) when entering search text')),
      );
      return;
    }

    // 2. If user selects search type, Find field must not be empty
    if (hasSearchType && !hasSearchQuery) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter search text when a search type is selected')),
      );
      return;
    }

    // 3. At least one filter must be selected (either Find+Type combination OR Campus OR Material)
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
      
      // Get all books for case-insensitive filtering
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

      // Apply case-insensitive campus filter if selected
      if (hasCampus) {
        results = results.where((book) => 
          book['campus']?.toString().toLowerCase().contains(selectedCampus!.toLowerCase()) == true
        ).toList();
      }

      // Apply case-insensitive material type filter if selected  
      if (hasMaterialType) {
        results = results.where((book) =>
          book['material_type']?.toString().toLowerCase().contains(selectedMaterialType!.toLowerCase()) == true
        ).toList();
      }

      setState(() {
        searchResults = results;
        isLoading = false;
      });

      // Navigate to SearchPage with search results
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
              searchResults: searchResults,
              searchQuery: searchQuery,
              searchType: selectedOption ?? 'Filter Only',
              selectedCampus: selectedCampus,
              selectedMaterialType: selectedMaterialType,
            ),
          ),
        );
      }

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

  void _clearFields() async {
     _searchController.clear();
     setState(() {
      selectedCampus = null;
      selectedMaterialType = null;
      selectedOption = null;

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
                Icon(Icons.home, size: 30, color: Colors.red),

                Text(
                  'Home',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                )

              ],
            ),
          ),

          SizedBox(height: 35),

          Container(
            padding: EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Column(
                children: [
                  Container(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid,
                          
                          
                        )
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find:',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ),
                              ),

                              SizedBox(height: 5,),

                              TextField(
                                controller: _searchController,
                                style: GoogleFonts.poppins(

                                ),

                                decoration: InputDecoration(
                                  hintText: 'Type here',
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  )
                                )
                                
                                
                                
                              )

                              
                            ],
                          ),

                          SizedBox(height: 15,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Campus',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ),
                              ),

                              SizedBox(height: 5,),

                              DropdownButtonFormField<String>(
                                value: selectedCampus,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                hint: Text(
                                  'Select Campus',
                                  style: GoogleFonts.poppins(color: Colors.grey),
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
                              )

                              
                            ],
                          ),

                          SizedBox(height: 15,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Material Type:',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ),
                              ),

                              SizedBox(height: 5,),

                              DropdownButtonFormField<String>(
                                value: selectedMaterialType,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                                hint: Text(
                                  'Select Material',
                                  style: GoogleFonts.poppins(color: Colors.grey),
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
                              )


                              
                            ],
                          ),

                          SizedBox(height: 30,),
                          

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      
                                      style: ElevatedButton.styleFrom(
                                        
                                        fixedSize: Size(140, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),  
                                        ),
                                        backgroundColor: selectedOption == 'Title' ? Colors.red : Colors.white, 
                                        foregroundColor: selectedOption == 'Title' ? Colors.white : Colors.black, 
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          selectedOption = 'Title';
                                          
                                        })
                                      },
                                      child: Text(
                                        'Title'
                                      ),
                                    ),

                                    SizedBox(height: 25,),

                                    ElevatedButton(
                                      
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(140, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),  
                                        ),

                                        backgroundColor: selectedOption == 'Subject' ? Colors.red : Colors.white, 
                                        foregroundColor: selectedOption == 'Subject' ? Colors.white : Colors.black, 
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          selectedOption = 'Subject';
                                          
                                        })
                                      },
                                      child: Text(
                                        'Subject'
                                      ),
                                    )

                                  ],
                                ),


                                SizedBox(width: 30,),

                                //SECOND RADIO
                                Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(140, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),  
                                        ),
                                        backgroundColor: selectedOption == 'Author' ? Colors.red : Colors.white, 
                                        foregroundColor: selectedOption == 'Author' ? Colors.white : Colors.black, 
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          selectedOption = 'Author';
                                          
                                        })
                                      },
                                      child: Text(
                                        'Author'
                                      ),
                                    ),

                                    SizedBox(height: 25,),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(140, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),   
                                        ),
                                        backgroundColor: selectedOption == 'Series' ? Colors.red : Colors.white, 
                                        foregroundColor: selectedOption == 'Series' ? Colors.white : Colors.black,  
                                      ),
                                      onPressed: () => {
                                        setState(() {
                                          selectedOption = 'Series';
                                          
                                        })
                                      },
                                      child: Text(
                                        'Series'
                                      ),
                                    )
                                    
                                  ],
                                )
                                
                              ],
                            ),
                          ),

                          SizedBox(height: 20,),


                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),   
                                ),
                                backgroundColor: Colors.red, 
                                foregroundColor: Colors.white,  
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
                                      Text(
                                        'Searching...',
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Search',
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                            ),
                          ),


                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),   
                                ),
                                backgroundColor: const Color.fromARGB(255, 234, 234, 234), 
                                foregroundColor: const Color.fromARGB(255, 53, 53, 53),  
                              ),

                              child: Text('Clear Form'),
                              onPressed: (){
                                _clearFields();

                              }
                            ),

                          )

                          

                        ],
                      ),
                    ),
                  ),
                  

                ],
            )
          ),

          

        ],
      ),

    );
          
  
  }
}





