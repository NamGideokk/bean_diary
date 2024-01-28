import 'package:bean_diary/controllers/register_green_bean_controller.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/keyboard_dismiss.dart';
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
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("생두 등록 / 관리"),
          centerTitle: true,
        ),
        body: Obx(
          () => Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderTitle(title: "생두명", subTitle: "green bean name"),
                TextField(
                  controller: _registerGreenBeanCtrl.greenBeanNameTECtrl,
                  focusNode: _registerGreenBeanCtrl.greenBeanNameFN,
                  textInputAction: TextInputAction.go,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height / 52,
                  ),
                  decoration: InputDecoration(
                    hintText: "예) 케냐 AA",
                    errorText: _registerGreenBeanCtrl.showErrorText ? " 생두명을 입력해 주세요." : null,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onSubmitted: (value) => _registerGreenBeanCtrl.registerGreenBean(context),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _registerGreenBeanCtrl.registerGreenBean(context),
                    child: const Text("생두 등록"),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    const HeaderTitle(title: "생두 목록", subTitle: "green bean list"),
                    if (_registerGreenBeanCtrl.greenBeanList.isNotEmpty)
                      Text(
                        "${_registerGreenBeanCtrl.greenBeanList.length}건",
                        style: TextStyle(
                          fontSize: height / 60,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
                _registerGreenBeanCtrl.greenBeanList.isEmpty
                    ? const EmptyWidget(content: "등록된 생두가 없습니다.")
                    : Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: SafeArea(
                            child: ListView.separated(
                              itemCount: _registerGreenBeanCtrl.greenBeanList.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 10),
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => const Divider(height: 15),
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
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
