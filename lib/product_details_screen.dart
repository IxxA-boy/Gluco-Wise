import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assesment/firestore/firestore_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic product; // The selected product
  final FirestoreService _firestoreService = FirestoreService();

  ProductDetailsScreen({super.key, required this.product});

  // Function to save the product to Firestore and SharedPreferences
  Future<void> _saveProductToFirestore(BuildContext context) async {
    try {
      // Save to Firestore using the FirestoreService
      await _firestoreService.saveProductToHistory(product);

      // Save the product name to SharedPreferences for search history
      final prefs = await SharedPreferences.getInstance();
      List<String> searchHistory = prefs.getStringList('searchHistory') ?? [];
      if (!searchHistory.contains(product['product_name'])) {
        searchHistory.add(product['product_name']);
        await prefs.setStringList('searchHistory', searchHistory);
      }

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product saved successfully!"),
        ),
      );
    } catch (e) {
      // Show error message if saving fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            if (product['image_url'] != null)
              Center(
                child: Image.network(
                  product['image_url'],
                  width: 150,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported, size: 150, color: Colors.grey);
                  },
                ),
              ),
            const SizedBox(height: 20),
            // Product Name
            Text(
              product['product_name'] ?? "Unknown Product",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Sugar Level
            Text(
              "Sugar: ${product['nutriments']?['sugars_100g'] ?? "N/A"} g per 100g",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () => _saveProductToFirestore(context),
                child: const Text("Save Product"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}