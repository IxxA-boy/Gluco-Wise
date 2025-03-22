import 'package:flutter/material.dart';
import 'functional_screen_one.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Show 10 recent foods
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              leading: const Icon(Icons.fastfood, color: Colors.green),
              title: Text(
                "Food Item ${index + 1}",
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: const Text(
                "Sugar: X grams",
                style: TextStyle(fontSize: 12),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Handle delete action
                },
              ),
            ),
          );
        },
      ),
    );
  }
}