import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:focus_tube_flutter/const/app_image.dart';

class NetworkImageClass extends StatefulWidget {
  const NetworkImageClass({
    super.key,
    this.image,
    this.placeHolder = AppImage.placeHolder,
    this.borderRadius,
    this.boxFit = BoxFit.cover,
    this.width,
    this.height,
    this.keepAlive = false,
    this.aspectRatio,
    this.shadow = const [],
    this.shape = BoxShape.rectangle,
    this.border,
  });
  final dynamic image;
  final String placeHolder;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit boxFit;
  final double? width;
  final double? height;
  final List<BoxShadow> shadow;
  final BoxShape shape;
  final bool keepAlive;
  final Border? border;
  final double? aspectRatio;
  @override
  State<NetworkImageClass> createState() => _NetworkImageClassState();
}

class _NetworkImageClassState extends State<NetworkImageClass>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    child() {
      if (widget.image == null) {
        return commonContainer(AssetImage(widget.placeHolder));
      } else if (widget.image is Uint8List) {
        return commonContainer(MemoryImage(widget.image));
      } else if (kIsWeb ? false : (widget.image is io.File)) {
        return commonContainer(FileImage(widget.image));
      } else {
        return CachedNetworkImage(
          imageUrl: widget.image,
          height: widget.height,
          width: widget.width,

          imageBuilder: (context, imageProvider) {
            return commonContainer(imageProvider);
          },
          errorWidget: (context, url, error) {
            return commonContainer(AssetImage(widget.placeHolder));
          },
          progressIndicatorBuilder: (context, url, progress) {
            return commonContainer(AssetImage(widget.placeHolder));
          },
        );
      }
    }

    if (widget.aspectRatio != null) {
      return AspectRatio(aspectRatio: widget.aspectRatio!, child: child());
    } else {
      return child();
    }
  }

  Widget commonContainer(ImageProvider child) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: widget.border,
        boxShadow: widget.shadow,
        image: DecorationImage(image: child, fit: widget.boxFit),
        shape: widget.shape,
        borderRadius:
            (widget.shape == BoxShape.circle) || widget.borderRadius == null
            ? null
            : widget.borderRadius!,
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
