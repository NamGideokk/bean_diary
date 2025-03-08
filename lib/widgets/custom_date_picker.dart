import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final CustomDatePickerController customDatePickerCtrl = Get.find<CustomDatePickerController>();
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[100],
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            elevation: 0.5,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            customDatePickerCtrl.setDateToToday();
            setState(() {
              _key = UniqueKey();
            });
          },
          icon: Icon(
            Icons.restart_alt_rounded,
            size: height / 40,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: height / 10,
          child: CupertinoDatePicker(
            key: _key,
            mode: CupertinoDatePickerMode.date,
            dateOrder: DatePickerDateOrder.ymd,
            maximumYear: customDatePickerCtrl.thisYear,
            initialDateTime: DateTime(
              customDatePickerCtrl.year,
              customDatePickerCtrl.month,
              customDatePickerCtrl.day,
            ),
            onDateTimeChanged: (value) {
              customDatePickerCtrl.setYear(value.year);
              customDatePickerCtrl.setMonth(value.month);
              customDatePickerCtrl.setDay(value.day);
              customDatePickerCtrl.setDate();
            },
          ),
        ),
      ],
    );
  }
}
