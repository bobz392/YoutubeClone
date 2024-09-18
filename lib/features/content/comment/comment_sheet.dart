import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';
import 'package:flutter_youtube_clone/features/content/comment/comment_title_widget.dart';
import 'package:flutter_youtube_clone/features/upload/comment/comment_model.dart';
import 'package:flutter_youtube_clone/features/upload/comment/comment_repository.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

class CommentSheet extends ConsumerStatefulWidget {
  final VideoModel videoModel;
  const CommentSheet(this.videoModel, {super.key});

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchUser = ref.watch(anyUserDataProvider(widget.videoModel.userId));
    final user = fetchUser.whenData((user) => user);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Comments",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
          ),
          child: const Text(
            "Remember to keep comments respectful and follow our community guide.",
          ),
        ),
        // Comments
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("comments")
              .where(
                "videoId",
                isEqualTo: widget.videoModel.videoId,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const ErrorPage();
            }
            final commentMap = snapshot.data!.docs;
            final comments = commentMap
                .map((cmap) => CommentModel.fromMap(cmap.data()))
                .toList();
            return Expanded(
              child: ListView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return CommentTitleWidget(commentModel: comments[index]);
                },
              ),
            );
          },
        ),
        // Input
        Row(
          children: [
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 45,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "Add a comment",
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () async {
                await ref.watch(commentProvider).uploadCommentToFirestore(
                      commentText: _controller.value.text,
                      videoId: widget.videoModel.videoId,
                      displayName: user.value?.displayName ?? "",
                      profilePic: user.value?.profilePic ?? "",
                    );
              },
              icon: const Icon(
                Icons.send,
                color: Colors.green,
                size: 35,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
