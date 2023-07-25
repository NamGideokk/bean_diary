import 'package:bean_diary/controller/custom_date_picker_controller.dart';
import 'package:bean_diary/controller/warehousing_green_bean_controller.dart';
import 'package:bean_diary/sqflite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/weight_alert.dart';
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

  @override
  void initState() {
    super.initState();
    getRoastingBeanStock();
  }

  void getRoastingBeanStock() async {
    await RoastingBeanStockSqfLite().openDB();
    await RoastingBeanStockSqfLite().getRoastingBeanStock();
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
                            title: Text("싱글오리진"),
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
                            title: const Text("블렌드"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const HeaderTitle(title: "투입 생두 정보", subTitle: "input green bean information"),
                    const BeanSelectDropdownButton(listType: 2),
                    const SizedBox(height: 10),
                    if (_warehousingGreenBeanCtrl.roastingType == 2)
                      ListView.builder(
                        shrinkWrap: true,
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
                                        print("삭제");
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
                    const SizedBox(height: 10),
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
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    // 생두 추가 버튼
                    // _roastingTypeValue == "1"
                    //     ? const SizedBox()
                    //     : Align(
                    //         alignment: Alignment.center,
                    //         child: OutlinedButton.icon(
                    //           onPressed: addGreenBean,
                    //           icon: Icon(
                    //             Icons.add_circle_outline_sharp,
                    //             size: height / 40,
                    //           ),
                    //           label: const Text("생두 추가"),
                    //           style: OutlinedButton.styleFrom(
                    //             side: BorderSide(
                    //               width: 1.5,
                    //               color: Colors.brown[300]!,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    const SizedBox(height: 20),
                    const WeightAlert(),
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
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "블렌드명",
                              ),
                              style: TextStyle(
                                fontSize: height / 52,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 100),
                  ],
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
                          onPressed: () {
                            print("초기화");
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "초기화",
                            style: TextStyle(
                              fontSize: height / 46,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // 블렌드
                              if (_warehousingGreenBeanCtrl.roastingType == 2) {
                                print("= = = = = = = = = = = = = = 블 렌 드 = = = = = = = = = = =\n\n\n");
                                if (_warehousingGreenBeanCtrl.blendBeanList.isEmpty) {
                                  final snackBar = CustomDialog().showCustomSnackBar(context, "투입할 생두를 선택해 주세요.");
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  return;
                                }
                                // 여기서부터 블렌드 n개 체크하기
                                print("🐡 WEIGHT LIST TECTRL 체크 : ${_warehousingGreenBeanCtrl.weightTECtrlList.length}");

                                _warehousingGreenBeanCtrl.weightTECtrlList.asMap().forEach((i, e) {
                                  var divide = _warehousingGreenBeanCtrl.blendBeanList[i].toString().split(" / ");

                                  if (e.text == "") {
                                    final snackBar = CustomDialog().showCustomSnackBar(context, "[${divide[0]}] 생두의 투입량을 입력해 주세요.");
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    // FocusScope.of(context).requestFocus(FocusNode());
                                    return;
                                  }
                                  print("🐙 BLEND WEIGHT LIST i : *$i*>>>> \n ${e.text}");
                                  var result = Utility().checkWeightRegEx(e.text.trim());
                                  e.text = result["replaceValue"];

                                  if (!result["bool"]) {
                                    final snackBar = CustomDialog().showCustomSnackBar(
                                      context,
                                      "[${divide[0]}] 생두의 중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    // _warehousingGreenBeanCtrl.weightFNList[i].requestFocus();
                                    return;
                                  } else {
                                    print("⚽️ ${_warehousingGreenBeanCtrl.blendBeanList[i]}");
                                    int totalWeight = int.parse(divide[1].replaceAll(RegExp("[.kg]"), ""));
                                    int inputWeight = int.parse(e.text.trim().replaceAll(".", ""));
                                    if (totalWeight < inputWeight) {
                                      final snackBar = CustomDialog().showCustomSnackBar(context, "[${divide[0]}] 생두의 투입량이 보유량보다 큽니다.\n다시 입력해 주세요.");
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      // _warehousingGreenBeanCtrl.weightFNList[i].requestFocus();
                                      return;
                                    }
                                  }
                                });

                                if (_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim() == "") {
                                  final snackBar = CustomDialog().showCustomSnackBar(context, "배출량을 입력해 주세요.");
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  return;
                                } else {
                                  var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim());
                                  _warehousingGreenBeanCtrl.roastingWeightTECtrl.text = result["replaceValue"];

                                  if (!result["bool"]) {
                                    final snackBar = CustomDialog().showCustomSnackBar(
                                      context,
                                      "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    _roastingWeightFN.requestFocus();
                                    return;
                                  }
                                }
                                if (_warehousingGreenBeanCtrl.blendNameTECtrl.text.trim() == "") {
                                  final snackBar = CustomDialog().showCustomSnackBar(context, "블렌드명을 입력해 주세요.");
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  return;
                                }

                                String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");
                                String roastingWeight = _warehousingGreenBeanCtrl.roastingWeightTECtrl.text.replaceAll(".", "");

                                // type, name, roasting_weight, date
                                Map<String, String> value = {
                                  "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                  "name": _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                  "roasting_weight": roastingWeight,
                                  "date": date,
                                };

                                bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);

                                if (!mounted) return;
                                final snackBar = CustomDialog().showCustomSnackBar(
                                  context,
                                  insertResult
                                      ? "${_customDatePickerCtrl.date}\n${_warehousingGreenBeanCtrl.roastingType == 1 ? "싱글오리진" : "블렌드"}\n${_warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim()}\n${_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim()}kg\n로스팅 등록이 완료되었습니다."
                                      : "로스팅 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                  bgColor: insertResult ? Colors.green : Colors.red,
                                );

                                if (insertResult) {
                                  _warehousingGreenBeanCtrl.weightTECtrl.clear();
                                  _warehousingGreenBeanCtrl.roastingWeightTECtrl.clear();
                                  _warehousingGreenBeanCtrl.blendNameTECtrl.clear();
                                  _customDatePickerCtrl.setDateToToday();
                                  _warehousingGreenBeanCtrl.initBlendInfo();
                                }

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                return;
                              }

                              // 1
                              print("로스팅");
                              if (_warehousingGreenBeanCtrl.selectedBean == null) {
                                final snackBar = CustomDialog().showCustomSnackBar(context, "투입할 생두를 선택해 주세요.");
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                FocusScope.of(context).requestFocus(FocusNode());
                                return;
                              }
                              if (_warehousingGreenBeanCtrl.weightTECtrl.text.trim() == "") {
                                final snackBar = CustomDialog().showCustomSnackBar(context, "투입량을 입력해 주세요.");
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                _weightFN.requestFocus();
                                return;
                              } else {
                                var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.weightTECtrl.text.trim());
                                _warehousingGreenBeanCtrl.weightTECtrl.text = result["replaceValue"];

                                if (!result["bool"]) {
                                  final snackBar = CustomDialog().showCustomSnackBar(
                                    context,
                                    "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  _weightFN.requestFocus();
                                  return;
                                } else {
                                  // 투입량이랑 보유량이랑 비교하는 로직 부분
                                  var divide = _warehousingGreenBeanCtrl.selectedBean.split(" / ");
                                  int totalWeight = int.parse(divide[1].replaceAll(RegExp("[.kg]"), ""));
                                  int inputWeight = int.parse(_warehousingGreenBeanCtrl.weightTECtrl.text.trim().replaceAll(".", ""));
                                  if (totalWeight < inputWeight) {
                                    final snackBar = CustomDialog().showCustomSnackBar(context, "투입량이 보유량보다 큽니다.\n다시 입력해 주세요.");
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    _weightFN.requestFocus();
                                    return;
                                  }
                                }
                              }
                              if (_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim() == "") {
                                final snackBar = CustomDialog().showCustomSnackBar(context, "배출량을 입력해 주세요.");
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                _roastingWeightFN.requestFocus();
                                return;
                              } else {
                                var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim());
                                _warehousingGreenBeanCtrl.roastingWeightTECtrl.text = result["replaceValue"];

                                if (!result["bool"]) {
                                  final snackBar = CustomDialog().showCustomSnackBar(
                                    context,
                                    "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  _roastingWeightFN.requestFocus();
                                  return;
                                } else {
                                  // 로스팅 후 총량이 투입량보다 낮은지 확인하는 로직 부분
                                  int inputWeight = int.parse(_warehousingGreenBeanCtrl.weightTECtrl.text.trim().replaceAll(".", ""));
                                  int roastingWeight = int.parse(_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim().replaceAll(".", ""));
                                  if (inputWeight <= roastingWeight) {
                                    final snackBar = CustomDialog().showCustomSnackBar(context, "배출량이 투입량과 같거나 클 수 없습니다.\n다시 입력해 주세요.");
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    _roastingWeightFN.requestFocus();
                                    return;
                                  }
                                }
                              }

                              String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");
                              String roastingWeight = _warehousingGreenBeanCtrl.roastingWeightTECtrl.text.replaceAll(".", "");

                              // type, name, roasting_weight, date
                              Map<String, String> value = {
                                "type": _warehousingGreenBeanCtrl.roastingType.toString(),
                                "name": _warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                                "roasting_weight": roastingWeight,
                                "date": date,
                              };

                              bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);

                              if (!mounted) return;
                              final snackBar = CustomDialog().showCustomSnackBar(
                                context,
                                insertResult
                                    ? "${_customDatePickerCtrl.date}\n${_warehousingGreenBeanCtrl.roastingType == 1 ? "싱글오리진" : "블렌드"}\n${_warehousingGreenBeanCtrl.roastingType == 1 ? _warehousingGreenBeanCtrl.selectedBean.split(" / ")[0] : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim()}\n${_warehousingGreenBeanCtrl.roastingWeightTECtrl.text.trim()}kg\n로스팅 등록이 완료되었습니다."
                                    : "로스팅 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                bgColor: insertResult ? Colors.green : Colors.red,
                              );

                              if (insertResult) {
                                _warehousingGreenBeanCtrl.weightTECtrl.clear();
                                _warehousingGreenBeanCtrl.roastingWeightTECtrl.clear();
                                _warehousingGreenBeanCtrl.blendNameTECtrl.clear();
                                _customDatePickerCtrl.setDateToToday();
                              }

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            ),
                            child: Text(
                              "로스팅",
                              style: TextStyle(
                                fontSize: height / 46,
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
