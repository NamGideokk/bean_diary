import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomDatePickerController customDatePickerCtrl = Get.find<CustomDatePickerController>();
    final height = MediaQuery.of(context).size.height;

    return TextField(
      controller: customDatePickerCtrl.textEditingCtrl,
      readOnly: true,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        prefixIconConstraints: const BoxConstraints(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Icon(
            CupertinoIcons.calendar,
            size: height / 46,
            color: Colors.brown,
            applyTextScaling: true,
          ),
        ),
        suffixIconConstraints: const BoxConstraints(),
        suffixIcon: TextButton(
          onPressed: customDatePickerCtrl.setDateToToday,
          child: Text(
            "오늘",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.brown,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          showDragHandle: true,
          backgroundColor: Colors.white,
          builder: (context) {
            return SizedBox(
              height: height / 3.5,
              child: SafeArea(
                child: CupertinoDatePicker(
                  dateOrder: DatePickerDateOrder.ymd,
                  maximumYear: customDatePickerCtrl.thisYear,
                  initialDateTime: DateTime(
                    customDatePickerCtrl.year,
                    customDatePickerCtrl.month,
                    customDatePickerCtrl.day,
                  ),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (value) {
                    customDatePickerCtrl.setYear(value.year);
                    customDatePickerCtrl.setMonth(value.month);
                    customDatePickerCtrl.setDay(value.day);
                    customDatePickerCtrl.textEditingCtrl.text = "${value.year}년 ${value.month}월 ${value.day}일";
                    customDatePickerCtrl.setDate();
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
