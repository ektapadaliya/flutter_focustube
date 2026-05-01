import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/widget/app_button.dart';
import 'package:focus_tube_flutter/widget/groplist_widget.dart';
import 'package:go_router/go_router.dart';

import '../../const/app_color.dart';
import '../../const/app_text_style.dart';

class SaveGroplistVC extends StatefulWidget {
  const SaveGroplistVC({super.key});
  @override
  State<SaveGroplistVC> createState() => _SaveGroplistVCState();
}

class _SaveGroplistVCState extends State<SaveGroplistVC> {
  ScrollController scrollController = ScrollController();
  String? selectedId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("Save to group", style: AppTextStyle.title20()),
                  Expanded(child: Container(width: 10)),
                  AppInkWell(
                    onTap: context.pop,

                    child: Icon(Icons.close, color: AppColor.primary, size: 20),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => GropListTile(
                    onTap: (value) {
                      selectedId = value;
                      setState(() {});
                    },
                    value: index.toString(),
                    isSelected: selectedId == index.toString(),
                  ),

                  separatorBuilder: (context, index) => SizedBox(height: 15),
                  itemCount: 5,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: "Save",
                      backgroundColor: AppColor.primary,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),

              /*   SizedBox(height: 15),
                    AppButton(
                      label: "Create playlist",
                      isFilled: false,
                      backgroundColor: AppColor.primary,
                      onTap: () {
                        context.pop();
                        showDialog(
                          context: context,
                          builder: (context) => AddEditPlaylistVC(),
                        );
                      },
                    ), */
            ],
          ),
        ),
      ),
    );
  }
}
