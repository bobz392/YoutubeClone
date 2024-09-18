import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/features/upload/short_video/model/short_video_model.dart';

// Provider
final shortVideoProvider = Provider((ref) {
  return ShortVideoRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

// Repository
class ShortVideoRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  ShortVideoRepository({
    required this.auth,
    required this.firestore,
  });

  Future<void> addShortVideoToFirestore({
    required String caption,
    required String shortVideo,
  }) async {
    final ShortVideoModel model = ShortVideoModel(
      caption: caption,
      userId: auth.currentUser?.uid ?? "unknown",
      shortVideo: shortVideo,
      datePublished: DateTime.now(),
    );
    await FirebaseFirestore.instance.collection("shorts").add(model.toMap());
  }
}
