import 'package:flutter/material.dart';
import 'functional_screen_two.dart'; // Import the next screen
import 'history_screen.dart'; // Import the history screen
import 'sign_in.dart'; // Import the sign-in screen
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication

class FunctionalScreenOne extends StatelessWidget {
  final String firstName; // First name passed from the sign-up screen

  const FunctionalScreenOne({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $firstName"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.black),
            onSelected: (value) {
              if (value == "history") {
                // Navigate to History Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              } else if (value == "contact_us") {
                // Handle Contact Us
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Contact Us option selected"),
                  ),
                );
              } else if (value == "logout") {
                _signOut(context); // Call the logout function
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "history",
                  child: Text("History"),
                ),
                const PopupMenuItem(
                  value: "contact_us",
                  child: Text("Contact Us"),
                ),
                const PopupMenuItem(
                  value: "logout",
                  child: Text("Logout"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Track a Food
            _buildOptionCard(
              context,
              "Track a Food",
              Icons.fastfood,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FunctionalScreenTwo(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Health Tips
            _buildOptionCard(
              context,
              "Health Tips",
              Icons.health_and_safety,
                  () {
                // Navigate to Health Tips screen
              },
            ),
            const SizedBox(height: 20),

            // Diabetic Checkups
            _buildOptionCard(
              context,
              "Diabetic Checkups",
              Icons.medical_services,
                  () {
                // Navigate to Diabetic Checkups screen
              },
            ),
            const SizedBox(height: 20),

            // Communicate with a Doctor
            _buildOptionCard(
              context,
              "Communicate with a Doctor",
              Icons.chat,
                  () {
                // Navigate to Communicate with a Doctor screen
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build option cards
  Widget _buildOptionCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.green),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle user logout
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out");

      // Navigate back to the SignInScreen after signing out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    } catch (e) {
      print("Failed to sign out: $e");
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to sign out: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}