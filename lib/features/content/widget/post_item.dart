import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';
import 'package:flutter_youtube_clone/features/content/page/video_page.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

class PostItem extends ConsumerWidget {
  final VideoModel videoModel;
  const PostItem({super.key, required this.videoModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchUser = ref.watch(anyUserDataProvider(videoModel.userId));
    final user = fetchUser.whenData((user) => user);
    return GestureDetector(
      onTap: () {
        debugPrint('tap');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPage(
              videoModel: videoModel,
            ),
          ),
        );
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: videoModel.thumbnail,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage:
                    CachedNetworkImageProvider(user.value?.profilePic ?? ''),
              ),
              const SizedBox(width: 10),
              Text(videoModel.title),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 50),
              Text(
                user.value?.displayName ?? "Unknown",
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  videoModel.views <= 0 ? "No View" : "${videoModel.views}",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const Text(
                "a moment ago",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostPreviewItem extends ConsumerWidget {
  final VideoModel videoModel;
  const PostPreviewItem({super.key, required this.videoModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPage(
              videoModel: videoModel,
            ),
          ),
        );
        FirebaseFirestore.instance
            .collection("videos")
            .doc(videoModel.videoId)
            .update(
          {"view": FieldValue.increment(1)},
        );
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: videoModel.thumbnail,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 10),
              Text(videoModel.title),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  videoModel.views <= 0 ? "No View, " : "${videoModel.views}, ",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              const Text(
                "a moment ago",
                style: TextStyle(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
