import 'dart:convert';

import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/screens/register_green_bean.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/keyboard_dismiss.dart';
import 'package:bean_diary/widgets/usage_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GreenBeanWarehousingMain extends StatefulWidget {
  const GreenBeanWarehousingMain({Key? key}) : super(key: key);

  @override
  State<GreenBeanWarehousingMain> createState() => _GreenBeanWarehousingMainState();
}

class _GreenBeanWarehousingMainState extends State<GreenBeanWarehousingMain> {
  final CustomDatePickerController _customDatePickerCtrl = Get.put(CustomDatePickerController());
  final WarehousingGreenBeanController _warehousingGreenBeanCtrl = Get.put(WarehousingGreenBeanController());
  final _companyFN = FocusNode();
  final _nameFN = FocusNode();
  final _weightFN = FocusNode();
  final _scrollCtrl = ScrollController();

  void allValueInit() {
    FocusScope.of(context).requestFocus(FocusNode());
    _customDatePickerCtrl.setDateToToday();
    _warehousingGreenBeanCtrl.companyTECtrl.clear();
    _warehousingGreenBeanCtrl.weightTECtrl.clear();
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
    return KeyboardDismiss(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("생두 입고 관리"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const ClampingScrollPhysics(),
              controller: _scrollCtrl,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderTitle(title: "입고 일자", subTitle: "warehousing day"),
                        const CustomDatePicker(),
                        const SizedBox(height: 20),
                        const HeaderTitle(title: "입고처", subTitle: "company name"),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _warehousingGreenBeanCtrl.companyTECtrl,
                          focusNode: _companyFN,
                          decoration: const InputDecoration(
                            hintText: "업체명",
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        const HeaderTitle(title: "생두 정보", subTitle: "green bean information"),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterGreenBean(),
                              ),
                            ),
                            child: const Text("생두 등록 / 관리"),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              flex: 4,
                              child: BeanSelectDropdownButton(listType: 0),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 2,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _warehousingGreenBeanCtrl.weightTECtrl,
                                focusNode: _weightFN,
                                style: Theme.of(context).textTheme.bodyMedium,
                                decoration: const InputDecoration(
                                  hintText: "입고 중량",
                                  suffixText: "kg",
                                ),
                                onTap: () => Utility().moveScrolling(_scrollCtrl),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const UsageAlertWidget(),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
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
                                if (_warehousingGreenBeanCtrl.companyTECtrl.text.trim() == "") {
                                  CustomDialog().showSnackBar(context, "입고처(업체명)를 입력해 주세요.");
                                  _companyFN.requestFocus();
                                  return;
                                }
                                if (_warehousingGreenBeanCtrl.selectedBean == "" || _warehousingGreenBeanCtrl.selectedBean == null) {
                                  CustomDialog().showSnackBar(context, "생두를 선택해 주세요.");
                                  _nameFN.requestFocus();
                                  return;
                                }
                                if (_warehousingGreenBeanCtrl.weightTECtrl.text.trim() == "") {
                                  CustomDialog().showSnackBar(context, "중량을 입력해 주세요.");
                                  _weightFN.requestFocus();
                                  return;
                                }

                                var result = Utility().checkWeightRegEx(_warehousingGreenBeanCtrl.weightTECtrl.text.trim());
                                _warehousingGreenBeanCtrl.weightTECtrl.text = result["replaceValue"];

                                if (!result["bool"]) {
                                  CustomDialog().showSnackBar(
                                    context,
                                    "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                    isError: true,
                                  );
                                  _weightFN.requestFocus();
                                  return;
                                }

                                String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");
                                String weight = _warehousingGreenBeanCtrl.weightTECtrl.text.replaceAll(".", "");
                                String history = jsonEncode([
                                  {
                                    "date": date,
                                    "company": _warehousingGreenBeanCtrl.companyTECtrl.text.trim(),
                                    "weight": weight,
                                  },
                                ]);

                                Map<String, String> value = {
                                  "name": _warehousingGreenBeanCtrl.selectedBean,
                                  "weight": weight,
                                  "history": history,
                                };

                                var insertResult = await GreenBeanStockSqfLite().insertGreenBeanStock(value);

                                if (!mounted) return;
                                CustomDialog().showSnackBar(
                                  context,
                                  insertResult
                                      ? "${_customDatePickerCtrl.textEditingCtrl.text}\n" +
                                          "${_warehousingGreenBeanCtrl.companyTECtrl.text.trim()}\n" +
                                          "${_warehousingGreenBeanCtrl.selectedBean}\n" +
                                          "${_warehousingGreenBeanCtrl.weightTECtrl.text}kg\n" +
                                          "입고 등록이 완료되었습니다."
                                      : "입고 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                  isError: insertResult ? false : true,
                                );

                                if (insertResult) allValueInit();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              ),
                              child: Text(
                                "입고 등록",
                                style: TextStyle(
                                  fontSize: height / 50,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
