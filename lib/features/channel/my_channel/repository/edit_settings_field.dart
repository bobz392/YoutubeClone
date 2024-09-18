// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider
final editSettingsProvider = Provider((ref) {
  return EditSettingsField(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

// edit field
class EditSettingsField {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  EditSettingsField({
    required this.firestore,
    required this.auth,
  });

  editDisplayName(String displayName) async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "displayName": displayName,
    });
  }

  editUsername(String username) async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "username": username,
    });
  }

  editDescription(String description) async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update({
      "description": description,
    });
  }
}
