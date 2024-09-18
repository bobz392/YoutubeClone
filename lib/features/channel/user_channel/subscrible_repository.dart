import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscribeProvider = Provider((ref) {
  return Subscribe(firestore: FirebaseFirestore.instance);
});

class Subscribe {
  final FirebaseFirestore firestore;

  Subscribe({
    required this.firestore,
  });

  Future<void> subscribeChannel({
    required List<String> subscriptions,
    required String userId,
    required String currentUserId,
  }) async {
    if (subscriptions.contains(currentUserId)) {
      firestore.collection("users").doc(userId).update({
        "subscriptions": FieldValue.arrayRemove([currentUserId])
      });
    } else {
      firestore.collection("users").doc(userId).update({
        "subscriptions": FieldValue.arrayUnion([currentUserId])
      });
    }
  }
}
