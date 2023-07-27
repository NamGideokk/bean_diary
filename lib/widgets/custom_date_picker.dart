import 'package:bean_diary/controller/custom_date_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomDatePickerController customDatePickerCtrl = Get.find<CustomDatePickerController>();
    final height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: customDatePickerCtrl.textEditingCtrl,
            readOnly: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: height / 52,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                CupertinoIcons.calendar,
                size: height / 40,
                color: Colors.brown,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: customDatePickerCtrl.setDateToToday,
          child: const Text("오늘"),
        ),
        const SizedBox(width: 5),
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              backgroundColor: Colors.white,
              builder: (context) {
                return SizedBox(
                  height: height / 3.5,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (value) {
                      customDatePickerCtrl.setYear(value.year.toString());
                      customDatePickerCtrl.setMonth(value.month.toString());
                      customDatePickerCtrl.setDay(value.day.toString());
                      customDatePickerCtrl.textEditingCtrl.text = "${value.year}년 ${value.month}월 ${value.day}일";
                      customDatePickerCtrl.setDate();
                    },
                  ),
                );
              },
            );
          },
          child: const Text("날짜 선택"),
        ),
      ],
    );
  }
}
