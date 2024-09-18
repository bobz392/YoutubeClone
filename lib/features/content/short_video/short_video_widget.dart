import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/features/content/widget/short_video_item.dart';
import 'package:flutter_youtube_clone/features/upload/short_video/model/short_video_model.dart';

class ShortVideoWidget extends StatelessWidget {
  const ShortVideoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("shorts").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return const ErrorPage();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            final shortVideoMaps = snapshot.data!.docs;
            final shortVideos = shortVideoMaps
                .map(
                  (shortMap) => ShortVideoModel.fromMap(shortMap.data()),
                )
                .toList();
            return ListView.builder(
              itemCount: shortVideos.length,
              itemBuilder: (context, index) {
                return ShortVideoItem(shortVideoModel: shortVideos[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
