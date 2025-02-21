import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_details_screen.dart'; // Import the product details screen

class TypeForFood extends StatefulWidget {
  const TypeForFood({super.key});

  @override
  _TypeFoodScreenState createState() => _TypeFoodScreenState();
}

class _TypeFoodScreenState extends State<TypeForFood> {
  final TextEditingController _foodController = TextEditingController();
  List<dynamic> _products = []; // To store products from the API
  bool _isLoading = false; // To show a loading indicator

  // Function to fetch products from the API
  Future<void> _fetchProducts(String foodName) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Construct the API URL
      final String apiUrl =
          "https://world.openfoodfacts.org/cgi/search.pl?search_terms=$foodName&search_simple=1&json=1&page_size=10";

      // Make the HTTP GET request with a timeout
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _products = data['products']; // Store the products
        });
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Type a Food"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _foodController,
              decoration: InputDecoration(
                hintText: "Type a food...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.green),
                  onPressed: () {
                    if (_foodController.text.isNotEmpty) {
                      _fetchProducts(_foodController.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display Products
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    leading: product['image_url'] != null
                        ? Image.network(product['image_url'], width: 50, height: 50)
                        : const Icon(Icons.fastfood),
                    title: Text(product['product_name'] ?? "Unknown Product"),
                    subtitle: Text(
                      product['nutriments']?['sugars_100g'] != null
                          ? "${product['nutriments']['sugars_100g']} g per 100g"
                          : "Sugar content not available",
                    ),
                    onTap: () {
                      // Navigate to ProductDetailsScreen with the selected product
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}