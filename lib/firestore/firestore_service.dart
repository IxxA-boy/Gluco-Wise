import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user ID or return null if not authenticated
  String? get currentUserId => _auth.currentUser?.uid;

  // Save product to Firestore with consistent field structure
  Future<void> saveProductToHistory(Map<String, dynamic> product) async {
    final userId = currentUserId;
    if (userId == null) return; // Ensure the user is logged in

    // Create a standardized product object with consistent field names
    final productData = {
      'name': product['product_name'],
      'sugarLevel': product['nutriments']?['sugars_100g'],
      'imageUrl': product['image_url'],
      'description': product['description'] ?? product['generic_name'] ?? '',
      'id': DateTime.now().millisecondsSinceEpoch.toString(), // Generate a unique ID
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Save the product to the user's history collection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .doc(productData['id'])
        .set(productData);
  }

  // Get product history as a stream
  Stream<List<Map<String, dynamic>>> getProductHistory() {
    final userId = currentUserId;
    if (userId == null) {
      // Return an empty stream if not logged in
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Ensure consistent ID field
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Delete a product from history
  Future<void> deleteProductFromHistory(String productId) async {
    final userId = currentUserId;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('products')
        .doc(productId)
        .delete();
  }
}
