import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

// provider
final eachChannelVideosProvider = FutureProvider.family((ref, userId) async {
  final videosMap = await FirebaseFirestore.instance
      .collection("videos")
      .where("userId", isEqualTo: userId)
      .get();

  return videosMap.docs
      .map(
        (video) => VideoModel.fromMap(video.data()),
      )
      .toList();
});
