// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:video_editor/video_editor.dart';

import 'package:flutter_youtube_clone/cores/utility/methods.dart';
import 'package:flutter_youtube_clone/features/upload/short_video/page/short_video_detail_page.dart';
import 'package:flutter_youtube_clone/features/upload/short_video/widgets/trim_slinder.dart';

class UploadShortVideoPage extends StatefulWidget {
  final File video;
  const UploadShortVideoPage({super.key, required this.video});

  @override
  State<UploadShortVideoPage> createState() => _UploadShortVideoPageState();
}

class _UploadShortVideoPageState extends State<UploadShortVideoPage> {
  late VideoEditorController _videoEditorController;
  final isExporting = ValueNotifier(false);
  final exporingProgress = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _videoEditorController = VideoEditorController.file(
      widget.video,
      minDuration: const Duration(seconds: 3),
      maxDuration: const Duration(seconds: 10),
    );
    _videoEditorController
        .initialize(aspectRatio: 4 / 3.6)
        .then((_) => {setState(() {})});
  }

  @override
  void dispose() {
    super.dispose();
    _videoEditorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _videoEditorController.initialized
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blueGrey,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CropGridViewer.preview(
                      controller: _videoEditorController,
                    ),
                    const Spacer(),
                    MyTrimSlider(
                      controller: _videoEditorController,
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            await exportVideo();
                          },
                          child: const Text("Done"),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  Future<void> exportVideo() async {
    isExporting.value = true;
    final config = VideoFFmpegVideoEditorConfig(_videoEditorController);
    final execute = await config.getExecuteConfig();
    final String command = execute.command;
    debugPrint(command);
    FFmpegKit.executeAsync(
      command,
      (session) async {
        final ReturnCode? code = await session.getReturnCode();
        if (ReturnCode.isSuccess(code)) {
          isExporting.value = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShortVideoDetailPage(
                video: widget.video,
              ),
            ),
          );
        } else {
          showErrorSnackBar("Faild, video can't be exported", context);
        }
      },
      null,
      (status) {
        exporingProgress.value = config.getFFmpegProgress(
          status.getTime().toInt(),
        );
      },
    );
  }
}
