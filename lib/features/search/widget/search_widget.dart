import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_clone/cores/widgets/custom_button.dart';
import 'package:flutter_youtube_clone/features/auth/model/user_model.dart';
import 'package:flutter_youtube_clone/features/content/widget/post_item.dart';
import 'package:flutter_youtube_clone/features/search/provider/all_channels_provider.dart';
import 'package:flutter_youtube_clone/features/search/widget/search_item.dart';
import 'package:flutter_youtube_clone/features/upload/long_video/model/video_model.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final TextEditingController _editingController = TextEditingController();
  List foundItems = [];

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  onFieldSubmitted: (value) async {
                    await filterList(value);
                  },
                  controller: _editingController,
                  decoration: const InputDecoration(
                    hintText: "Search Your Tube",
                    hintStyle: TextStyle(height: 1),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 65,
              height: 34,
              child: CustomButton(
                iconData: Icons.search,
                onTap: () async {
                  await filterList(_editingController.text);
                },
                haveColor: true,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: foundItems.length,
                itemBuilder: (context, index) {
                  final item = foundItems[index];
                  if (item is UserModel) {
                    return SearchItem(userModel: item);
                  } else if (item is VideoModel) {
                    return PostItem(videoModel: item);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> filterList(String keyword) async {
    List<UserModel> users = await ref.watch(allChannelsProvider);
    List<VideoModel> videos = await ref.watch(allVideosProvider);
    final foundUsers = users.where((user) {
      return user.displayName.toLowerCase().contains(keyword);
    }).toList();

    final foundVideos = videos.where((video) {
      return video.title.toLowerCase().contains(keyword);
    });

    List result = [];
    result.addAll(foundUsers);
    result.addAll(foundVideos);
    setState(() {
      result.shuffle();
      foundItems = result;
      debugPrint(foundItems.toString());
    });
  }
}
