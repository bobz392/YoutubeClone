import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';

import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';
import 'package:flutter_youtube_clone/features/channel/my_channel/repository/edit_settings_field.dart';
import 'package:flutter_youtube_clone/features/channel/widgets/settings_dialog.dart';
import 'package:flutter_youtube_clone/features/channel/widgets/settings_item.dart';

class MyChannelSettings extends ConsumerStatefulWidget {
  const MyChannelSettings({super.key});

  @override
  ConsumerState<MyChannelSettings> createState() => _MyChannelSettingsState();
}

class _MyChannelSettingsState extends ConsumerState<MyChannelSettings> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(currentUserProvider).when(
        data: (currentUser) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        child: SizedBox(
                          height: 170,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/images/flutter background.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 10,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: CachedNetworkImageProvider(
                              currentUser.profilePic),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 10,
                        child: Image.asset(
                          "assets/icons/camera.png",
                          height: 34,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // settings part
                  SettingsItem(
                    identifier: "Name",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          identifier: "DisplayName",
                          onSave: (name) {
                            ref
                                .watch(editSettingsProvider)
                                .editDisplayName(name);
                          },
                        ),
                      );
                    },
                    value: currentUser.displayName,
                  ),
                  const SizedBox(height: 14),
                  SettingsItem(
                    identifier: "Handle",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          identifier: "Username",
                          onSave: (name) {
                            ref.watch(editSettingsProvider).editUsername(name);
                          },
                        ),
                      );
                    },
                    value: currentUser.username,
                  ),
                  const SizedBox(height: 14),
                  SettingsItem(
                    identifier: "Description",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          identifier: "Description",
                          onSave: (description) {
                            ref
                                .watch(editSettingsProvider)
                                .editDescription(description);
                          },
                        ),
                      );
                    },
                    value: currentUser.displayName,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        const Text("Keep all my subscribers private"),
                        const Spacer(),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            isSwitched = value;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 14),
                    child: Text(
                      "Changes made on your names and profile pictures are visible only to Youtube and not other Google Services",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, trace) => const ErrorPage(),
        loading: () => const Loader());
  }
}
