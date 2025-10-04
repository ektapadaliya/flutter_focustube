// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focus_tube_flutter/const/app_color.dart';

class AppPopupOverlay<T> extends StatefulWidget {
  const AppPopupOverlay({
    super.key,
    required this.child,
    required this.items,
    required this.itemBuilder,
    required this.onItemPressed,
  });
  final Widget child;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final void Function(T item) onItemPressed;
  @override
  _AppPopupOverlayState<T> createState() => _AppPopupOverlayState<T>();
}

class _AppPopupOverlayState<T> extends State<AppPopupOverlay<T>> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleAppPopupOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Remove overlay when background is tapped
          _toggleAppPopupOverlay();
        },
        child: Stack(
          children: [
            Positioned(
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(-117, 40),
                child: Material(
                  elevation: 2,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          border: BoxBorder.all(color: AppColor.lightGray),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            widget.items.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                top: (index != 0) ? 12 : 0,
                                bottom: (index != widget.items.length - 1)
                                    ? 12
                                    : 0,
                              ),
                              child: InkWell(
                                overlayColor: WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
                                onTap: () {
                                  widget.onItemPressed(widget.items[index]);
                                  _toggleAppPopupOverlay();
                                },
                                child: widget.itemBuilder(widget.items[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 11,
                        top: -10.5,
                        child: Transform.rotate(
                          angle: (pi / 4),
                          child: Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColor.lightGray),
                                left: BorderSide(color: AppColor.lightGray),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: InkWell(
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        onTap: _toggleAppPopupOverlay,
        child: widget.child,
      ),
    );
  }
}
