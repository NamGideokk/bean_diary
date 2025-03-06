import 'package:bean_diary/controllers/register_green_bean_controller.dart';
import 'package:bean_diary/widgets/bottom_button_border_container.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterGreenBean extends StatefulWidget {
  const RegisterGreenBean({Key? key}) : super(key: key);

  @override
  State<RegisterGreenBean> createState() => _RegisterGreenBeanState();
}

class _RegisterGreenBeanState extends State<RegisterGreenBean> {
  final _registerGreenBeanCtrl = Get.put(RegisterGreenBeanController());

  @override
  void dispose() {
    super.dispose();
    Get.delete<RegisterGreenBeanController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("생두 등록 / 관리"),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(title: "생두명", subTitle: "Green coffee bean name"),
                  TextField(
                    controller: _registerGreenBeanCtrl.greenBeanNameTECtrl,
                    focusNode: _registerGreenBeanCtrl.greenBeanNameFN,
                    textInputAction: TextInputAction.go,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "예) 케냐 AA",
                      errorText: _registerGreenBeanCtrl.showErrorText ? " 생두명을 입력해 주세요." : null,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onSubmitted: (value) => _registerGreenBeanCtrl.registerGreenBean(context),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      const HeaderTitle(title: "생두 목록", subTitle: "Green coffee bean list"),
                      Visibility(
                        visible: _registerGreenBeanCtrl.greenBeanList.isNotEmpty,
                        child: Text(
                          "${_registerGreenBeanCtrl.greenBeanList.length}건",
                          style: TextStyle(
                            fontSize: height / 60,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: _registerGreenBeanCtrl.greenBeanList.isEmpty
                        ? const EmptyWidget(content: "등록된 생두가 없습니다.")
                        : SafeArea(
                            child: ListView.separated(
                              itemCount: _registerGreenBeanCtrl.greenBeanList.length,
                              padding: EdgeInsets.fromLTRB(5, 0, 5, height / 9),
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => const Divider(height: 10),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _registerGreenBeanCtrl.greenBeanList[index]["name"],
                                        style: TextStyle(
                                          fontSize: height / 52,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _registerGreenBeanCtrl.deleteGreenBean(context, index),
                                      child: Text(
                                        "삭제",
                                        style: TextStyle(
                                          fontSize: height / 60,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const BottomButtonBorderContainer(),
                  GestureDetector(
                    onTap: () => _registerGreenBeanCtrl.registerGreenBean(context),
                    child: Container(
                      width: double.infinity,
                      color: Colors.brown,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "생두 등록",
                        textAlign: TextAlign.center,
                        textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                        style: TextStyle(
                          fontSize: height / 50,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
