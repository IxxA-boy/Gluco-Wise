import 'package:flutter/material.dart';
import 'firestore_service.dart';
/*import 'lib/firestore/firestore_service.dart';*/
import 'package:assesment/firestore/firestore_service.dart';

class HistoryScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

   HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product History'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getProductHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No product history found",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  leading: product['imageUrl'] != null
                      ? Image.network(
                    product['imageUrl'],
                    width: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported, color: Colors.grey);
                    },
                  )
                      : const Icon(Icons.inventory, color: Colors.blue),
                  title: Text(
                    product['name'] ?? 'Unnamed Product',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product['sugarLevel'] != null)
                        Text('Sugar: ${product['sugarLevel']}g/100g'),
                      if (product['description'] != null)
                        Text(product['description']),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        await _firestoreService.deleteProductFromHistory(product['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Product removed from history"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error deleting: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}