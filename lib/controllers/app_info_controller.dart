import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoController extends GetxController {
  late PackageInfo packageInfo;
  final RxString _appName = "".obs;
  final RxString _packageName = "".obs;
  final RxString _version = "".obs;
  final RxString _buildNumber = "".obs;

  get appName => _appName.value;
  get packageName => _packageName.value;
  get version => _version.value;
  get buildNumber => _buildNumber.value;

  Future<void> getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    _appName(packageInfo.appName);
    _packageName(packageInfo.packageName);
    _version(packageInfo.version);
    _buildNumber(packageInfo.buildNumber);
  }

  @override
  void onInit() {
    super.onInit();
    getPackageInfo();
  }
}
