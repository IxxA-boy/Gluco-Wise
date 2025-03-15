/*
import 'package:flutter/material.dart';
import 'sign_in.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adaptive font sizing
    double calculateFontSize() {
      if (screenWidth > 1200) return 24.0; // Large screens
      if (screenWidth > 600) return 28.0; // Medium screens
      return 32.0; // Mobile screens
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset(
            'assets/images/image8.jpg',
            fit: BoxFit.cover,
          ),

          // Theme menu button in top-right corner
          Positioned(
            top: 40,
            right: 20,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white, size: 30),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'light',
                  child: Text('Light Theme'),
                ),
                const PopupMenuItem(
                  value: 'dark',
                  child: Text('Dark Theme'),
                ),
              ],
              onSelected: (value) {
                // Placeholder for theme change functionality
                // You would implement the actual theme switching here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value theme selected')),
                );
              },
            ),
          ),

          // Centered Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "High sugar levels can lead to serious complications;\n"
                      "Manage diabetes by monitoring your diet\n"
                      "Staying active..!\n"
                      "Stay healthy..!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: calculateFontSize(),
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Start Button at the bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200, // Fixed width for the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in.dart';
import 'theme_manager.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    var screenWidth = MediaQuery.of(context).size.width;

    double calculateFontSize() {
      if (screenWidth > 1200) return 24.0;
      if (screenWidth > 600) return 28.0;
      return 32.0;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image changes based on theme
          Image.asset(
            themeManager.isDarkMode
                ? 'assets/images/image3.jpg'
                : 'assets/images/image4.jpg',
            fit: BoxFit.cover,
            color: themeManager.isDarkMode
                ? Colors.black.withOpacity(0.7)
                : null,
            colorBlendMode: themeManager.isDarkMode
                ? BlendMode.darken
                : null,
          ),

          // Theme switcher
          Positioned(
            top: 40,
            right: 20,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                color: themeManager.isDarkMode ? Colors.white : Colors.black,
                size: 30,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'light',
                  child: Text('Light Theme'),
                ),
                PopupMenuItem(
                  value: 'dark',
                  child: Text('Dark Theme'),
                ),
              ],
              onSelected: (value) {
                themeManager.toggleTheme(value == 'dark');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$value theme selected')),
                );
              },
            ),
          ),

          // Centered Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: themeManager.isDarkMode
                      ? Colors.black.withOpacity(0.7)
                      : Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "High sugar levels can lead to serious complications;\n"
                      "Manage diabetes by monitoring your diet\n"
                      "Staying active..!\n"
                      "Stay healthy..!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: calculateFontSize(),
                    color: Colors.white,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Start Button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
