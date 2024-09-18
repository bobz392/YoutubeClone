// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/cores/utility/types.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

// Provider
final longVideoProvider = Provider((ref) => VideoRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

// Repository
class VideoRepository {
  FirebaseFirestore firestore;
  FirebaseAuth auth;
  VideoRepository({
    required this.firestore,
    required this.auth,
  });

  uploadVideoToFirestore({
    required String videoUrl,
    required String thumbnail,
    required String title,
    required String videoId,
    required DateTime datePublished,
    required String userId,
  }) async {
    VideoModel video = VideoModel(
      videoUrl: videoUrl,
      thumbnail: thumbnail,
      title: title,
      datePublished: datePublished,
      views: 0,
      videoId: videoId,
      userId: userId,
      likes: [],
      type: ResourceType.video.typeString(),
    );
    await firestore.collection("videos").doc(videoId).set(video.toMap());
  }

  Future<void> likeVideo({
    required List<String> likes,
    required String videoId,
    required String currentUserId,
  }) async {
    if (likes.contains(currentUserId)) {
      await firestore.collection("videos").doc(videoId).update({
        "likes": FieldValue.arrayRemove([currentUserId]),
      });
    } else {
      await firestore.collection("videos").doc(videoId).update({
        "likes": FieldValue.arrayUnion([currentUserId]),
      });
    }
  }
}
