import 'package:flutter/material.dart';

import 'package:flutter_youtube_clone/cores/utility/my_color.dart';

// image button
class ImageButton extends StatelessWidget {
  final String name;
  const ImageButton({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
          backgroundColor: softBlueGreyBackGround,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(8),
          ))),
      onPressed: () {},
      icon: Image.asset(
        "assets/icons/$name.png",
        fit: BoxFit.cover,
        height: 24,
      ),
    );
  }
}

// text button
class FlatButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Color? backgroundColor;
  final double fontSize;
  const FlatButton({
    super.key,
    required this.callback,
    required this.text,
    this.fontSize = 16,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: callback,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.black,
            minimumSize: const Size.fromHeight(45),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            )),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}
