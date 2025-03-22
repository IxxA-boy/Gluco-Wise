import 'package:flutter/material.dart';
import 'sign_in.dart'; // Import the third screen file

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true, // Always show the vertical scrollbar
        child: SingleChildScrollView(
          child: SizedBox(
            // Use a SizedBox to ensure the content can overflow
            height: MediaQuery.of(context).size.height , // Slightly larger than screen height
            child: Stack(
              children: [
                // Full-screen background image
                Container(
                  width: MediaQuery.of(context).size.width, // Match screen width
                  height: MediaQuery.of(context).size.height * 1.2, // Slightly larger than screen height
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image8.jpg'), // Use your asset image
                      fit: BoxFit.cover, // Ensure the image covers the entire screen
                    ),
                  ),
                ),

                // Back button at the top-left
                Positioned(
                  top: 50,
                  left: 15,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Quote above the "Next" button
                Positioned(
                  bottom: 300, // Adjust this value to position the quote
                  left: 24,
                  child: const Text(
                    "High sugar levels can lead to serious complications;\nmanage diabetes by monitoring your diet \nStaying active..!\nStay healthy..!",
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 2.2,
                    ),
                  ),
                ),

                // "Next" button at the bottom-left
                Positioned(
                  bottom: 40, // Adjust this value to position the button
                  left: 24,
                  child: SizedBox(
                    width: 200, // Adjust the width of the button
                    height: 50, // Adjust the height of the button
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to the third screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                      child: const Text(
                        "Start",
                        style: TextStyle(fontSize: 18, color: Colors.white),
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