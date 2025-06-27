import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  final String email;
  final String dateOfBirth;

  const ProfilePage({super.key, 
    required this.username,
    required this.email,
    required this.dateOfBirth,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 20.0, // Adjust size if needed
            fontWeight: FontWeight.bold, // Set text style to bold
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Change the color of the back button to black
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.teal,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  username,
                  style: GoogleFonts.silkscreen(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold, // Set text style to bold
                    color: Colors.teal,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 10.0),
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: Colors.teal,
                    ),
                    title: Text(
                      'Date of Birth',
                      style: GoogleFonts.roboto(
                        color: Colors.teal,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      dateOfBirth,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.teal,
                    ),
                    title: Text(
                      'Email',
                      style: GoogleFonts.roboto(
                        color: Colors.teal,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      email,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
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
