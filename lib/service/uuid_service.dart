import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UuidService {
  static const _uuid = Uuid();
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String?> getDeviceId() async {
    if (Platform.isAndroid) {
      return _uuid.v5(
        Namespace.url.value,
        (await _deviceInfoPlugin.androidInfo).id,
      );
    } else if (Platform.isIOS) {
      return (await _deviceInfoPlugin.iosInfo).identifierForVendor;
    } else {
      var webInfo = await _deviceInfoPlugin.webBrowserInfo;
      return _uuid.v5(
        Namespace.url.value,
        '${webInfo.productSub!} ${webInfo.platform!} ${webInfo.userAgent!}',
      );
    }
  }

  static Future<String?> deviceModel() async {
    if (Platform.isAndroid) {
      var androidInfo = await _deviceInfoPlugin.androidInfo;
      return "${androidInfo.manufacturer} ${androidInfo.model}";
    } else if (Platform.isIOS) {
      return (await _deviceInfoPlugin.iosInfo).modelName;
    } else {
      var webInfo = await _deviceInfoPlugin.webBrowserInfo;
      return webInfo.userAgent!;
    }
  }
}
