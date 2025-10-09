import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:go_router/go_router.dart';

class AddEditPlaylistVC extends StatefulWidget {
  const AddEditPlaylistVC({super.key, this.playlist});
  final String? playlist;
  @override
  State<AddEditPlaylistVC> createState() => _AddEditPlaylistVCState();
}

class _AddEditPlaylistVCState extends State<AddEditPlaylistVC> {
  late TextEditingController playListNameController;
  @override
  void initState() {
    playListNameController = TextEditingController(text: widget.playlist);
    super.initState();
  }

  @override
  void dispose() {
    playListNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(maxWidth: 450, minWidth: 350),
          margin: EdgeInsets.symmetric(horizontal: 30).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom == 0
                ? 30
                : MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  Text(
                    widget.playlist != null
                        ? "Rename playlist"
                        : "Create playlist",
                    style: AppTextStyle.title20(),
                  ),
                  Expanded(child: Container(width: 10)),
                  InkWell(
                    onTap: context.pop,
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    child: Icon(Icons.close, color: AppColor.primary, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 40),
              AppTextFormField(
                label: "Playlist",
                hintText: "Enter name",
                controller: playListNameController,
              ),
              SizedBox(height: 40),
              AppButton(
                label: widget.playlist != null ? "Change" : "Create",
                backgroundColor: AppColor.primary,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
