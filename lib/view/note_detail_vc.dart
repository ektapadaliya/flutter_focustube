import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class NoteDetailVC extends StatefulWidget {
  static const addId = "/add";
  static const detailId = "/detail/:id";
  const NoteDetailVC({super.key, this.id});
  final String? id;
  @override
  State<NoteDetailVC> createState() => _NoteDetailVCState();
}

class _NoteDetailVCState extends State<NoteDetailVC> {
  bool get isAdd => widget.id == null;
  TextEditingController titleCotroller = TextEditingController();
  TextEditingController descriptionCotroller = TextEditingController();

  @override
  void initState() {
    if (!isAdd) {
      titleCotroller.text =
          "Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore";
      descriptionCotroller.text =
          "Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore Lorem ipsum dolor sit amet consectetur cursus aliquam orci maecenas Lore";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(
        context,
        title: isAdd ? "Add note" : "Note",
        actions: [
          if (!isAdd)
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Icon(Icons.delete_outlined, color: AppColor.primary),
            ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAdd)
              TextFormField(
                cursorColor: AppColor.primary,
                style: AppTextStyle.title20(),
                readOnly: !isAdd,
                controller: titleCotroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: AppTextStyle.title20(color: AppColor.gray),
                ),
              )
            else
              Text(titleCotroller.text, style: AppTextStyle.title20()),
            Divider(color: AppColor.primary.opacityToAlpha(.3), height: 25),
            Expanded(
              child: isAdd
                  ? TextField(
                      style: AppTextStyle.title16(color: AppColor.gray),
                      controller: descriptionCotroller,
                      readOnly: !isAdd,
                      maxLines: null, // allows multi-line text
                      expands: true, // makes it fill all available space
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Description",
                        hintStyle: AppTextStyle.title16(color: AppColor.gray),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Text(
                        descriptionCotroller.text,
                        style: AppTextStyle.title16(color: AppColor.gray),
                      ),
                    ),
            ),
            SizedBox(height: 20),
            AppButton(label: "Done", backgroundColor: AppColor.primary),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
