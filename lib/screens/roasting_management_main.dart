import 'dart:convert';

import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
import 'package:bean_diary/widgets/bottom_button_border_container.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/usage_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoastingManagementMain extends StatefulWidget {
  const RoastingManagementMain({Key? key}) : super(key: key);

  @override
  State<RoastingManagementMain> createState() => _RoastingManagementMainState();
}

class _RoastingManagementMainState extends State<RoastingManagementMain> {
  final CustomDatePickerController _customDatePickerCtrl = Get.put(CustomDatePickerController());
  final WarehousingGreenBeanController _warehousingGreenBeanCtrl = Get.put(WarehousingGreenBeanController());

  final _weightFN = FocusNode();
  final _roastingWeightFN = FocusNode();

  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  void allValueInit() {
    FocusScope.of(context).requestFocus(FocusNode());
    _customDatePickerCtrl.setDateToToday();
    _warehousingGreenBeanCtrl.weightTECtrl.clear();
    _warehousingGreenBeanCtrl.roastingWeightTECtrl.clear();
    _warehousingGreenBeanCtrl.blendNameTECtrl.clear();

    // 블렌드 초기화
    _warehousingGreenBeanCtrl.initBlendInfo();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CustomDatePickerController>();
    Get.delete<WarehousingGreenBeanController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("로스팅 관리"),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const ClampingScrollPhysics(),
              controller: _scrollCtrl,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderTitle(title: "로스팅 일자", subTitle: "Roasting date"),
                    const CustomDatePicker(),
                    const SizedBox(height: 50),
                    const HeaderTitle(title: "로스팅 타입", subTitle: "Roast type"),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: 1,
                            groupValue: _warehousingGreenBeanCtrl.roastingType,
                            selected: _warehousingGreenBeanCtrl.roastingType == 1 ? true : false,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (value) {
                              _warehousingGreenBeanCtrl.setRoastingType(int.parse(value.toString()));
                            },
                            title: Text(
                              "싱글오리진",
                              style: TextStyle(
                                fontSize: height / 54,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: 2,
                            groupValue: _warehousingGreenBeanCtrl.roastingType,
                            selected: _warehousingGreenBeanCtrl.roastingType == 2 ? true : false,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (value) {
                              _warehousingGreenBeanCtrl.setRoastingType(int.parse(value.toString()));
                            },
                            title: Text(
                              "블렌드",
                              style: TextStyle(
                                fontSize: height / 54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const HeaderTitle(title: "투입 생두 정보", subTitle: "Green coffee bean input info"),
                    const BeanSelectDropdownButton(listType: 2),
                    const SizedBox(height: 5),
                    if (_warehousingGreenBeanCtrl.roastingType == 2)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _warehousingGreenBeanCtrl.blendBeanList.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        itemBuilder: (context, index) => ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    text: "${(index + 1).toString().padLeft(2, "0")}.  ",
                                    style: TextStyle(
                                      fontSize: height / 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: Utility().splitNameAndWeight(_warehousingGreenBeanCtrl.blendBeanList[index].toString(), 1),
                                        style: TextStyle(
                                          fontSize: height / 54,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              FocusScope(
                                canRequestFocus: false,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    visualDensity: VisualDensity.compact,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () => _warehousingGreenBeanCtrl.deleteBlendBeanListItem(index),
                                  icon: Icon(
                                    Icons.clear,
                                    size: height / 40,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Text(
                                Utility().splitNameAndWeight(_warehousingGreenBeanCtrl.blendBeanList[index].toString(), 2),
                                style: TextStyle(
                                  fontSize: height / 52,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Flexible(
                                child: TextField(
                                  controller: _warehousingGreenBeanCtrl.weightTECtrlList[index],
                                  focusNode: _warehousingGreenBeanCtrl.weightFNList[index],
                                  textAlign: TextAlign.center,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "투입 중량",
                                    suffixText: "kg",
                                    prefixText: "투입",
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 5),
                    _warehousingGreenBeanCtrl.roastingType == 1
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "투입",
                                style: TextStyle(
                                  fontSize: height / 54,
                                  color: Colors.brown,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _warehousingGreenBeanCtrl.weightTECtrl,
                                  focusNode: _weightFN,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "투입 중량",
                                    suffixText: "kg",
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  onTap: () => Utility().moveScrolling(_scrollCtrl),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "배출",
                                style: TextStyle(
                                  fontSize: height / 54,
                                  color: Colors.brown,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _warehousingGreenBeanCtrl.roastingWeightTECtrl,
                                  focusNode: _roastingWeightFN,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "로스팅 후 중량",
                                    suffixText: "kg",
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  onTap: () => Utility().moveScrolling(_scrollCtrl),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "배출",
                                style: TextStyle(
                                  fontSize: height / 54,
                                  color: Colors.brown,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _warehousingGreenBeanCtrl.roastingWeightTECtrl,
                                  focusNode: _roastingWeightFN,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "로스팅 후 중량",
                                    suffixText: "kg",
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  onTap: () => Utility().moveScrolling(_scrollCtrl),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 50),
                    const UsageAlertWidget(),
                    const SizedBox(height: 50),
                    if (_warehousingGreenBeanCtrl.roastingType == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const HeaderTitle(title: "블렌드명", subTitle: "Blend name"),
                          SizedBox(
                            width: double.infinity,
                            child: TextField(
                              controller: _warehousingGreenBeanCtrl.blendNameTECtrl,
                              focusNode: _warehousingGreenBeanCtrl.blendNameFN,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "블렌드명",
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              onTap: () => Utility().moveScrolling(_scrollCtrl),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: height / 9),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const BottomButtonBorderContainer(),
                    MediaQuery(
                      data: MediaQueryData(
                        textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              bool confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                              if (confirm) allValueInit();
                            },
                            child: Container(
                              color: Colors.brown[100],
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                " 초기화 ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: height / 50,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                // 블렌드
                                if (_warehousingGreenBeanCtrl.roastingType == 2) {
                                  if (_warehousingGreenBeanCtrl.blendBeanList.isEmpty) {
                                    CustomDialog().showSnackBar(context, "투입할 생두를 선택해 주세요.");
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    return;
                                  }
                                  // 여기서부터 블렌드 n개 체크하기
                                  _warehousingGreenBeanCtrl.weightTECtrlList.asMap().forEach((i, e) {
                                    var divide = _warehousingGreenBeanCtrl.blendBeanList[i].toString().split(" / ");

                                    if (e.text == "") {
                                      CustomDialog().showSnackBar(context, "[${divide[0]}]\n생두의 투입량을 입력해 주세요.");
                                      return;
                                    }
                                    var result = Utility().checkWeightRegEx(e.text.trim());
                                    e.text = result["replaceValue"];

                                    if (!result["bool"]) {
                                      CustomDialog().showSnackBar(
                                        context,
                                        "[${divide[0]}]\n생두의 중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                      );
                                      return;
                                    } else {
                                      int totalWeight = int.parse(divide[1].replaceAll(RegExp("[.,kg]"), ""));
                                      int inputWeight = int.parse(e.text.trim().replaceAll(".", ""));
                                      if (totalWeight < inputWeight) {
                                        CustomDialog().showSnackBar(context, "[${divide[0]}]\n생두의 투입량이 보유량보다 큽니다.\n다시 입력해 주세요.");
                                        return;
                                      }
                                    }
                                  });

                                  if (_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim() == "") {
                                    CustomDialog().showSnackBar(context, "배출량을 입력해 주세요.");
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    return;
                                  } else {
                                    var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim());
                                    _warehousingGreenBeanCtrl.roastingWeightTECtrl.text = result["replaceValue"];

                                    if (!result["bool"]) {
                                      CustomDialog().showSnackBar(context, "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.");
                                      _roastingWeightFN.requestFocus();
                                      return;
                                    } else {
                                      // 배출량과 블렌드 투입 총량 비교 부분
                                      int blendTotalWeight = 0;
                                      int roastingWeight = int.parse(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.replaceAll(".", ""));
                                      _warehousingGreenBeanCtrl.weightTECtrlList.forEach((e) {
                                        blendTotalWeight += int.parse(e.text.replaceAll(".", ""));
                                      });
                                      if (blendTotalWeight <= roastingWeight) {
                                        CustomDialog().showSnackBar(context, "배출량이 총 투입량과 같거나 클 수 없습니다.\n다시 입력해 주세요.");
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        return;
                                      }
                                    }
                                  }
                                  if (_warehousingGreenBeanCtrl.blendNameTECtrl.text.trim() == "") {
                                    CustomDialog().showSnackBar(context, "블렌드명을 입력해 주세요.");
                                    _warehousingGreenBeanCtrl.blendNameFN.requestFocus();
                                    return;
                                  }

                                  String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");
                                  String roastingWeight = _warehousingGreenBeanCtrl.roastingWeightTECtrl.text.replaceAll(".", "");
                                  String history = jsonEncode([
                                    {
                                      "date": date,
                                      "roasting_weight": roastingWeight,
                                    },
                                  ]);

                                  // type, name, roasting_weight, history
                                  Map<String, String> value = {
                                    "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                    "name":
                                        _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                    "roasting_weight": roastingWeight,
                                    "history": history,
                                  };

                                  String beans = "";
                                  for (int i = 0; i < _warehousingGreenBeanCtrl.blendBeanList.length; i++) {
                                    String copyItem = _warehousingGreenBeanCtrl.blendBeanList[i].toString();
                                    if (i == 0) {
                                      beans = "생두 01: ${copyItem.split(" / ")[0]} / ${_warehousingGreenBeanCtrl.weightTECtrlList[i].text}kg";
                                    } else {
                                      beans = "$beans\n생두 ${(i + 1).toString().padLeft(2, "0")}: ${copyItem.split(" / ")[0]} / ${_warehousingGreenBeanCtrl.weightTECtrlList[i].text}kg";
                                    }
                                  }

                                  bool? finalConfirm = await CustomDialog().showAlertDialog(
                                    context,
                                    "로스팅 등록",
                                    "블렌드\n\n로스팅일: ${_customDatePickerCtrl.textEditingCtrl.text}\n$beans\n배출량: ${_warehousingGreenBeanCtrl.roastingWeightTECtrl.text}kg\n블렌드명: ${_warehousingGreenBeanCtrl.blendNameTECtrl.text}\n\n입력하신 정보로 로스팅을 등록합니다.",
                                    acceptTitle: "등록하기",
                                  );
                                  if (finalConfirm != true) return;

                                  bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);

                                  if (!mounted) return;
                                  CustomDialog().showSnackBar(
                                    context,
                                    insertResult
                                        ? "${_customDatePickerCtrl.textEditingCtrl.text}\n블렌드 - ${_warehousingGreenBeanCtrl.blendNameTECtrl.text.trim()}\n${Utility().numberFormat(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim())}kg\n로스팅 등록이 완료되었습니다."
                                        : "로스팅 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                    isError: insertResult ? false : true,
                                  );

                                  if (insertResult) {
                                    // 드롭다운버튼 생두 무게 리프레쉬
                                    _warehousingGreenBeanCtrl.blendBeanList.asMap().forEach((i, e) {
                                      String useWeight = _warehousingGreenBeanCtrl.weightTECtrlList[i].text.replaceAll(".", "");
                                      Map<String, String> updateValue = {
                                        "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                        "name": e.toString().split(" / ")[0],
                                        "weight": useWeight,
                                        "date": date,
                                      };
                                      GreenBeanStockSqfLite().updateWeightGreenBeanStock(updateValue);
                                      _warehousingGreenBeanCtrl.updateBeanListWeight(e.toString(), useWeight);
                                    });
                                    _warehousingGreenBeanCtrl.weightTECtrl.clear();
                                    _warehousingGreenBeanCtrl.roastingWeightTECtrl.clear();
                                    _warehousingGreenBeanCtrl.blendNameTECtrl.clear();
                                    _warehousingGreenBeanCtrl.initBlendInfo();
                                  }

                                  FocusScope.of(context).requestFocus(FocusNode());
                                  return;
                                }

                                // 1
                                if (_warehousingGreenBeanCtrl.selectedBean == null) {
                                  CustomDialog().showSnackBar(context, "투입할 생두를 선택해 주세요.");
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  return;
                                }
                                if (_warehousingGreenBeanCtrl.weightTECtrl.text.trim() == "") {
                                  CustomDialog().showSnackBar(context, "투입량을 입력해 주세요.");
                                  _weightFN.requestFocus();
                                  return;
                                } else {
                                  var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.weightTECtrl.text.trim());
                                  _warehousingGreenBeanCtrl.weightTECtrl.text = result["replaceValue"];

                                  if (!result["bool"]) {
                                    CustomDialog().showSnackBar(context, "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.");
                                    _weightFN.requestFocus();
                                    return;
                                  } else {
                                    // 투입량이랑 보유량이랑 비교하는 로직 부분
                                    var divide = _warehousingGreenBeanCtrl.selectedBean.split(" / ");
                                    int totalWeight = int.parse(divide[1].replaceAll(RegExp("[.,kg]"), ""));
                                    int inputWeight = int.parse(_warehousingGreenBeanCtrl.weightTECtrl.text.trim().replaceAll(".", ""));
                                    if (totalWeight < inputWeight) {
                                      CustomDialog().showSnackBar(context, "투입량이 보유량보다 큽니다.\n다시 입력해 주세요.");
                                      _weightFN.requestFocus();
                                      return;
                                    }
                                  }
                                }
                                if (_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim() == "") {
                                  CustomDialog().showSnackBar(context, "배출량을 입력해 주세요.");
                                  _roastingWeightFN.requestFocus();
                                  return;
                                } else {
                                  var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim());
                                  _warehousingGreenBeanCtrl.roastingWeightTECtrl.text = result["replaceValue"];

                                  if (!result["bool"]) {
                                    CustomDialog().showSnackBar(context, "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.");
                                    _roastingWeightFN.requestFocus();
                                    return;
                                  } else {
                                    // 로스팅 후 총량이 투입량보다 낮은지 확인하는 로직 부분
                                    int inputWeight = int.parse(_warehousingGreenBeanCtrl.weightTECtrl.text.trim().replaceAll(".", ""));
                                    int roastingWeight = int.parse(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim().replaceAll(".", ""));
                                    if (inputWeight <= roastingWeight) {
                                      CustomDialog().showSnackBar(context, "배출량이 투입량과 같거나 클 수 없습니다.\n다시 입력해 주세요.");
                                      _roastingWeightFN.requestFocus();
                                      return;
                                    }
                                  }
                                }

                                String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");
                                String roastingWeight = _warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim().replaceAll(".", "");
                                String history = jsonEncode([
                                  {
                                    "date": date,
                                    "roasting_weight": roastingWeight,
                                  },
                                ]);

                                // type, name, roasting_weight, history
                                Map<String, String> value = {
                                  "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                  "name": _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                  "roasting_weight": roastingWeight,
                                  "history": history,
                                };

                                bool? finalConfirm = await CustomDialog().showAlertDialog(
                                  context,
                                  "로스팅 등록",
                                  "싱글오리진\n\n로스팅일: ${_customDatePickerCtrl.textEditingCtrl.text}\n생두: ${_warehousingGreenBeanCtrl.selectedBean.split(" / ")[0]} / ${_warehousingGreenBeanCtrl.weightTECtrl.text}kg\n배출량: ${_warehousingGreenBeanCtrl.roastingWeightTECtrl.text}kg\n\n입력하신 정보로 로스팅을 등록합니다.",
                                  acceptTitle: "등록하기",
                                );
                                if (finalConfirm != true) return;

                                bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);

                                if (!mounted) return;
                                CustomDialog().showSnackBar(
                                  context,
                                  insertResult
                                      ? "${_customDatePickerCtrl.textEditingCtrl.text}\n싱글오리진 - ${_warehousingGreenBeanCtrl.selectedBean.split(" / ")[0]}\n${Utility().numberFormat(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim())}kg\n로스팅 등록이 완료되었습니다."
                                      : "로스팅 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                  isError: insertResult ? false : true,
                                );

                                if (insertResult) {
                                  String useWeight = _warehousingGreenBeanCtrl.weightTECtrl.text.trim().replaceAll(".", "");
                                  Map<String, String> updateValue = {
                                    "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                    "name":
                                        _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                    "weight": useWeight,
                                    "date": date,
                                  };
                                  GreenBeanStockSqfLite().updateWeightGreenBeanStock(updateValue);
                                  _warehousingGreenBeanCtrl.updateBeanListWeight(_warehousingGreenBeanCtrl.selectedBean, useWeight);
                                  _warehousingGreenBeanCtrl.weightTECtrl.clear();
                                  _warehousingGreenBeanCtrl.roastingWeightTECtrl.clear();
                                  _warehousingGreenBeanCtrl.blendNameTECtrl.clear();
                                }
                              },
                              child: Container(
                                color: Colors.brown,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(
                                  "로스팅 등록",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: height / 50,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
