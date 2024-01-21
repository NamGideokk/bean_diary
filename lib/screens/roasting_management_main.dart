import 'dart:convert';

import 'package:bean_diary/controller/custom_date_picker_controller.dart';
import 'package:bean_diary/controller/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
                      const HeaderTitle(title: "로스팅 일자", subTitle: "roasting day"),
                      const CustomDatePicker(),
                      const SizedBox(height: 20),
                      const HeaderTitle(title: "로스팅 타입", subTitle: "roasting type"),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              value: 1,
                              groupValue: _warehousingGreenBeanCtrl.roastingType,
                              selected: _warehousingGreenBeanCtrl.roastingType == 1 ? true : false,
                              visualDensity: VisualDensity.compact,
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
                              visualDensity: VisualDensity.compact,
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
                      const SizedBox(height: 20),
                      const HeaderTitle(title: "투입 생두 정보", subTitle: "input green bean information"),
                      const BeanSelectDropdownButton(listType: 2),
                      const SizedBox(height: 5),
                      if (_warehousingGreenBeanCtrl.roastingType == 2)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _warehousingGreenBeanCtrl.blendBeanList.length,
                          itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: Colors.brown[50],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text(
                                    _warehousingGreenBeanCtrl.blendBeanList[index].toString(),
                                    style: TextStyle(
                                      fontSize: height / 54,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 2,
                                        child: TextField(
                                          controller: _warehousingGreenBeanCtrl.weightTECtrlList[index],
                                          focusNode: _warehousingGreenBeanCtrl.weightFNList[index],
                                          textAlign: TextAlign.center,
                                          textInputAction: TextInputAction.next,
                                          decoration: const InputDecoration(
                                            hintText: "투입 중량",
                                            suffixText: "kg",
                                          ),
                                          style: TextStyle(
                                            fontSize: height / 52,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _warehousingGreenBeanCtrl.deleteBlendBeanList(index);
                                        },
                                        icon: Icon(
                                          Icons.clear,
                                          size: height / 50,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
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
                                    decoration: const InputDecoration(
                                      hintText: "투입 중량",
                                      suffixText: "kg",
                                    ),
                                    style: TextStyle(
                                      fontSize: height / 52,
                                    ),
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
                                    decoration: const InputDecoration(
                                      hintText: "로스팅 후 중량",
                                      suffixText: "kg",
                                    ),
                                    style: TextStyle(
                                      fontSize: height / 52,
                                    ),
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
                                    decoration: const InputDecoration(
                                      hintText: "로스팅 후 중량",
                                      suffixText: "kg",
                                    ),
                                    style: TextStyle(
                                      fontSize: height / 52,
                                    ),
                                    onTap: () => Utility().moveScrolling(_scrollCtrl),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 20),
                      const UsageAlertWidget(),
                      const SizedBox(height: 20),
                      if (_warehousingGreenBeanCtrl.roastingType == 2)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const HeaderTitle(title: "블렌드명", subTitle: "blend name"),
                            SizedBox(
                              width: double.infinity,
                              child: TextField(
                                controller: _warehousingGreenBeanCtrl.blendNameTECtrl,
                                focusNode: _warehousingGreenBeanCtrl.blendNameFN,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: "블렌드명",
                                ),
                                style: TextStyle(
                                  fontSize: height / 52,
                                ),
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
                child: Container(
                  color: ColorsList().bgColor,
                  padding: const EdgeInsets.all(10),
                  child: SafeArea(
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            bool confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                            if (confirm) allValueInit();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          ),
                          child: Text(
                            "초기화",
                            style: TextStyle(
                              fontSize: height / 50,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
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
                                  "name": _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                  "roasting_weight": roastingWeight,
                                  "history": history,
                                };

                                bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);

                                if (!mounted) return;
                                CustomDialog().showSnackBar(
                                  context,
                                  insertResult
                                      ? "${_customDatePickerCtrl.textEditingCtrl.text}\n" +
                                          "블렌드 - ${_warehousingGreenBeanCtrl.blendNameTECtrl.text.trim()}\n" +
                                          "${Utility().numberFormat(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim())}kg\n" +
                                          "로스팅 등록이 완료되었습니다."
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
                                  _customDatePickerCtrl.setDateToToday();
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

                              bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);

                              if (!mounted) return;
                              CustomDialog().showSnackBar(
                                context,
                                insertResult
                                    ? "${_customDatePickerCtrl.textEditingCtrl.text}\n" +
                                        "싱글오리진 - ${_warehousingGreenBeanCtrl.selectedBean.split(" / ")[0]}\n" +
                                        "${Utility().numberFormat(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim())}kg\n" +
                                        "로스팅 등록이 완료되었습니다."
                                    : "로스팅 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                isError: insertResult ? false : true,
                              );

                              if (insertResult) {
                                String useWeight = _warehousingGreenBeanCtrl.weightTECtrl.text.trim().replaceAll(".", "");
                                Map<String, String> updateValue = {
                                  "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                  "name": _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                  "weight": useWeight,
                                  "date": date,
                                };
                                GreenBeanStockSqfLite().updateWeightGreenBeanStock(updateValue);
                                _warehousingGreenBeanCtrl.updateBeanListWeight(_warehousingGreenBeanCtrl.selectedBean, useWeight);
                                _warehousingGreenBeanCtrl.weightTECtrl.clear();
                                _warehousingGreenBeanCtrl.roastingWeightTECtrl.clear();
                                _warehousingGreenBeanCtrl.blendNameTECtrl.clear();
                                _customDatePickerCtrl.setDateToToday();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                            ),
                            child: Text(
                              "로스팅 등록",
                              style: TextStyle(
                                fontSize: height / 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
