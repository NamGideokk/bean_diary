import 'package:bean_diary/controller/custom_date_picker_controller.dart';
import 'package:bean_diary/controller/warehousing_green_bean_controller.dart';
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

  String _roastingTypeValue = "1";

  @override
  void initState() {
    super.initState();
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
        body: Stack(
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
                          value: "1",
                          groupValue: _roastingTypeValue,
                          selected: _roastingTypeValue == "1" ? true : false,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            print(value);
                            _roastingTypeValue = value!;
                            setState(() {});
                          },
                          title: Text("싱글빈"),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "2",
                          groupValue: _roastingTypeValue,
                          selected: _roastingTypeValue == "2" ? true : false,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            print(value);
                            _roastingTypeValue = value!;
                            setState(() {});
                          },
                          title: const Text("블렌드"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const HeaderTitle(title: "투입 생두 정보", subTitle: "input green bean information"),
                  const BeanSelectDropdownButton(listType: 2),
                  Row(
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
                  ),
                  const SizedBox(height: 15),
                  _roastingTypeValue == "1"
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.center,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add_circle_outline_sharp,
                              size: height / 40,
                            ),
                            label: const Text("생두 추가"),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1.5,
                                color: Colors.brown[300]!,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  const WeightAlert(),
                  const SizedBox(height: 20),
                  if (_roastingTypeValue == "2")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _warehousingGreenBeanCtrl.blendNameTECtrl,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: "블렌드명",
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
                                _warehousingGreenBeanCtrl.greenBeanStockList.forEach((e) {
                                  if (e.containsKey(divide[0])) {
                                    print(e);
                                  }
                                });
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
                              }
                            }

                            String date = _customDatePickerCtrl.date.replaceAll(RegExp("[년 월 일 ]"), "-");
                            String roastingWeight = _warehousingGreenBeanCtrl.weightTECtrl.text.replaceAll(".", "");

                            // type, name, roasting_weight, date
                            Map<String, dynamic> value = {
                              "type": _roastingTypeValue,
                              "name": _roastingTypeValue == "1" ? _warehousingGreenBeanCtrl.selectedBean : _warehousingGreenBeanCtrl.blendNameTECtrl.text.trim(),
                              "roasting_weight": roastingWeight,
                              "date": date,
                            };
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
    );
  }
}
