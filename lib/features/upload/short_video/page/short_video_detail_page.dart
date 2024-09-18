import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/cores/widgets/youtubu_buttons.dart';
import 'package:flutter_youtube_clone/features/upload/short_video/repository/short_video_repository.dart';

class ShortVideoDetailPage extends ConsumerStatefulWidget {
  final File video;
  const ShortVideoDetailPage({super.key, required this.video});

  @override
  ConsumerState<ShortVideoDetailPage> createState() =>
      _ShortVideoDetailPageState();
}

class _ShortVideoDetailPageState extends ConsumerState<ShortVideoDetailPage> {
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Video Details",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _editingController,
                decoration: const InputDecoration(
                  hintText: "Write a caption...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              FlatButton(
                callback: () async {
                  await ref.watch(shortVideoProvider).addShortVideoToFirestore(
                        caption: _editingController.text,
                        shortVideo: widget.video.path,
                      );
                },
                text: "PUBLISH",
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
