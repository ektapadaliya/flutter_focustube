import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class VideoListVC extends StatefulWidget {
  static const id = "/videos";
  const VideoListVC({super.key, required this.title});
  final String title;
  @override
  State<VideoListVC> createState() => _VideoListVCState();
}

class _VideoListVCState extends State<VideoListVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: widget.title),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: ListView.separated(
          itemBuilder: (context, index) => VideoTile(),
          separatorBuilder: (context, index) => SizedBox(height: 15),
          itemCount: 10,
        ),
      ),
    );
  }
}
