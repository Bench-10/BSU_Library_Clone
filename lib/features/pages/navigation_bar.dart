import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './organizational_function.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF23272B),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 1200) {
            // Small screen: horizontally scrollable
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _buildNavItems(context),
              ),
            );
          } else {
            // Large screen: evenly spaced
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildNavItems(context),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    return [
      TextButton(onPressed: (){}, child: Text('Home', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500,) ,)),
      _NavBarDropdown(
        title: 'About',
        items: const [
          'Organizational Function',
          'Linkages',
          'News and Events',
          'Service Hours',
          'Constituent and Extension Libraries',
          'Goals and Objectives',
          'Information for Non-BatStateU Researchers',
        ],
        onSelected: (item) {
          if (item == 'Organizational Function') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrganizationalFunctionPage(),
              ),
            );
          } else {
            print('Selected: $item');
          }
        },
      ),
      _NavBarDropdown(
        title: 'Collections',
        items: const [
          'Filipiniana',
          'General References',
          'Graduate Studies',
          'Journals & Periodicals',
          'Local Governance Resource Center (LGRC)',
          'Undergradutate Studies',
          'Theses and Disseration Collection',
          'General Circulation',
          'Reserves Collection',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
      _NavBarDropdown(
        title: 'Online Resources',
        items: const [
          'Emerald Insight',
          'IEEE Xplore',
          'Philippine eLib',
          'PressReader',
          'ScienceDirect',
          'iGLibrary',
          'GALE ONEFILE CUSTOM 250',
          'Philippine Ebook Hub',
          'Philippine eJournals',
          'ProQuest Academic Research Library',
          'CD Asia',
          'Wiley Online Library',
          'Bibliotex Digital Library',
          'Perlego',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
      _NavBarDropdown(
        title: 'Services',
        items: const [
          'Chat ELVIRA',
          'Scanning Services',
          'BatStateU Library System',
          'Referral Letter',
          'Certification for Thesis submission',
          'Library Reservation',
          'Turnitin Similarity Checker',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
      _NavBarDropdown(
        title: 'Open Resources',
        items: const [
          'Digital Library & Institutional Repository',
          'Open Access eBooks',
          'Open Access eJournals',
          'Open Textbooks',
          'Reference Sources',
          'Digital Content Creation Tools',
          'Subject Webliographies',
          'Trial Databases',
          'Elibrary USA',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
      _NavBarDropdown(
        title: 'Research Support Tools',
        items: const [
          'Patent Search',
          'Open Theses/Dissertation',
          'The Open Citation Index',
          'Citation Management Tools',
          'Research and Collaboration Tools',
          'Western Pacific Region Index Medicus',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
      _NavBarDropdown(
        title: 'Links',
        items: const [
          'BatStateU Central',
          'Learning Resources',
          'Philippine Government Information and Resources',
          'Other Institutions Information & Resources',
          'BatStateU CHEST',
          'Cambridge Dictionary',
          'Merriam-webster Dictionary',
          'Oxford English Dictionary',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
      _NavBarDropdown(
        title: 'Help',
        items: const [
          'Get Started',
          'Library Orientation',
          'Library FAQs',
          'Outside Researcher',
        ],
        onSelected: (item) => print('Selected: $item'),
      ),
    ];
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavBarItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _NavBarDropdown extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const _NavBarDropdown({required this.title, required this.items, required this.onSelected});

  @override
  State<_NavBarDropdown> createState() => _NavBarDropdownState();
}

class _NavBarDropdownState extends State<_NavBarDropdown> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String item) {
        widget.onSelected(item);
      },
      itemBuilder: (BuildContext context) {
        return widget.items.map((String item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          );
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
} 