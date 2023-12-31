import 'package:bean_diary/controller/register_green_bean_controller.dart';
import 'package:bean_diary/controller/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterGreenBean extends StatefulWidget {
  const RegisterGreenBean({Key? key}) : super(key: key);

  @override
  State<RegisterGreenBean> createState() => _RegisterGreenBeanState();
}

class _RegisterGreenBeanState extends State<RegisterGreenBean> {
  final _registerGreenBeanCtrl = Get.put(RegisterGreenBeanController());
  final _warehousingGreenBeanCtrl = Get.find<WarehousingGreenBeanController>();
  final _greenBeanNameTECtrl = TextEditingController();
  final _greenBeanNameFN = FocusNode();
  bool _showErrorText = false;

  @override
  void initState() {
    super.initState();
  }

  void onTapInsertGreenBean() async {
    if (_greenBeanNameTECtrl.text.trim() == "") {
      _showErrorText = true;
      setState(() {});
      _greenBeanNameFN.requestFocus();
    } else {
      Map<String, String> value = {"name": _greenBeanNameTECtrl.text.trim()};
      int result = await GreenBeansSqfLite().insertGreenBean(value);
      _showErrorText = false;
      setState(() {});
      if (!mounted) return;
      CustomDialog().showFloatingSnackBar(
        context,
        result == 0
            ? "생두 등록에 실패했습니다.\n잠시 후 다시 시도해 주세요."
            : result == 1
                ? "[${_greenBeanNameTECtrl.text.trim()}]\n생두가 등록되었습니다."
                : "이미 등록된 생두명입니다.\n생두는 중복으로 등록할 수 없습니다.",
        bgColor: result == 1 ? Colors.green : Colors.red,
      );
      if (result == 0) {
        return;
      } else if (result == 1) {
        _greenBeanNameTECtrl.clear();
        _registerGreenBeanCtrl.getGreenBeanList();
        _warehousingGreenBeanCtrl.getBeanList();
        return;
      } else {
        _greenBeanNameFN.requestFocus();
        return;
      }
    }
  }

  void onTapDeleteGreenBean(int index) async {
    bool confirm = await CustomDialog().showAlertDialog(
      context,
      "생두 삭제",
      "[${_registerGreenBeanCtrl.greenBeanList[index]["name"]}]\n생두를 삭제하시겠습니까?",
      acceptTitle: "삭제",
    );
    if (confirm) {
      bool result = await GreenBeansSqfLite().deleteGreenBean(_registerGreenBeanCtrl.greenBeanList[index]["name"]);

      if (!mounted) return;
      CustomDialog().showFloatingSnackBar(
        context,
        result ? "[${_registerGreenBeanCtrl.greenBeanList[index]["name"]}]\n생두가 삭제되었습니다." : "생두 삭제 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.",
        bgColor: result ? Colors.green : Colors.red,
      );
      if (result) {
        _registerGreenBeanCtrl.deleteGreenBeanElement(index);
        _warehousingGreenBeanCtrl.deleteBeanList(index);
        _warehousingGreenBeanCtrl.getBeanList();
      } else {}
    }
    return;
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<RegisterGreenBeanController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                  controller: _greenBeanNameTECtrl,
                  focusNode: _greenBeanNameFN,
                  textInputAction: TextInputAction.go,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: height / 52,
                  ),
                  decoration: InputDecoration(
                    hintText: "예) 케냐 AA",
                    errorText: _showErrorText ? " 생두명을 입력해 주세요." : null,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onSubmitted: (value) => onTapInsertGreenBean(),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTapInsertGreenBean,
                    child: Text("생두 등록"),
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
                              separatorBuilder: (context, index) => const Divider(height: 8),
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
                                    TextButton.icon(
                                      onPressed: () => onTapDeleteGreenBean(index),
                                      icon: Icon(
                                        CupertinoIcons.delete_simple,
                                        size: height / 70,
                                      ),
                                      label: Text(
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
