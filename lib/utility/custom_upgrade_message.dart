import 'dart:io';

import 'package:upgrader/upgrader.dart';

class CustomUpgradeMessages extends UpgraderMessages {
  @override
  get title => "최신 업데이트";

  @override
  get body => "{{appName}} 새 버전이 업데이트되었습니다.\n최신 버전 - {{currentAppStoreVersion}}\n현재 버전 - {{currentInstalledVersion}}";

  @override
  get prompt => Platform.isAndroid
      ? "업데이트 후 앱을 이용해 주세요.\n\nⓘ Play 스토어 이동 후\n\t\t\t[업데이트]가 아닌 [열기]로 나오는 경우\n\n설정 > 애플리케이션 > Google Play 스토어 > 저장공간 > [데이터 삭제]와 [캐시 삭제] 클릭 후 'Play 스토어'와 '원두 다이어리' 앱을 종료 후 재실행"
      : "업데이트 후 앱을 이용해 주세요.";
}
