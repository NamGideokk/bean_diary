import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterGreenBeanController extends GetxController {
  final _warehousingGreenBeanCtrl = Get.find<WarehousingGreenBeanController>();
  final greenBeanNameTECtrl = TextEditingController();
  final greenBeanNameFN = FocusNode();
  final RxList _greenBeanList = [].obs;
  final RxBool _showErrorText = false.obs;

  final RxBool _isKoreanDisplay = true.obs;

  final List coffeeProducingCountries = [
    {
      "region": {
        "eng": "South America",
        "kor": "남아메리카",
      },
      "countries": [
        {"eng": "Brazil", "kor": "브라질"},
        {"eng": "Colombia", "kor": "콜롬비아"},
        {"eng": "Peru", "kor": "페루"},
        {"eng": "Ecuador", "kor": "에콰도르"},
        {"eng": "Bolivia", "kor": "볼리비아"},
        {"eng": "Venezuela", "kor": "베네수엘라"},
        {"eng": "Guyana", "kor": "가이아나"},
      ],
    },
    {
      "region": {
        "eng": "Central America",
        "kor": "중앙아메리카",
      },
      "countries": [
        {"eng": "Guatemala", "kor": "과테말라"},
        {"eng": "Honduras", "kor": "온두라스"},
        {"eng": "El Salvador", "kor": "엘살바도르"},
        {"eng": "Nicaragua", "kor": "니카라과"},
        {"eng": "Costa Rica", "kor": "코스타리카"},
        {"eng": "Panama", "kor": "파나마"},
      ],
    },
    {
      "region": {
        "eng": "Caribbean",
        "kor": "카리브해",
      },
      "countries": [
        {"eng": "Dominican Republic", "kor": "도미니카공화국"},
        {"eng": "Cuba", "kor": "쿠바"},
        {"eng": "Jamaica", "kor": "자메이카"},
        {"eng": "Haiti", "kor": "아이티"},
      ],
    },
    {
      "region": {
        "eng": "Africa",
        "kor": "아프리카",
      },
      "countries": [
        {"eng": "Ethiopia", "kor": "에티오피아"},
        {"eng": "Uganda", "kor": "우간다"},
        {"eng": "Tanzania", "kor": "탄자니아"},
        {"eng": "Kenya", "kor": "케냐"},
        {"eng": "Rwanda", "kor": "르완다"},
        {"eng": "Burundi", "kor": "부룬디"},
        {"eng": "Democratic Republic of the Congo", "kor": "콩고민주공화국"},
        {"eng": "Malawi", "kor": "말라위"},
        {"eng": "Zambia", "kor": "잠비아"},
        {"eng": "Ivory Coast", "kor": "코트디부아르"},
        {"eng": "Cameroon", "kor": "카메룬"},
        {"eng": "Madagascar", "kor": "마다가스카르"},
        {"eng": "Gabon", "kor": "가봉"},
      ],
    },
    {
      "region": {
        "eng": "Asia",
        "kor": "아시아",
      },
      "countries": [
        {"eng": "Vietnam", "kor": "베트남"},
        {"eng": "Indonesia", "kor": "인도네시아"},
        {"eng": "India", "kor": "인도"},
        {"eng": "Thailand", "kor": "태국"},
        {"eng": "Myanmar", "kor": "미얀마"},
        {"eng": "Laos", "kor": "라오스"},
        {"eng": "Malaysia", "kor": "말레이시아"},
        {"eng": "Philippines", "kor": "필리핀"},
        {"eng": "China", "kor": "중국"},
        {"eng": "Nepal", "kor": "네팔"}
      ],
    },
    {
      "region": {
        "eng": "Oceania",
        "kor": "오세아니아",
      },
      "countries": [
        {"eng": "Papua New Guinea", "kor": "파푸아뉴기니"},
        {"eng": "Tuvalu", "kor": "투발루"},
        {"eng": "Fiji", "kor": "피지"}
      ],
    },
    {
      "region": {
        "eng": "Middle East",
        "kor": "중동",
      },
      "countries": [
        {"eng": "Yemen", "kor": "예멘"}
      ],
    },
  ];

  get greenBeanList => _greenBeanList;
  get showErrorText => _showErrorText.value;

  get isKoreanDisplay => _isKoreanDisplay.value;

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
        // 실패
        return;
      } else if (result == 1) {
        // 성공
        greenBeanNameTECtrl.clear();
        await getGreenBeanList();
        await BeanSelectionDropdownController.to.getBeans(ListType.greenBean);
        return;
      } else {
        // 중복
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
        await BeanSelectionDropdownController.to.getBeans(ListType.greenBean);
      }
    }
    return;
  }

  /// 에러 메세지 보여주기 여부 값 할당하기
  void setShowErrorMessage(bool value) => _showErrorText(value);

  /// 25-03-12
  ///
  /// 국가 목록 한글/영문 표출 여부 값 변경하기
  void setIsKoreanDisplay(bool value) => _isKoreanDisplay(value);

  /// 25-03-12
  ///
  /// 국가 Chip 선택하여 TextField에 입력하기
  void onCountrySelected(String value) {
    greenBeanNameTECtrl.text = "$value ";
    greenBeanNameFN.requestFocus();
  }

  @override
  void onClose() {
    super.onClose();
    greenBeanNameTECtrl.dispose();
    greenBeanNameFN.dispose();
  }
}
