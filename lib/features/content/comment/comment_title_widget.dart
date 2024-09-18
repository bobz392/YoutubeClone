import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/features/upload/comment/comment_model.dart';

class CommentTitleWidget extends StatelessWidget {
  final CommentModel commentModel;
  const CommentTitleWidget({super.key, required this.commentModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey,
              backgroundImage:
                  CachedNetworkImageProvider(commentModel.profilePic),
            ),
            const SizedBox(width: 8),
            Text(
              commentModel.displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "a moment ago",
              style: TextStyle(
                color: Colors.blueGrey,
              ),
            ),
            const Spacer(),
            const Icon(Icons.more_vert),
            const SizedBox(width: 5),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45, right: 15),
          child: Text(commentModel.commentText),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}
