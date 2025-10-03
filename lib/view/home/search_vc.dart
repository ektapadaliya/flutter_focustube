import 'package:flutter/cupertino.dart';
import 'package:focus_tube_flutter/widget/screen_background.dart';

class SearchVC extends StatefulWidget {
  static const id = "/search";
  const SearchVC({super.key});

  @override
  State<SearchVC> createState() => _SearchVCState();
}

class _SearchVCState extends State<SearchVC> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(body: Container());
  }
}
