import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/controller/loader_cotroller.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:focus_tube_flutter/widget/app_tost_message.dart';
import 'package:focus_tube_flutter/widget/general_dialog.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:go_router/go_router.dart';

class NoteDetailVC extends StatefulWidget {
  static const addId = "/add/:id";
  static const detailId = "/detail/:id";
  const NoteDetailVC({super.key, required this.id, this.isAdd = false});
  final String id;
  final bool isAdd;
  @override
  State<NoteDetailVC> createState() => _NoteDetailVCState();
}

class _NoteDetailVCState extends State<NoteDetailVC> {
  TextEditingController titleCotroller = TextEditingController();
  TextEditingController descriptionCotroller = TextEditingController();

  @override
  void initState() {
    if (!widget.isAdd) {
      var note = controller<NoteController>().notes
          .where((e) => e.id?.toString() == widget.id)
          .firstOrNull;
      titleCotroller.text = note?.title ?? "";
      descriptionCotroller.text = note?.description ?? "";
    }
    super.initState();
  }

  LoaderController loaderController = controller<LoaderController>(
    tag: "note-add-edit",
  );
  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(
          context,
          title: widget.isAdd ? "Add note" : "Note",
          actions: [
            if (!widget.isAdd)
              InkWell(
                onTap: () async {
                  var value = await generalDialog(
                    context,
                    title: "Delete note?",
                    message: "Are you sure you want to delete this note?",
                    onSubmit: () {
                      context.pop(true);
                    },
                    submitText: "Delete",
                    submitColor: AppColor.red,
                  );
                  if (value == true) {
                    deleteNote();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 30),
                  child: Icon(Icons.delete_outlined, color: AppColor.primary),
                ),
              ),
          ],
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isAdd)
                TextFormField(
                  cursorColor: AppColor.primary,
                  style: AppTextStyle.title20(),

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
                child: TextField(
                  style: AppTextStyle.title16(color: AppColor.gray),
                  controller: descriptionCotroller,

                  maxLines: null, // allows multi-line text
                  expands: true, // makes it fill all available space
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Description",
                    hintStyle: AppTextStyle.title16(color: AppColor.gray),
                  ),
                ),
              ),
              SizedBox(height: 20),
              AppButton(
                label: "Done",
                backgroundColor: AppColor.primary,
                onTap: addEditNotes,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void addEditNotes() async {
    loaderController.setLoading(true);
    if (titleCotroller.text.trim().isEmpty) {
      AppTostMessage.snackBarMessage(
        context,
        message: "Please enter title",
        isError: true,
      );
    } else if (descriptionCotroller.text.trim().isEmpty) {
      AppTostMessage.snackBarMessage(
        context,
        message: "Please enter description",
        isError: true,
      );
    } else {
      await ApiFunctions.instance.noteCreateEdit(
        context,
        title: titleCotroller.text.trim(),
        description: descriptionCotroller.text.trim(),
        id: widget.id,
        isAdd: widget.isAdd,
      );
      context.pop();
    }
    loaderController.setLoading(false);
  }

  void deleteNote() async {
    loaderController.setLoading(true);
    await ApiFunctions.instance.noteDelete(context, id: widget.id);
    context.pop();
    loaderController.setLoading(false);
  }
}
