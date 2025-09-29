// ignore_for_file: use_build_context_synchronously

import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:focus_tube_flutter/const/app_color.dart';
import 'package:focus_tube_flutter/const/app_const.dart';
import 'package:focus_tube_flutter/const/app_text_style.dart';
import 'package:focus_tube_flutter/widget/general_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as path;

class ImageService {
  static Future<bool> getPermisssion(
    context,
    Permission permission, {
    String? message,
    required String title,
  }) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus status = await permission.request();
      if (!status.isGranted) {
        generalDialog(
          context,
          submitText: "Settings",
          onSubmit: () {
            openAppSettings();
          },
          title: "$title Permission",
          message:
              "${AppConst.appName} requires your ${permission.toString().split("Permission.").last} permission to $message",
        );
      }
      return status.isGranted;
    }
  }

  static Future<CroppedFile?> cropImage(context, String imagePath) async {
    CroppedFile? file = await ImageCropper().cropImage(
      compressQuality: 95,
      aspectRatio: null,
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          toolbarTitle: "Crop Image",
          toolbarColor: const Color(0xFF20232C),
          activeControlsWidgetColor: AppColor.black,
          toolbarWidgetColor: AppColor.black,
          statusBarColor: AppColor.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          aspectRatioLockEnabled: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        WebUiSettings(context: context),
      ],
    );
    if (file != null) {
      return file;
    }
    return null;
  }

  static Future<dynamic> pickImage(
    BuildContext context, {

    String cameraPermissionMessage =
        "capture an image to use as your profile picture",
    String photosPermissionMessage =
        "upload an image to use as your profile picture",
  }) async {
    int? result;
    if (kIsWeb) {
      result = 1;
    } else {
      result = await showCupertinoModalPopup<int>(
        context: context,
        builder: (context1) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Camera", style: AppTextStyle.body16),
                onPressed: () {
                  context.pop(0);
                },
              ),
              CupertinoActionSheetAction(
                child: Text("Photos", style: AppTextStyle.body16),
                onPressed: () {
                  context.pop(1);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                context.pop();
              },
              child: Text(
                "Cancel",
                style: AppTextStyle.body16.copyWith(color: Colors.red),
              ),
            ),
          );
        },
      );
    }
    if (result != null) {
      XFile? pickedImage;
      if (result == 0 &&
          (await getPermisssion(
            context,
            Permission.camera,
            message: cameraPermissionMessage,
            title: "Camera",
          ))) {
        pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera,
          imageQuality: 100,
        );
      } else if (result == 1 && kIsWeb
          ? true
          : (io.Platform.isIOS
                ? (await getPermisssion(
                    context,
                    Permission.photos,
                    title: "Gallery",
                    message: photosPermissionMessage,
                  ))
                : true)) {
        pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 100,
        );
      }
      if (pickedImage != null) {
        // debugPrint(
        //     'IMAGE SIZE ===== pickImageSize => ${(await pickedImage.readAsBytes()).length / 1024}');
        var croppedFile = await cropImage(context, pickedImage.path);
        if (croppedFile != null) {
          // debugPrint(
          //     'IMAGE SIZE ===== cropImageSize => ${(await croppedFile.readAsBytes()).length / 1024}');
          if (kIsWeb) {
            var croppedFileBytes = await croppedFile.readAsBytes();
            var compressedImage = await FlutterImageCompress.compressWithList(
              croppedFileBytes,
              quality: 90,
            );
            // debugPrint(
            //     'IMAGE SIZE ===== compressedImageSize => ${compressedImage.length / 1024}');
            return compressedImage;
          } else {
            var croppedFilePath = croppedFile.path;
            var compressedImage = await FlutterImageCompress.compressAndGetFile(
              croppedFilePath,
              "${(await path.getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}_${croppedFilePath.split("/").last.split(".").first}.jpeg",
              quality: 90,
            );
            if (compressedImage != null) {
              // debugPrint(
              //     'IMAGE SIZE ===== compressedImageSize => ${(await compressedImage.readAsBytes()).length / 1024}');
              return io.File(compressedImage.path);
            }
          }
        }
      }
    }
    return null;
  }

  static Future<dynamic> urlToFile(
    String url, {
    String imageName = "img",
  }) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Uint8List uint8list = response.bodyBytes;
      if (kIsWeb) {
        return uint8list;
      } else {
        var buffer = uint8list.buffer;
        ByteData byteData = ByteData.view(buffer);
        var tempDir = await path.getTemporaryDirectory();
        io.File file = await io.File('${tempDir.path}/$imageName').writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
        );
        return file;
      }
    }
    return null;
  }
}
