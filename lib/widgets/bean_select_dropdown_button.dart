import 'package:bean_diary/sqflite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';

class BeanSelectDropdownButton extends StatefulWidget {
  final int listType;

  /// int listType :
  /// * 0 = 생두(green bean)
  /// * 1 = 원두(coffee bean)
  const BeanSelectDropdownButton({
    Key? key,
    required this.listType,
  }) : super(key: key);

  @override
  State<BeanSelectDropdownButton> createState() => _BeanSelectDropdownButtonState();
}

class _BeanSelectDropdownButtonState extends State<BeanSelectDropdownButton> {
  final _beanSelectFN = FocusNode();
  String? _selectedValue;
  String _name = ""; // 필요한지 확인
  List _beanList = [];

  getBeanList() async {
    switch (widget.listType) {
      case 0: // 생두
        {
          await GreenBeansSqfLite().openDB();
          List beanList = await GreenBeansSqfLite().getGreenBeans();
          if (beanList.isNotEmpty) beanList = Utility().sortingName(beanList);
          _beanList = beanList;
          setState(() {});
          return;
        }
      case 1: // 원두
        {
          // 원두 목록 가져오기
          // await GreenBeansSqfLite().openDB();
          // List beanList = await GreenBeansSqfLite().getGreenBeans();
          // if (beanList.isNotEmpty) beanList = Utility().sortingName(beanList);
          // _beanList = beanList;
          // setState(() {});
          // return;
        }
      default:
        return _beanList;
    }
  }

  @override
  void initState() {
    super.initState();
    getBeanList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
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
        focusNode: _beanSelectFN,
        disabledHint: Text(
          widget.listType == 0 ? "생두를 등록해 주세요" : "로스팅된 원두가 없습니다",
          style: TextStyle(
            fontSize: height / 52,
          ),
        ),
        underline: const SizedBox(),
        value: _selectedValue,
        menuMaxHeight: height / 3,
        dropdownColor: Colors.brown[50],
        borderRadius: BorderRadius.circular(5),
        style: TextStyle(
          fontSize: height / 52,
          color: Colors.black,
        ),
        iconEnabledColor: Colors.brown,
        hint: Text(widget.listType == 0 ? "생두 선택" : "원두 선택"),
        items: _beanList.length > 0
            ? _beanList.map<DropdownMenuItem<dynamic>>((e) {
                return DropdownMenuItem<dynamic>(
                  value: e?["name"],
                  child: Text(e?["name"]),
                );
              }).toList()
            : [],
        onChanged: (value) {
          print(value);
          _selectedValue = value.toString();
          _name = value.toString();
          setState(() {});
        },
      ),
    );
  }
}
