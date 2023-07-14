import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final _dateTECtrl = TextEditingController();

  final _now = DateTime.now();
  String _year = "";
  String _month = "";
  String _day = "";
  String _date = "";

  @override
  void initState() {
    super.initState();
    _year = _now.year.toString();
    _month = _now.month.toString();
    _day = _now.day.toString();
    _date = "$_year-$_month-$_day";
    _dateTECtrl.text = "$_year년 $_month월 $_day일";
  }

  void setDateToToday() {
    _dateTECtrl.text = "${_now.year}년 ${_now.month}월 ${_now.day}일";
    _date = "${_now.year}-${_now.month}-${_now.day}";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Row(
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
              prefixIcon: Icon(
                CupertinoIcons.calendar,
                size: height / 40,
                color: Colors.brown,
              ),
              contentPadding: EdgeInsets.zero,
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
    );
  }
}
