import 'package:flutter/material.dart';

class OrganizationalFunctionPage extends StatelessWidget {
  const OrganizationalFunctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizational Function'),
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 900,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Organizational Function',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'The Batangas State University Library comprises three major service functions - the Collection Development and Cataloging Services, the Reference & Reader\'s Services, and the Computer & Internet Access Services.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Text(
                  'Collection Development and Cataloging Services',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'These services areas are responsible for the collection management of all library resources, from the selection, evaluation, acquisition, organization (classification, cataloging, etc.), mechanical processing, preservation of materials up to deselection/withdrawing of materials.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Text(
                  "Reader's Services",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "These services areas manage activities and operations related to attending the library user's reference queries, providing use and access to library materials/facilities/spaces, answering reference queries, and user education.\n\nSpecific functions include: lending of library materials; book renewals; course reserves; shelf management; patron notifications (overdue notices and fines); library orientation; current awareness (promotion of library resources); and managing booking reservation of spaces and facilities.\n\nThese services comprise different work areas/sections such as: Circulation Section; Periodical Section; Graduate Studies; and Theses Section.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 24),
                Text(
                  'Computer & Internet Access Services (E-Library)',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'The Library provides computer units to students to use either for computer related tasks and/or access to online resource materials. Students and faculty have free access to global information with the use of computers in the e-Library with stable internet connection.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 