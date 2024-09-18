import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/features/upload/comment/comment_model.dart';

// Provider
final commentProvider = Provider((ref) {
  return CommentRepository(firestore: FirebaseFirestore.instance);
});

// Repository
class CommentRepository {
  final FirebaseFirestore firestore;

  CommentRepository({
    required this.firestore,
  });

  Future<void> uploadCommentToFirestore({
    required String commentText,
    required String videoId,
    required String displayName,
    required String profilePic,
  }) async {
    final commentId = const Uuid().v4();
    final commentModel = CommentModel(
      commentText: commentText,
      videoId: videoId,
      commmentId: commentId,
      displayName: displayName,
      profilePic: profilePic,
    );
    await firestore
        .collection("comments")
        .doc(commentId)
        .set(commentModel.toMap());
  }
}
