import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter_youtube_clone/features/upload/short_video/model/short_video_model.dart';

class ShortVideoItem extends StatefulWidget {
  final ShortVideoModel shortVideoModel;
  const ShortVideoItem({super.key, required this.shortVideoModel});

  @override
  State<ShortVideoItem> createState() => _ShortVideoItemState();
}

class _ShortVideoItemState extends State<ShortVideoItem> {
  late VideoPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    _playerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.shortVideoModel.shortVideo))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            _playerController.value.isInitialized
                ? GestureDetector(
                    onTap: () {
                      if (!_playerController.value.isPlaying) {
                        _playerController.play();
                      } else {
                        _playerController.pause();
                      }
                    },
                    child: AspectRatio(
                      aspectRatio: _playerController.value.aspectRatio,
                      child: VideoPlayer(_playerController),
                    ),
                  )
                : const SizedBox(),
            Row(
              children: [
                const SizedBox(width: 20),
                Text(
                  widget.shortVideoModel.caption,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  timeago.format(
                    widget.shortVideoModel.datePublished,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            )
          ],
        ));
  }
}
