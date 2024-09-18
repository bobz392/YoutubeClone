import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/cores/widgets/youtubu_buttons.dart';
import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';
import 'package:flutter_youtube_clone/features/channel/user_channel/subscrible_repository.dart';
import 'package:flutter_youtube_clone/features/channel/user_channel/user_channel_page.dart';

class SearchItem extends ConsumerWidget {
  final UserModel userModel;
  const SearchItem({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserChannelPage(userId: userModel.userId),
            ),
          );
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(
                userModel.profilePic,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.displayName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "@${userModel.username}",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  userModel.subscriptions.isNotEmpty
                      ? "${userModel.subscriptions.length} Subscriptions"
                      : "No Subscriptions",
                  style: const TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 40,
              width: 110,
              child: FlatButton(
                fontSize: 12,
                callback: () async {
                  await ref.watch(subscribeProvider).subscribeChannel(
                        subscriptions: userModel.subscriptions,
                        userId: userModel.userId,
                        currentUserId: FirebaseAuth.instance.currentUser!.uid,
                      );
                },
                text: "Subscrible",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
