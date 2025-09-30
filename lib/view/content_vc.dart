import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/expandable_scollview.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class ContentVC extends StatefulWidget {
  const ContentVC({super.key, required this.type});
  static const screenId = '/content';
  final String type;

  @override
  State<ContentVC> createState() => _ContentVCState();
}

class _ContentVCState extends State<ContentVC> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBar: customAppBar(
        context,
        title: widget.type == "t" ? "Terms & Conditions" : "Privacy Policy",
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        minimum: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: _contentTile(index + 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _contentTile(index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$index. Lorem ipsum", style: AppTextStyle.title20),
        Text(
          "Lorem ipsum dolor sit amet consectetur. Sed commodo est tempus purus element in amet nunc mauris sit volutpat sed sollicit udin. Scelerisque mauris lectus purus dui porttitor eget pretium.",
          style: AppTextStyle.body18.copyWith(color: AppColor.gray),
        ),
      ],
    );
  }
}
