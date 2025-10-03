import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpandedSingleChildScrollView extends StatelessWidget {
  Widget child;
  ScrollPhysics? physics;
  ScrollController? controller;
  EdgeInsets? padding;
  bool reverse;
  ExpandedSingleChildScrollView({
    super.key,
    required this.child,
    this.physics,
    this.controller,
    this.reverse = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return SingleChildScrollView(
          controller: controller,
          reverse: reverse,
          physics: physics,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constrains.maxHeight),
            child: IntrinsicHeight(
              child: Container(padding: padding, child: child),
            ),
          ),
        );
      },
    );
  }
}
