import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/controller/app_controller.dart';
import 'package:focus_tube_flutter/model/content_model.dart';
import 'package:focus_tube_flutter/widget/app_bar.dart';
import 'package:focus_tube_flutter/widget/app_loader.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentVC extends StatefulWidget {
  const ContentVC({super.key, required this.slug});
  static const id = '/content';
  final String slug;

  @override
  State<ContentVC> createState() => _ContentVCState();
}

class _ContentVCState extends State<ContentVC> {
  LoaderController loaderController = controller<LoaderController>(
    tag: "/content",
  );
  ContentModel? content;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      loaderController.setLoading(true);
      content = await ApiFunctions.instance.pages(context, slug: widget.slug);
      loaderController.setLoading(false);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      loaderController: loaderController,
      child: ScreenBackground(
        appBar: customAppBar(context, title: content?.title),
        body: content == null
            ? const SizedBox.shrink()
            : SafeArea(
                maintainBottomViewPadding: true,
                minimum: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: SingleChildScrollView(
                  child: Html(
                    data: content!.content,
                    onAnchorTap:
                        (String? url, Map<String, String> attributes, element) {
                          if (url != null) {
                            launchUrl(Uri.parse(url));
                          }
                        },
                    onLinkTap:
                        (String? url, Map<String, String> attributes, element) {
                          if (url != null) {
                            launchUrl(Uri.parse(url));
                          }
                        },
                  ),
                ),
              ),
      ),
    );
  }
}
