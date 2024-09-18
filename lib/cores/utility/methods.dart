import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_youtube_clone/features/upload/long_video/pages/video_detail_page.dart';
import 'package:flutter_youtube_clone/features/upload/short_video/page/upload_short_video_page.dart';

Future pickVideo(BuildContext context) async {
  final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (file != null) {
    File video = File(file.path);
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VideoDetailPage(video);
    }));
  }
}

Future pickShortVideo(BuildContext context) async {
  final file = await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (file != null) {
    File video = File(file.path);
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UploadShortVideoPage(video: video);
    }));
  }
}

Future pickImage() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file != null) {
    return File(file.path);
  }
  return null;
}

Future<String> putFileInStorage(file, number, fileType) async {
  final ref = FirebaseStorage.instance.ref().child("$fileType/$number");
  final upload = ref.putFile(file);
  final snapshot = await upload;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

void showErrorSnackBar(String message, context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
