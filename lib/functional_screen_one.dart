import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'dart:convert'; // For JSON parsing
import 'history_screen.dart';
import 'sign_in.dart'; // Import the sign-in screen
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication

class FunctionalScreenOne extends StatefulWidget {
  final String firstName; // First name passed from the sign-up screen

  const FunctionalScreenOne({super.key, required this.firstName});

  @override
  _FunctionalScreenOneState createState() => _FunctionalScreenOneState();
}

class _FunctionalScreenOneState extends State<FunctionalScreenOne> {
  final TextEditingController _foodController = TextEditingController();
  String _sugarContent = ""; // To store the sugar content
  bool _isLoading = false; // To show a loading indicator

  // Function to fetch sugar content from the API
  Future<void> _fetchSugarContent(String foodName) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Construct the API URL
      final String apiUrl =
          "https://world.openfoodfacts.org/cgi/search.pl?search_terms=$foodName&search_simple=1&json=1";

      // Make the HTTP GET request
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];

        if (products.isNotEmpty) {
          // Get the first product's sugar content per 100g
          final Map<String, dynamic> firstProduct = products[0];
          final Map<String, dynamic> nutriments = firstProduct['nutriments'];

          if (nutriments.containsKey('sugars_100g')) {
            final double sugarPer100g = nutriments['sugars_100g'];
            setState(() {
              _sugarContent = "$sugarPer100g g per 100g";
            });
          } else {
            setState(() {
              _sugarContent = "Sugar content not available";
            });
          }
        } else {
          setState(() {
            _sugarContent = "No products found";
          });
        }
      } else {
        setState(() {
          _sugarContent = "Failed to fetch data";
        });
      }
    } catch (e) {
      setState(() {
        _sugarContent = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menu Button in Upper Right Corner
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.green),
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
                    // Handle contact us
                  } else if (value == "logout") {
                    // Call the _signOut method
                    _signOut(context);
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
            ),

            // Greeting Message with Dynamic First Name
            Text(
              "Hi, ${widget.firstName}", // Display the first name
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Food Input Field
            TextField(
              controller: _foodController,
              decoration: InputDecoration(
                hintText: "Type a food...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.green),
                  onPressed: () {
                    // Fetch sugar content when the search button is pressed
                    if (_foodController.text.isNotEmpty) {
                      _fetchSugarContent(_foodController.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sugar Amount Display in a White Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: _isLoading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : Text(
                _sugarContent.isEmpty
                    ? "Sugar Amount: [Search for a food]"
                    : "Sugar Amount: $_sugarContent",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}