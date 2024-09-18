// ignore: unnecessary_import
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_youtube_clone/features/channel/user_channel/subscrible_repository.dart';
import 'package:flutter_youtube_clone/features/content/comment/comment_provider.dart';
import 'package:flutter_youtube_clone/features/content/comment/comment_sheet.dart';
import 'package:flutter_youtube_clone/features/content/widget/post_item.dart';
import 'package:flutter_youtube_clone/features/content/widget/video_comment_widget.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/repository/video_repository.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter_youtube_clone/cores/utility/my_color.dart';
import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/cores/widgets/youtubu_buttons.dart';
import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';
import 'package:flutter_youtube_clone/features/content/widget/video_extra_button.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

class VideoPage extends ConsumerStatefulWidget {
  final VideoModel videoModel;
  const VideoPage({super.key, required this.videoModel});

  @override
  ConsumerState<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends ConsumerState<VideoPage> {
  bool isShowIcons = false;
  bool isPlaying = false;
  late VideoPlayerController _videoPlayerController;

  late VideoModel _latestVideoModel;

  @override
  void initState() {
    super.initState();

    _latestVideoModel = widget.videoModel;
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoModel.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fetchData = ref.watch(anyUserDataProvider(widget.videoModel.userId));
    final user = fetchData.whenData((user) => user);
    final maxRatio = (MediaQuery.sizeOf(context).width) / 276.0;
    final ratio = _videoPlayerController.value.aspectRatio >= maxRatio
        ? _videoPlayerController.value.aspectRatio
        : maxRatio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(276),
          child: _videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    toggleVideoPlayer();
                  },
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: ratio,
                        child: VideoPlayer(_videoPlayerController),
                      ),
                      isShowIcons
                          ? Positioned(
                              left: 170,
                              top: 92,
                              child: SizedBox(
                                height: 50,
                                child: Image.asset(
                                  "assets/images/play.png",
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      isShowIcons
                          ? Positioned(
                              right: 55,
                              top: 92,
                              child: GestureDetector(
                                onTap: () {
                                  _goForward();
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Image.asset(
                                    "assets/images/go ahead final.png",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      isShowIcons
                          ? Positioned(
                              left: 55,
                              top: 96,
                              child: GestureDetector(
                                onTap: () {
                                  _goBackward();
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Image.asset(
                                    "assets/images/go_back_final.png",
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 7.5,
                            child: VideoProgressIndicator(
                              _videoPlayerController,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(bottom: 150),
                  child: Loader(),
                ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5),
              child: Text(
                widget.videoModel.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.videoModel.views <= 0
                        ? "No view"
                        : "${widget.videoModel.views} views",
                    style: const TextStyle(
                      fontSize: 13.4,
                      color: Color(0xff5F5F5F),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 9,
                right: 9,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                      user.value?.profilePic ?? '',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.value?.displayName ?? "Unknown",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                          "${user.value?.subscriptions.length ?? 0} Subscriptions"),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: 140,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FlatButton(
                        text: "Subscribe",
                        callback: () async {
                          await ref.watch(subscribeProvider).subscribeChannel(
                                subscriptions: user.value!.subscriptions,
                                userId: user.value!.userId,
                                currentUserId:
                                    FirebaseAuth.instance.currentUser!.uid,
                              );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9, top: 10.5, right: 9),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: const BoxDecoration(
                        color: softBlueGreyBackGround,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("videos")
                            .where("videoId",
                                isEqualTo: widget.videoModel.videoId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          bool isLike = _latestVideoModel.likes
                              .contains(FirebaseAuth.instance.currentUser!.uid);
                          int length = _latestVideoModel.likes.length;
                          if (snapshot.hasData) {
                            final videoMaps = snapshot.data!.docs;
                            final video = videoMaps
                                .map(
                                  (video) => VideoModel.fromMap(video.data()),
                                )
                                .toList()
                                .firstOrNull;
                            if (video != null) {
                              isLike = video.likes.contains(
                                  FirebaseAuth.instance.currentUser!.uid);
                              length = video.likes.length;
                              _latestVideoModel = video;
                            }
                          }
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  debugPrint('like video');
                                  _likeVideo();
                                },
                                child: Icon(
                                  Icons.thumb_up,
                                  color:
                                      isLike ? Colors.redAccent : Colors.black,
                                  size: 15.5,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text("$length"),
                              const SizedBox(width: 15),
                              const Icon(
                                Icons.thumb_down,
                                size: 15.5,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Share",
                        iconData: Icons.share,
                      ),
                    ),
                    const VideoExtraButton(
                      text: "Remix",
                      iconData: Icons.analytics_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Download",
                        iconData: Icons.download,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // comment box
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return CommentSheet(widget.videoModel);
                    });
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 174, 174, 135),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Consumer(builder: (context, ref, child) {
                  final asyncComments = ref.watch(
                    commentsProvider(widget.videoModel.videoId),
                  );
                  final comments = asyncComments.value;
                  if (comments == null || comments.isEmpty) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VideoCommentWidget(
                      comments: comments,
                      user: user.value!,
                    ),
                  );
                }),
              ),
            ),
            // recommandated video
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("videos")
                    .where("videoId", isNotEqualTo: widget.videoModel.videoId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const ErrorPage();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Loader();
                  }

                  final videosMap = snapshot.data!.docs;
                  final videos = videosMap
                      .map(
                        (video) => VideoModel.fromMap(video.data()),
                      )
                      .toList();
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return PostItem(
                        videoModel: videos[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void toggleVideoPlayer() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      isPlaying = false;
      isShowIcons = true;
    } else {
      _videoPlayerController.play();
      isPlaying = true;
      isShowIcons = false;
    }

    setState(() {});
  }

  void _goBackward() {
    Duration position = _videoPlayerController.value.position;
    position = position - const Duration(seconds: 1);
    _videoPlayerController.seekTo(position);
  }

  void _goForward() {
    Duration position = _videoPlayerController.value.position;
    position = position + const Duration(seconds: 1);
    _videoPlayerController.seekTo(position);
  }

  void _likeVideo() async {
    print(_latestVideoModel.likes);
    await ref.watch(longVideoProvider).likeVideo(
          likes: _latestVideoModel.likes,
          videoId: _latestVideoModel.videoId,
          currentUserId: FirebaseAuth.instance.currentUser!.uid,
        );
  }
}
