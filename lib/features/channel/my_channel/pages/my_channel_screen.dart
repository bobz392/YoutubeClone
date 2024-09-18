import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/cores/utility/my_color.dart';
import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/youtubu_buttons.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';
import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';

class MyChannelScreen extends ConsumerWidget {
  const MyChannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentUserProvider).when(
          data: (currentUser) {
            return DefaultTabController(
              length: 7,
              child: Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ChannelTopHeaderWidget(
                          user: currentUser,
                        ),
                        const Text("More about this channel"),
                        // operations, such as manage your videos
                        const ChannelOperationsWidget(),
                        const SizedBox(height: 10),
                        // tabs
                        const ChannelTabbarWidget(),
                        // contents
                        const ChannelTabViewWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, trace) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}

// Channel Top Header widget
class ChannelTopHeaderWidget extends StatelessWidget {
  final UserModel user;
  const ChannelTopHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(
              user.profilePic,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 4),
          child: Text(
            user.displayName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.blueGrey,
              ),
              children: [
                TextSpan(text: "@${user.username}  "),
                TextSpan(text: "${user.subscriptions.length} subscriptions  "),
                TextSpan(text: "${user.videos} videos  "),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Channel Tabbar widget
class ChannelTabbarWidget extends StatelessWidget {
  const ChannelTabbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      isScrollable: true,
      labelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.only(top: 12),
      tabs: [
        Text("Home"),
        Text("Videos"),
        Text("Shorts"),
        Text("Comunity"),
        Text("Playlists"),
        Text("Channels"),
        Text("About"),
      ],
    );
  }
}

// Channel Tab View widget
class ChannelTabViewWidget extends StatelessWidget {
  const ChannelTabViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: TabBarView(
        children: [
          Center(
            child: Text("Home"),
          ),
          Center(
            child: Text("Videos"),
          ),
          Center(
            child: Text("Shorts"),
          ),
          Center(
            child: Text("Comunity"),
          ),
          Center(
            child: Text("Playlists"),
          ),
          Center(
            child: Text("Channels"),
          ),
          Center(
            child: Text("About"),
          ),
        ],
      ),
    );
  }
}

// Channel Operations Widget
class ChannelOperationsWidget extends StatelessWidget {
  const ChannelOperationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 41,
              margin: const EdgeInsets.only(left: 10, right: 5),
              decoration: const BoxDecoration(
                color: softBlueGreyBackGround,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Manage Videos",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: ImageButton(name: "pen"),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 10),
              child: ImageButton(name: "time-watched"),
            ),
          ),
        ],
      ),
    );
  }
}
