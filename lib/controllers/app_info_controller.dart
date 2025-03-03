import 'dart:io';

import 'package:bean_diary/services/store_version_service.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoController extends GetxController {
  static AppInfoController get to => Get.find();

  late PackageInfo packageInfo;
  final RxString _appName = "".obs;
  final RxString _packageName = "".obs;
  final RxString _version = "".obs;
  final RxString _buildNumber = "".obs;
  final RxnString _latestVersion = RxnString();
  final RxBool _hasNewVersion = false.obs;

  get appName => _appName.value;
  get packageName => _packageName.value;
  get version => _version.value;
  get buildNumber => _buildNumber.value;
  get latestVersion => _latestVersion.value;
  get hasNewVersion => _hasNewVersion.value;

  /// 패키지 정보 가져오기
  Future<void> getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    _appName(packageInfo.appName);
    _packageName(packageInfo.packageName);
    _version(packageInfo.version);
    _buildNumber(packageInfo.buildNumber);
  }

  /// 24-07-19 ngd
  ///
  /// ANDROID 스토어 앱 버전 가져오기
  Future<void> fetchPlayStoreAppVersion() async {
    final Map<String, dynamic> result = await StoreVersionService().fetchPlayStoreAppVersion();
    if (result["bool"]) {
      if (result["data"]["version"] != null && result["data"]["version"] != "") {
        _latestVersion(result["data"]["version"]);
        _hasNewVersion(version == latestVersion ? false : true);
      } else {
        _hasNewVersion(false);
      }
    } else {
      _latestVersion(null);
      _hasNewVersion(false);
    }
  }

  /// 25-03-03
  ///
  /// 플레이스토어로 이동하기
  Future goToPlayStore(BuildContext context) async {
    if (Platform.isAndroid) {
      final url = Uri.parse("market://details?id=${dotenv.env["ANDROID_BUNDLE_ID"]}");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        SystemNavigator.pop();
        return;
      } else {
        if (context.mounted) await CustomDialog().showSnackBar(context, "죄송합니다. 링크를 열 수 없습니다.");
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPackageInfo();
    fetchPlayStoreAppVersion();
  }
}
