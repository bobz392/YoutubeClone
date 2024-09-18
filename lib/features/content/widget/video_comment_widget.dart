import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';
import 'package:flutter_youtube_clone/features/upload/comment/comment_model.dart';

class VideoCommentWidget extends StatelessWidget {
  final List<CommentModel> comments;
  final UserModel user;
  const VideoCommentWidget({
    super.key,
    required this.comments,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Comments",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 5),
            Text("${comments.length}"),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7.5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                  user.profilePic,
                ),
              ),
              const SizedBox(width: 7),
              SizedBox(
                width: 280,
                child: Text(
                  comments[0].commentText,
                  maxLines: 2,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
