import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/view/dialog/add_edit_playlist_vc.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/playlist_widgets.dart';
import 'package:go_router/go_router.dart';

class SavePlaylistVC extends StatefulWidget {
  const SavePlaylistVC({super.key});

  @override
  State<SavePlaylistVC> createState() => _SavePlaylistVCState();
}

class _SavePlaylistVCState extends State<SavePlaylistVC> {
  int? selectedPlayList;

  void selectIndex(int? value) {
    setState(() {
      selectedPlayList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 450,
            minWidth: 350,
            maxHeight: MediaQuery.sizeOf(context).height / 1.3,
          ),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Save to playlist", style: AppTextStyle.title20()),
                  Expanded(child: Container(width: 10)),
                  InkWell(
                    onTap: context.pop,
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    child: Icon(Icons.close, color: AppColor.primary, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => PlayListTile(
                    onTap: selectIndex,
                    value: index,
                    selectedValue: selectedPlayList,
                    tileType: PlayListTileType.selection,
                  ),

                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemCount: 15,
                ),
              ),
              SizedBox(height: 30),
              AppButton(label: "Save", backgroundColor: AppColor.primary),
              SizedBox(height: 15),
              AppButton(
                label: "Create playlist",
                isFilled: false,
                backgroundColor: AppColor.gray,
                onTap: () {
                  context.pop();
                  showDialog(
                    context: context,
                    builder: (context) => AddEditPlaylistVC(),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
