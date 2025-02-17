import 'package:flutter/material.dart';
import 'type_for_food.dart'; // Import the next screen
import 'functional_screen_one.dart';

class FunctionalScreenTwo extends StatelessWidget {
  const FunctionalScreenTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track a Food"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Type
            _buildOptionCard(
              context,
              "Type",
              Icons.keyboard,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TypeForFood(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Capture an Image
            _buildOptionCard(
              context,
              "Capture an Image",
              Icons.camera_alt,
                  () {
                // Navigate to Capture Image screen
              },
            ),
            const SizedBox(height: 20),

            // Scan QR Code
            _buildOptionCard(
              context,
              "Scan QR Code",
              Icons.qr_code,
                  () {
                // Navigate to Scan QR Code screen
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
}