import 'dart:io';

import 'package:bean_diary/sqflite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/regist_green_bean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GreenBeanManagementMain extends StatefulWidget {
  const GreenBeanManagementMain({Key? key}) : super(key: key);

  @override
  State<GreenBeanManagementMain> createState() => _GreenBeanManagementMainState();
}

class _GreenBeanManagementMainState extends State<GreenBeanManagementMain> {
  final _dateTECtrl = TextEditingController();
  final _companyTECtrl = TextEditingController();
  final _weightTECtrl = TextEditingController();
  final _companyFN = FocusNode();
  final _nameFN = FocusNode();
  final _weightFN = FocusNode();

  final _now = DateTime.now();
  String _year = "";
  String _month = "";
  String _day = "";
  String _date = "";
  String _company = "";
  String _name = "";
  String _weight = "";

  List _greenBeans = [];
  String? _selectValue;

  @override
  void initState() {
    super.initState();
    print("🙌 GREEN BEAN MANAGEMENT MAIN INIT");
    GreenBeanStockSqfLite().openDB();
    GreenBeansSqfLite().openDB();
    getGreenBeansToDB();
    _year = _now.year.toString();
    _month = _now.month.toString();
    _day = _now.day.toString();
    _date = "$_year-$_month-$_day";
    _dateTECtrl.text = "$_year년 $_month월 $_day일";
  }

  Future getGreenBeansToDB() async {
    _greenBeans = await GreenBeansSqfLite().getGreenBeans();
  }

  void setDateToToday() {
    _dateTECtrl.text = "${_now.year}년 ${_now.month}월 ${_now.day}일";
    _date = "${_now.year}-${_now.month}-${_now.day}";
    setState(() {});
  }

