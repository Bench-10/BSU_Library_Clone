/*
FIREBASE DATA STRUCTURE FOR YOUR LIBRARY SYSTEM

Collection Name: "book_details"

=== Sample Document 1 ===
Document ID: (auto-generated or custom)
{
  "title": "Introduction to Programming",
  "author": "John Smith",
  "subject": "Computer Science", 
  "campus": "Main Campus",
  "material_type": "Books",
  "series": "Programming Fundamentals Series",
  "isbn": "978-0123456789",
  "publisher": "Tech Publications",
  "year": 2023,
  "available": true,
  "copies": 5,
  "location": "CS Section - Shelf A1"
}

=== Sample Document 2 ===
{
  "title": "Data Structures and Algorithms",
  "author": "Jane Doe",
  "subject": "Computer Science",
  "campus": "Lipa Campus", 
  "material_type": "Books",
  "series": "Advanced Programming Series",
  "isbn": "978-0987654321",
  "publisher": "Academic Press",
  "year": 2022,
  "available": false,
  "copies": 3,
  "location": "CS Section - Shelf B2"
}

=== Sample Document 3 ===
{
  "title": "Research Methods in Education",
  "author": "Dr. Maria Santos",
  "subject": "Education",
  "campus": "Main Campus",
  "material_type": "Thesis",
  "series": "Educational Research Series", 
  "isbn": "978-1234567890",
  "publisher": "Educational Press",
  "year": 2021,
  "available": true,
  "copies": 2,
  "location": "Education Section - Shelf C1"
}

=== Sample Document 4 ===
{
  "title": "Digital Marketing Trends",
  "author": "Business Weekly",
  "subject": "Business",
  "campus": "Malvar Campus",
  "material_type": "Magazines",
  "series": "Business Insights Magazine",
  "isbn": "N/A",
  "publisher": "Business Media Corp",
  "year": 2024,
  "available": true,
  "copies": 10,
  "location": "Periodicals Section"
}

HOW TO ADD THIS DATA TO FIREBASE:

1. Go to Firebase Console (https://console.firebase.google.com)
2. Select your project: library-database-40fb6
3. Go to Firestore Database
4. Click "Start collection"
5. Collection ID: "book_details"
6. Add documents with the above structure

FIELD NAMES TO USE:
- title (string)
- author (string) 
- subject (string)
- campus (string)
- material_type (string)
- series (string)
- isbn (string)
- publisher (string)
- year (number)
- available (boolean)
- copies (number)
- location (string)

*/
