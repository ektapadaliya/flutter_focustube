import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

import '../../widget/app_bar.dart';
import '../dialog/add_edit_playlist_vc.dart';

class PlaylistVC extends StatefulWidget {
  static const id = "/playlist";
  const PlaylistVC({super.key});

  @override
  State<PlaylistVC> createState() => _PlaylistVCState();
}

class _PlaylistVCState extends State<PlaylistVC> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(
        context,
        centerTitle: true,
        title: "Playlists",
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddEditPlaylistVC(),
                );
              },
              child: Icon(Icons.add, size: 25, color: AppColor.primary),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 15),

        child: Column(
          children: [
            AppTextFormField(
              hintText: "Search here...",
              controller: searchController,
              prefixIcon: Image.asset(AppImage.search, height: 35),
              radius: 6,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => PlayListTile(
                  onTap: (_) {
                    playListDetail.go(context, id: index.toString());
                  },
                  value: index,
                ),
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
