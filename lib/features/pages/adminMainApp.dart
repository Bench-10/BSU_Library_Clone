import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../auth/login.dart';
import 'addBookPage.dart';
import 'borrowRequestsPage.dart';
import 'returnedBooksPage.dart';
import 'admin_dashboard_content.dart';

class AdminMainApp extends StatefulWidget {
  const AdminMainApp({super.key});

  @override
  State<AdminMainApp> createState() => _AdminMainAppState();
}

class _AdminMainAppState extends State<AdminMainApp> {
  int _selectedIndex = 0;
  
 
  static final List<Widget> _pages = <Widget>[
    AddBookPage(),
    AdminDashboardContent(),     
    BorrowRequestsPage(),
    ReturnedBooksPage(),
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildAppBar() {
    Map<String, dynamic>? userData = AuthService.currentUserData;
    String displayName = userData?['full_name'] ?? 'Admin';

    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      toolbarHeight: 90,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      flexibleSpace: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bsu-header.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(123, 6, 3, 3),
            ),
          ),
          Center(
            child: Container(
              height: 75,
              color: const Color.fromARGB(188, 185, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 10, 5, 10),
                        width: 60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/BatStateU-NEU-Logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BatStateU',
                            style: GoogleFonts.merriweather(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Library Admin',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    Map<String, dynamic>? userData = AuthService.currentUserData;
    String adminName = userData?['full_name'] ?? 'Admin';
    String adminEmail = userData?['email'] ?? 'admin@batstate-u.edu.ph';

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0)
        ),
      ),
      backgroundColor: Color(0xFF1E2125),
      child:Stack(
        children: [
          ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          DrawerHeader(
            child: Center(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 35,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 15),

                  Expanded(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(
                            adminName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            adminEmail,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                      ],

                    ) ,
                  )

                  
                  
                ],
              ),
            )
          ),
        
          ListTile(
            title: Text('Add Books',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            selected: _selectedIndex == 0,
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
            },
            contentPadding: EdgeInsets.fromLTRB(20, 7, 0, 7),
          ),

          ListTile(
            title: Text('Dashboard',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            selected: _selectedIndex == 1,
            onTap: () {
              _onItemTapped(1);
              Navigator.pop(context);
            },

            contentPadding: EdgeInsets.fromLTRB(20, 7, 0, 7),
          ),

          ListTile(
            title: Text('Borrow Requests',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            selected: _selectedIndex == 2,
            onTap: () {
              _onItemTapped(2);
              Navigator.pop(context);
            },

            contentPadding: EdgeInsets.fromLTRB(20, 7, 0, 7),
          ),

          ListTile(
            title: Text('Returned Books',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            selected: _selectedIndex == 3,
            onTap: () {
              _onItemTapped(3);
              Navigator.pop(context);
            },
            contentPadding: EdgeInsets.fromLTRB(20, 7, 0, 7),
          ),

          SizedBox(height: 13),

          SizedBox(
            height: 45,
            width: 100,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7)
              ),
              onPressed: () {
                  _showLogoutDialog();
              },
              backgroundColor: Colors.grey,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            ),
          ),

          SizedBox(height: 25),

      
        ],
      ),

          
        ],
      )
       
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), 
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), 
                )
              ),
              onPressed: () {
                AuthService.logoutUser();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text('Logout', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: _buildAppBar(),
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex]
    );
  }
}
