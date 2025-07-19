import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login.dart';
import './activities.dart';
import './homePage.dart';
import './bookMark.dart';
import './onlineResourcesPage.dart';
import './accountSettingsPage.dart';
import '../../services/auth_service.dart';

class mainApp extends StatefulWidget {
  const mainApp({super.key});
  

  @override
  State<mainApp> createState() => _MyAppState();
}

class _MyAppState extends State<mainApp> { 
  Map<String, dynamic>? currentUser; 
  int selectedIndex = 0;
  int currentPageIndex = 0; 
  bool _isOnlineResourcesExpanded = false; 
  
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    currentUser = AuthService.currentUserData;
    pages = [
      HomePage(),
      MyActivityPage(),
      BookMarksPage(),
      OnlineResourcesPage(),
      AccountSettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 252),
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: pages[currentPageIndex], 
    );
  }

  // Build AppBar method
  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      toolbarHeight: 90,
      backgroundColor: Color.fromARGB(255, 185, 0, 0),
      flexibleSpace: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(55, 10, 15, 10),
          decoration: BoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/BatStateU-NEU-Logo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 7),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BatStateU',
                        style: GoogleFonts.merriweather(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Library',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentUser!['sr_code']?.toString() ?? 'N/A',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )
                  ),
                  Text(
                    currentUser!['full_name']?.toString() ?? 'USER NAME',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }


  Drawer _buildDrawer() {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0)
        ),
      ),
      backgroundColor: Color(0xFF1E2125),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red.shade100,
                        radius: 35,
                        child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.red,
                          ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser!['full_name']?.toString() ?? 'USER NAME',
                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w400),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 3),
                            Text(
                              currentUser!['email']?.toString() ?? 'EMAIL',
                              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ),
              SizedBox(height: 13),
              _buildDrawerItem('Home', 0),
              _buildDrawerItem('Borrowing Activity', 1),
              _buildDrawerItem('Bookmarks', 2),
              _buildExpandableOnlineResources(),
              _buildDrawerItem('Account Settings', 4),

              SizedBox(height: 13),

              SizedBox(
                  height: 45,
                  width: 100,
                  child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {

                    _showLogoutDialog();
                    
                  },
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
      ),
    );
  }

  Widget _buildDrawerItem(String title, int index) {
    return ListTile(
      selected: selectedIndex == index,
      selectedTileColor: const Color(0xFF2D3034),
      onTap: () {
        setState(() {
          selectedIndex = index;
          currentPageIndex = index; 
        });
        Navigator.pop(context);
      },
      contentPadding: EdgeInsets.fromLTRB(25, 7, 0, 7),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),
      ),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), 
                )
              ),
              onPressed: () {
                AuthService.logoutUser();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => Login(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              },
              child: Text('Logout', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExpandableOnlineResources() {
  final List<String> onlineResources = [
    'PressReader',
    'Emerald Insight',
    'IEEE Xplore',
    'iGLibrary',
    'BatStateU CHEST',
    'Elibrary USA',
    'ScienceDirect',
    'GALE ONEFILE CUSTOM 250',
    'Philippine Ebook Hub',
    'Philippine eJournals',
    'ProQuest Academic Research Library',
  ];

  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.fromLTRB(35, 7, 35, 7),
        title: Text(
          'Online Resources',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Icon(
          _isOnlineResourcesExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.white,
          size: 20,
        ),
        onTap: () {
          setState(() {
            _isOnlineResourcesExpanded = !_isOnlineResourcesExpanded;
          });
        },
      ),
      if (_isOnlineResourcesExpanded)
        ...onlineResources.map((resource) => 
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(70, 2, 0, 2),
            title: Text(
              resource,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              print('Selected: $resource');
              setState(() {
                selectedIndex = 3;
                currentPageIndex = 3;
              });
              Navigator.pop(context);
            },
          )
        ),
    ],
  );
}}


  



