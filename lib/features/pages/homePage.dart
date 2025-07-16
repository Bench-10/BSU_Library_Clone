import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});
  

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  String? selectedCampus;
  String? selectedMaterialType;
  String? selectedOption;
  
  final List<String> campuses = [
    'Main Campus',
    'Lipa Campus',
    'Nasugbu Campus',
    'Malvar Campus',
    'Lemery Campus',
  ];
  
  final List<String> materialTypes = [
    'Books',
    'Journals',
    'Thesis',
    'Research Papers',
    'Magazines',
    'Digital Resources',
  ];

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

          Container(
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
                                    value: material,
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

                          SizedBox(height: 40,),


                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(140, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),   
                                ),
                                backgroundColor: Colors.red, 
                                foregroundColor: Colors.white,  
                              ),
                              onPressed: () => {
                                setState(() {
                                  
                                  
                                })
                              },
                              child: Text(
                                'Search',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )
                                ,
                              ),
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