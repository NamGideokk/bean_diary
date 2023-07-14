import 'dart:convert';

import 'package:bean_diary/sqflite/green_bean_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/regist_green_bean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreenBeanManagementMain extends StatefulWidget {
  const GreenBeanManagementMain({Key? key}) : super(key: key);

  @override
  State<GreenBeanManagementMain> createState() => _GreenBeanManagementMainState();
}

class _GreenBeanManagementMainState extends State<GreenBeanManagementMain> {
  late final SharedPreferences _pref;
  final _dateTECtrl = TextEditingController();
  final _greenBeanNameTECtrl = TextEditingController();
  final _weightTECtrl = TextEditingController();
  final _beanNameFN = FocusNode();
  final _weightFN = FocusNode();

  final _now = DateTime.now();
  String _year = "";
  String _month = "";
  String _day = "";
  String _date = "";
  String _greenBeanName = "";
  String _weight = "";

  List _greenBeans = [];
  String? _selectValue;

  @override
  void initState() {
    super.initState();
    print("🙌 GREEN BEAN MANAGEMENT MAIN INIT");
    getGreenBeansToDB();
    getSharedPreferences();
    _year = _now.year.toString();
    _month = _now.month.toString();
    _day = _now.day.toString();
    _date = "$_year-$_month-$_day";
    _dateTECtrl.text = "$_year년 $_month월 $_day일";
  }

  Future getSharedPreferences() async {
    _pref = await SharedPreferences.getInstance();
  }

  Future getGreenBeansToDB() async {
    print("생 두 목 록 DB에서 가 져 오 기~~~~~~~~~~~~~~₩");
    _greenBeans = await GreenBeanSqfLite().getGreenBeans();
  }

  void setDateToToday() {
    _dateTECtrl.text = "${_now.year}년 ${_now.month}월 ${_now.day}일";
    _date = "${_now.year}-${_now.month}-${_now.day}";
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
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(title: "입고 일자", subTitle: "warehousing day"),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                          controller: _dateTECtrl,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
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
                            prefixIconConstraints: BoxConstraints(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: setDateToToday,
                        child: Text("오늘"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          print("날짜 선택");
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (context) {
                              return SizedBox(
                                height: height / 3.5,
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
                    decoration: InputDecoration(
                      hintText: "업체명",
                    ),
                    style: TextStyle(
                      fontSize: height / 52,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const HeaderTitle(title: "생두 정보", subTitle: "green bean information"),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            showDragHandle: true,
                            backgroundColor: Colors.brown[50],
                            builder: (context) => const RegistGreenBean(),
                          );
                        },
                        child: Text("생두 등록"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: height * 0.05,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.brown[200]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButton(
                              isExpanded: true,
                              disabledHint: Text("생두를 등록해 주세요"),
                              underline: const SizedBox(),
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              value: _selectValue,
                              menuMaxHeight: height / 3,
                              dropdownColor: Colors.brown[50],
                              borderRadius: BorderRadius.circular(5),
                              style: TextStyle(
                                fontSize: height / 70,
                                color: Colors.black,
                              ),
                              iconEnabledColor: Colors.brown,
                              hint: Text("생두 선택"),
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
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          height: height * 0.05,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _weightTECtrl,
                            focusNode: _weightFN,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: height / 52,
                            ),
                            decoration: InputDecoration(
                              hintText: "중량",
                              suffixText: "kg",
                              suffixStyle: TextStyle(
                                fontSize: height / 60,
                              ),
                            ),
                            onChanged: (value) {
                              _weight = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          print("초기화");
                          setDateToToday();
                          _greenBeanNameTECtrl.clear();
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
                            print("입고");
                            if (_greenBeanNameTECtrl.text.trim() == "") {
                              final snackBar = CustomDialog().showCustomSnackBar(context, "원두명을 입력해 주세요.");
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              _beanNameFN.requestFocus();
                              return;
                            }
                            if (_weightTECtrl.text.trim() == "") {
                              final snackBar = CustomDialog().showCustomSnackBar(context, "무게를 입력해 주세요.");
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              _weightFN.requestFocus();
                              return;
                            }

                            _greenBeanName = _greenBeanNameTECtrl.text.trim();
                            _weight = _weightTECtrl.text.trim();

                            Map<String, String> data = {
                              "type": "green_bean_stock",
                              "date": _date,
                              "beanName": _greenBeanName,
                              "weight": _weight,
                            };

                            final jsonData = jsonEncode(data);
                            var getData = await _pref.getStringList("warehousing");
                            List dataList = [];
                            if (getData != null) {
                              for (var item in getData) {
                                print(item);
                                dataList.add(item);
                              }
                            }

                            await _pref.setStringList("warehousing", [...dataList, jsonData]);

                            final snackBar = CustomDialog().showCustomSnackBar(context, "$_date\n${_greenBeanNameTECtrl.text.trim()}\n${_weight}");
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            return Navigator.pop(context);
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
            ],
          ),
        ),
      ),
    );
  }
}
