import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterGreenBeanController extends GetxController {
  final _warehousingGreenBeanCtrl = Get.find<WarehousingGreenBeanController>();
  final greenBeanNameTECtrl = TextEditingController();
  final greenBeanNameFN = FocusNode();
  final RxList _greenBeanList = [].obs;
  final RxBool _showErrorText = false.obs;

  get greenBeanList => _greenBeanList;
  get showErrorText => _showErrorText.value;

  @override
  void onInit() {
    super.onInit();
    getGreenBeanList();
  }

  /// 생두 목록 가져오기
  Future<void> getGreenBeanList() async {
    final list = await GreenBeansSqfLite().getGreenBeans();
    if (list.isNotEmpty) {
      List sortingList = Utility().sortingName(list);
      _greenBeanList(sortingList);
    }
  }

  /// 생두 등록하기
  registerGreenBean(BuildContext context) async {
    if (greenBeanNameTECtrl.text.trim() == "") {
      setShowErrorMessage(true);
      greenBeanNameFN.requestFocus();
    } else {
      Map<String, String> value = {
        "name": greenBeanNameTECtrl.text.trim(),
      };
      int result = await GreenBeansSqfLite().insertGreenBean(value);
      setShowErrorMessage(false);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      CustomDialog().showSnackBar(
        context,
        result == 0
            ? "생두 등록에 실패했습니다.\n잠시 후 다시 시도해 주세요."
            : result == 1
                ? "[${greenBeanNameTECtrl.text.trim()}]\n생두가 등록되었습니다."
                : "이미 등록된 생두명입니다.\n생두는 중복으로 등록할 수 없습니다.",
        isError: result == 1 ? false : true,
      );
      if (result == 0) {
        return;
      } else if (result == 1) {
        greenBeanNameTECtrl.clear();
        await getGreenBeanList();
        await _warehousingGreenBeanCtrl.getBeanList();
        return;
      } else {
        greenBeanNameFN.requestFocus();
        return;
      }
    }
  }

  /// 생두 삭제하기
  void deleteGreenBean(BuildContext context, int index) async {
    bool? confirm = await CustomDialog().showAlertDialog(
      context,
      "생두 삭제",
      "[${greenBeanList[index]["name"]}]\n생두를 삭제하시겠습니까?",
      acceptTitle: "삭제",
    );
    if (confirm == true) {
      bool result = await GreenBeansSqfLite().deleteGreenBean(greenBeanList[index]["name"]);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      CustomDialog().showSnackBar(
        context,
        result ? "[${greenBeanList[index]["name"]}]\n생두가 삭제되었습니다." : "생두 삭제 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.",
        isError: result ? false : true,
      );
      if (result) {
        List copyList = [..._greenBeanList];
        copyList.removeAt(index);
        _greenBeanList(copyList);
        _warehousingGreenBeanCtrl.deleteBeanList(index);
        _warehousingGreenBeanCtrl.getBeanList();
      }
    }
    return;
  }

  /// 에러 메세지 보여주기 여부 값 할당하기
  void setShowErrorMessage(bool value) => _showErrorText(value);
}
