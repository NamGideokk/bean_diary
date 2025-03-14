import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RoastingManagementController extends GetxController {
  final blendNameTECtrl = TextEditingController();
  final blendNameFN = FocusNode();

  final RxList _blendNames = [].obs; // 블렌드명 전체 목록
  final RxList _blendNameSuggestions = [].obs; // 블렌드명 추천 목록

  get blendNames => _blendNames;
  get blendNameSuggestions => _blendNameSuggestions;

  /// 25-03-11
  ///
  /// 블렌드명 TextField 선택 시 블렌드명 전체 목록 할당하기
  void setAllBlendNames(TextEditingController ctrl) {
    if (ctrl.text == "") {
      _blendNameSuggestions(blendNames);
    }
  }

  /// 25-03-11
  ///
  /// 로스팅 관리 > 블렌드명 입력에 따른 추천 목록 가져오기
  void getBlendNameSuggestions(String value) {
    List list = [];
    for (final name in blendNames) {
      if (name.contains(value)) list.add(name);
    }
    _blendNameSuggestions(list);
  }
}
