import 'package:bean_diary/controllers/app_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appInfoCtrl = Get.put(AppInfoController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      color: Colors.brown[50],
      width: width * 0.85,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: height / 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.brown[100]!,
                    Colors.brown[50]!,
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: height / 14,
                ),
                const SizedBox(height: 20),
                Text(
                  "Bean Diary",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height / 60,
                    color: Colors.black54,
                    height: 0.6,
                  ),
                ),
                Text(
                  "원두 다이어리",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height / 40,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(),
            Obx(
              () => Column(
                children: [
                  _MyText(text: "v${appInfoCtrl.version}"),
                  Text(
                    AppInfoController.to.hasNewVersion ? "${AppInfoController.to.latestVersion} 버전으로 업데이트 하세요." : "최신 버전입니다.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  const _MyText(text: "created by 남기덕"),
                  const _MyText(text: "namgd1222@gmail.com"),
                  const SizedBox(height: 50),
                  Text(
                    "all icons created by Freepik - Flaticon",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black26,
                      fontSize: height / 70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyText extends StatelessWidget {
  final String text;
  const _MyText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: height / 60,
      ),
    );
  }
}
