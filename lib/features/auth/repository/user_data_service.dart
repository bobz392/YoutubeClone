import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';

// provider
final userDataServiceProvider = Provider((ref) {
  return UserDataService(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

// service
class UserDataService {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  UserDataService({
    required this.auth,
    required this.firestore,
  });

  addUserDataToFireStore({
    required String displayName,
    required String username,
    required String email,
    required String profilePic,
    // required List subscriptions,
    // required int videos,
    // required String userId,
    required String description,
    // required String type,
  }) async {
    final userId = auth.currentUser!.uid;
    UserModel user = UserModel(
      displayName: displayName,
      username: username,
      email: email,
      profilePic: profilePic,
      subscriptions: [],
      videos: 0,
      userId: userId,
      description: description,
      type: "user",
    );

    await firestore.collection("users").doc(userId).set(user.toMap());
  }

  Future<UserModel> fetchCurrentUserData() async {
    final userId = auth.currentUser!.uid;
    final userMap = await firestore.collection("users").doc(userId).get();
    return UserModel.fromMap(userMap.data()!);
  }

  Future<UserModel> fetchAnyUserData(String userId) async {
    final userMap = await firestore.collection("users").doc(userId).get();
    return UserModel.fromMap(userMap.data()!);
  }
}
