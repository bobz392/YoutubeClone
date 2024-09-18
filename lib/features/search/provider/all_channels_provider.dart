import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

final allChannelsProvider = Provider((ref) async {
  final userMaps = await FirebaseFirestore.instance.collection("users").get();
  return userMaps.docs
      .map((userMap) => UserModel.fromMap(userMap.data()))
      .toList();
});

final allVideosProvider = Provider((ref) async {
  final videoMaps = await FirebaseFirestore.instance.collection("videos").get();
  return videoMaps.docs
      .map((videoMap) => VideoModel.fromMap(videoMap.data()))
      .toList();
});
