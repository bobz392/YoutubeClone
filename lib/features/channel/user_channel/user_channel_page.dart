import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/cores/widgets/youtubu_buttons.dart';
import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';
import 'package:flutter_youtube_clone/features/channel/provider/each_channel_videos_provider.dart';
import 'package:flutter_youtube_clone/features/content/widget/post_item.dart';

class UserChannelPage extends StatefulWidget {
  final String userId;
  const UserChannelPage({super.key, required this.userId});

  @override
  State<UserChannelPage> createState() => _UserChannelPageState();
}

class _UserChannelPageState extends State<UserChannelPage> {
  bool haveVideos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                child: Consumer(
                  builder: (context, ref, child) => ref
                      .watch(anyUserDataProvider(widget.userId))
                      .when(
                        data: (user) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 170,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Image.asset(
                                        "assets/images/flutter background.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 10,
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: IconButton.outlined(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  CircleAvatar(
                                    radius: 38,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: CachedNetworkImageProvider(
                                      user.profilePic,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.displayName,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "@${user.username}",
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${user.subscriptions.length} subscriptions, ",
                                            ),
                                            TextSpan(
                                              text: "${user.videos} videos",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 8, right: 8),
                                child: FlatButton(
                                  callback: () {},
                                  text: "SUBSCRIBLE",
                                ),
                              ),
                            ],
                          );
                        },
                        error: (error, trace) => const ErrorPage(),
                        loading: () => const Loader(),
                      ),
                ),
              ),
              // video consumer widget
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    return ref
                        .watch(eachChannelVideosProvider(widget.userId))
                        .when(
                          data: (videos) => Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GridView.builder(
                              itemCount: videos.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                if (videos.isNotEmpty) {
                                  return PostPreviewItem(
                                    videoModel: videos[index],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ),
                          error: (error, trace) => const ErrorPage(),
                          loading: () => const Loader(),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
