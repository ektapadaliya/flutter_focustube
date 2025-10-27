import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_image.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class NoteListVC extends StatefulWidget {
  static const id = "/notes";
  const NoteListVC({super.key});

  @override
  State<NoteListVC> createState() => _NoteListVCState();
}

class _NoteListVCState extends State<NoteListVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(context, title: "Timestamped Notes"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNote.go(context);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(100),
          side: BorderSide(color: AppColor.primary),
        ),
        backgroundColor: AppColor.primary,
        child: Icon(Icons.add, size: 25, color: AppColor.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: ListView.separated(
          itemBuilder: (context, index) => NoteTile(),
          separatorBuilder: (context, index) =>
              Divider(color: AppColor.primary.opacityToAlpha(.3), height: 25),
          itemCount: 30,
        ),
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  const NoteTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        detailsNote.go(context, id: '1');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "The Industrial Revolution",
                  style: AppTextStyle.title20(),
                ),
              ),
              SizedBox(width: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppImage.calendarIcon),
                  SizedBox(width: 3),
                  Text(
                    "26 Apr 2024",
                    style: AppTextStyle.body12(color: AppColor.gray),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3),
          Text(
            "Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore ... ",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.body14(color: AppColor.gray),
          ),
        ],
      ),
    );
  }
}
