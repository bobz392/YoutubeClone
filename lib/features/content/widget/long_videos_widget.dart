import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/features/content/widget/post_item.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

class LongVideosWidget extends StatelessWidget {
  const LongVideosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("videos").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const ErrorPage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else {
              final videoMaps = snapshot.data!.docs;
              final videoModels = videoMaps
                  .map((videoMap) => VideoModel.fromMap(videoMap.data()))
                  .toList();
              return ListView.builder(
                itemCount: videoModels.length,
                itemBuilder: (context, index) {
                  return PostItem(videoModel: videoModels[index]);
                },
              );
            }
          }),
    );
  }
}
