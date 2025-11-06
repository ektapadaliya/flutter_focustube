import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/view/dialog/add_edit_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:focus_tube_flutter/widget/video_widgets.dart';

class PlayListDetailVC extends StatefulWidget {
  static const id = "/detail/:id";
  const PlayListDetailVC({super.key, required this.playListId});
  final String playListId;
  @override
  State<PlayListDetailVC> createState() => _PlayListDetailVCState();
}

class _PlayListDetailVCState extends State<PlayListDetailVC> {
  List videos = List.generate(10, (index) => index + 1);
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Playlist Library"),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Column(
          children: [
            PlayListTile(
              onTap: (_) {
                showDialog(
                  context: context,
                  builder: (context) => AddEditPlaylistVC(
                    playlist:
                        "PlayList ${(int.tryParse(widget.playListId) ?? 0) + 1}",
                  ),
                );
              },
              value: int.tryParse(widget.playListId) ?? 0,
              tileType: PlayListTileType.edit,
            ),
            SizedBox(height: 20),
            AppTitle(title: "Videos"),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => VideoTile(
                  isSlidable: true,
                  onRemoved: () {
                    videos.removeAt(index);
                    setState(() {});
                  },
                ),
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: videos.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
