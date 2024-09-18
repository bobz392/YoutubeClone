import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/cores/utility/methods.dart';
import 'package:flutter_youtube_clone/cores/utility/types.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/repository/video_repository.dart';

class VideoDetailPage extends ConsumerStatefulWidget {
  final File video;
  const VideoDetailPage(this.video, {super.key});

  @override
  ConsumerState<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends ConsumerState<VideoDetailPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isThumbnailSelected = false;
  File? image;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Enter the title",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter the title",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Enter the description",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              TextField(
                maxLines: 5,
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Enter the description",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // select thumbnail
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(
                    Radius.circular(11),
                  ),
                ),
                child: TextButton(
                  child: const Text(
                    "SELECT THUMBNAIL",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  onPressed: () async {
                    // pick a image for thumbnail of a video.
                    image = await pickImage();
                    debugPrint("selected image -> $image ");
                    isThumbnailSelected = true;
                    setState(() {});
                  },
                ),
              ),
              isThumbnailSelected && image != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        image!,
                        cacheWidth: 400,
                        cacheHeight: 300,
                      ),
                    )
                  : const SizedBox(),
              isThumbnailSelected
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(11),
                        ),
                      ),
                      child: TextButton(
                        child: const Text(
                          "PUBLISH",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (image != null) {
                            String thumbnail = await putFileInStorage(
                              image,
                              const Uuid().v4(),
                              ResourceType.image.typeString(),
                            );
                            final videoId = const Uuid().v4();
                            String videoUrl = await putFileInStorage(
                              widget.video,
                              videoId,
                              ResourceType.video.typeString(),
                            );
                            ref.watch(longVideoProvider).uploadVideoToFirestore(
                                  videoUrl: videoUrl,
                                  thumbnail: thumbnail,
                                  title: titleController.text,
                                  videoId: videoId,
                                  datePublished: DateTime.now(),
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                );
                          }
                        },
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
