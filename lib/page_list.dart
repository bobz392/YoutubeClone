import 'package:flutter/material.dart';
import 'package:flutter_youtube_clone/features/content/short_video/short_video_widget.dart';
import 'package:flutter_youtube_clone/features/content/widget/long_videos_widget.dart';
import 'package:flutter_youtube_clone/features/search/widget/search_widget.dart';

List pages = [
  const LongVideosWidget(),
  const ShortVideoWidget(),
  const Center(
    child: Text("Upload"),
  ),
  const SearchWidget(),
  const Center(
    child: Text("Logout"),
  ),
];
