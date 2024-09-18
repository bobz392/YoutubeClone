import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/cores/widgets/bottom_navgation_bar.dart';
import 'package:flutter_youtube_clone/cores/widgets/error_page.dart';
import 'package:flutter_youtube_clone/cores/widgets/loader.dart';
import 'package:flutter_youtube_clone/features/account/account_page.dart';
import 'package:flutter_youtube_clone/features/auth/provider/user_provider.dart';
import 'package:flutter_youtube_clone/features/upload/widgets/upload_bottom_sheet.dart';
import 'package:flutter_youtube_clone/page_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/youtube.jpg",
                  height: 36,
                ),
                const SizedBox(width: 4),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: SizedBox(
                    height: 42,
                    child: IconButton(
                      icon: Image.asset("assets/icons/cast.png"),
                      onPressed: () {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: IconButton(
                    icon: Image.asset("assets/icons/notification.png"),
                    onPressed: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 12),
                  child: SizedBox(
                    height: 41.5,
                    child: IconButton(
                      icon: Image.asset("assets/icons/search.png"),
                      onPressed: () {},
                    ),
                  ),
                ),
                Consumer(builder: (context, ref, child) {
                  return ref.watch(currentUserProvider).when(
                      data: (currentUser) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AccountPage(
                                  user: currentUser,
                                );
                              }));
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(
                                currentUser.profilePic,
                              ),
                            ),
                          ),
                        );
                      },
                      error: (error, trace) => const ErrorPage(),
                      loading: () => const Loader());
                }),
                const SizedBox(width: 10)
              ],
            ),
            Expanded(
              child: pages[currentIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigation(
          onPressed: (index) {
            if (index != 2) {
              currentIndex = index;
              setState(() {});
            } else {
              showModalBottomSheet(
                context: context,
                builder: (context) => const CreateBottomSheet(),
              );
            }
          },
        ),
      ),
    );
  }
}