  void initValue() {
    setDateToToday();
    _companyTECtrl.clear();
    _name = "";
    _selectValue = null;
    _weightTECtrl.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "생두 입고 관리",
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const ClampingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderTitle(title: "입고 일자", subTitle: "warehousing day"),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _dateTECtrl,
                                readOnly: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: height / 52,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                      CupertinoIcons.calendar,
                                      size: height / 46,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: setDateToToday,
                              child: Text("오늘"),
                            ),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: () {
                                print("날짜 선택");
                                showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  backgroundColor: Colors.white,
                                  builder: (context) {
                                    return SizedBox(
                                      height: height / 3.5,
                                      child: SafeArea(
                                        child: CupertinoDatePicker(
                                          initialDateTime: DateTime.now(),
                                          mode: CupertinoDatePickerMode.date,
                                          onDateTimeChanged: (value) {
                                            _year = value.year.toString();
                                            _month = value.month.toString();
                                            _day = value.day.toString();
                                            _dateTECtrl.text = "$_year년 $_month월 $_day일";
                                            _date = "$_year-$_month-$_day";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("날짜 선택"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const HeaderTitle(title: "입고처", subTitle: "company name"),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _companyTECtrl,
                          focusNode: _companyFN,
                          decoration: InputDecoration(
                            hintText: "업체명",
                          ),
                          style: TextStyle(
                            fontSize: height / 52,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const HeaderTitle(title: "생두 정보", subTitle: "green bean information"),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegistGreenBean(),
                                ),
                              );
                            },
                            child: Text("생두 등록 / 관리"),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.brown[100]!,
                                    width: 0.8,
                                  ),
                                  color: Colors.brown[50],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: DropdownButton(
                                  isExpanded: true,
                                  focusNode: _nameFN,
                                  disabledHint: Text(
                                    "생두를 등록해 주세요",
                                    style: TextStyle(
                                      fontSize: height / 52,
                                    ),
                                  ),
                                  // isDense: true,
                                  underline: const SizedBox(),
                                  value: _selectValue,
                                  menuMaxHeight: height / 3,
                                  dropdownColor: Colors.brown[50],
                                  borderRadius: BorderRadius.circular(5),
                                  style: TextStyle(
                                    fontSize: height / 52,
                                    color: Colors.black,
                                  ),
                                  iconEnabledColor: Colors.brown,
                                  hint: const Text("생두 선택"),
                                  // items: _mssCtrl.dynamicSiDoList.map<DropdownMenuItem<String>>((String value) {
                                  //   return DropdownMenuItem<String>(
                                  //     value: value,
                                  //     child: Text(
                                  //       _mssCtrl.extractName(value),
                                  //       style: TextStyle(
                                  //         fontSize: height / 56,
                                  //       ),
                                  //     ),
                                  //   );
                                  // }).toList(),
                                  items: _greenBeans.length > 0
                                      ? _greenBeans.map<DropdownMenuItem<dynamic>>((e) {
                                          return DropdownMenuItem<dynamic>(
                                            value: e["name"],
                                            child: Text(e["name"]),
                                          );
                                        }).toList()
                                      : [],
                                  onChanged: (value) {
                                    print(value);
                                    _selectValue = value.toString();
                                    _name = value.toString();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              flex: 2,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _weightTECtrl,
                                focusNode: _weightFN,
                                keyboardType: Platform.isAndroid ? TextInputType.number : null,
                                style: TextStyle(
                                  fontSize: height / 52,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "중량",
                                  suffixText: "kg",
                                ),
                                onChanged: (value) {
                                  _weight = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: height / 30,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "중량은 반드시 소수점을 포함해\n첫째 자리까지 입력해 주세요.\n예) 100kg > 100.0, 100.7kg > 100.7\n* 10g 이하 단위는 지원하지 않습니다.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: height / 58,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
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
                            onPressed: () {
                              print("초기화");
                              setDateToToday();
                              _weightTECtrl.clear();
                              setState(() {});
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
                                print("입고 날짜 ::: ${_dateTECtrl.text}");
                                if (_companyTECtrl.text.trim() == "") {
                                  final snackBar = CustomDialog().showCustomSnackBar(context, "입고처(업체명)를 입력해 주세요.");
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  _companyFN.requestFocus();
                                  return;
                                }
                                if (_name == "") {
                                  final snackBar = CustomDialog().showCustomSnackBar(context, "생두를 선택해 주세요.");
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  _nameFN.requestFocus();
                                  return;
                                }
                                if (_weightTECtrl.text.trim() == "") {
                                  final snackBar = CustomDialog().showCustomSnackBar(context, "중량을 입력해 주세요.");
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  _weightFN.requestFocus();
                                  return;
                                }

                                var result = Utility().checkWeightRegEx(_weightTECtrl.text.trim());
                                _weightTECtrl.text = result["replaceValue"];

                                if (!result["bool"]) {
                                  final snackBar = CustomDialog().showCustomSnackBar(
                                    context,
                                    "중량 입력 형식이 맞지 않습니다.\n하단의 안내 문구대로 입력해 주세요.",
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  _weightFN.requestFocus();
                                  return;
                                }

                                String date = _date.replaceAll(RegExp("[년 월 일 ]"), "-");
                                String weight = _weight.replaceAll(".", "");

                                Map<String, String> value = {
                                  "name": _name,
                                  "weight": weight,
                                  "date": date,
                                  "company": _companyTECtrl.text.trim(),
                                };

                                var insertResult = await GreenBeanStockSqfLite().insertGreenBeanStock(value);

                                if (!mounted) return;
                                final snackBar = CustomDialog().showCustomSnackBar(
                                  context,
                                  insertResult ? "$_date\n${_companyTECtrl.text.trim()}\n$_name\n${_weightTECtrl.text}kg\n입고 등록이 완료되었습니다." : "입고 등록에 실패했습니다.\n입력값을 확인하시거나 잠시 후 다시 시도해 주세요.",
                                  bgColor: insertResult ? Colors.green : Colors.red,
                                );

                                if (insertResult) {
                                  initValue();
                                  FocusScope.of(context).requestFocus(FocusNode());
                                }

                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              ),
                              child: Text(
                                "입고",
                                style: TextStyle(
                                  fontSize: height / 46,
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
