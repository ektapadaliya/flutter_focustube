import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/app_text_form_field.dart';
import 'package:go_router/go_router.dart';

class AddEditGroupListVC extends StatefulWidget {
  const AddEditGroupListVC({super.key, this.group});
  final String? group;
  @override
  State<AddEditGroupListVC> createState() => _AddEditGroupListVCState();
}

class _AddEditGroupListVCState extends State<AddEditGroupListVC> {
  late TextEditingController groupListNameController;
  @override
  void initState() {
    groupListNameController = TextEditingController(text: widget.group);
    super.initState();
  }

  @override
  void dispose() {
    groupListNameController.dispose();
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
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.group != null ? "Rename Group" : "Create Group",
                      style: AppTextStyle.title20(),
                    ),
                    Expanded(child: Container(width: 10)),
                    AppInkWell(
                      onTap: context.pop,
                      child: Icon(
                        Icons.close,
                        color: AppColor.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                AppTextFormField(
                  label: "Group",
                  hintText: "Enter name",
                  controller: groupListNameController,
                ),
                SizedBox(height: 40),
                AppButton(
                  label: widget.group != null ? "Change" : "Create",
                  backgroundColor: AppColor.primary,
                  onTap: () {
                    Navigator.of(context).pop(
                      groupListNameController.text.trim().isEmpty
                          ? null
                          : groupListNameController.text.trim(),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
