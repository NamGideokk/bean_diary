import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            height: height / 10,
            width: width >= 700 ? width / 2 : null,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                CupertinoDatePicker(
                  key: _key,
                  mode: CupertinoDatePickerMode.date,
                  dateOrder: DatePickerDateOrder.ymd,
                  maximumYear: CustomDatePickerController.to.thisYear,
                  initialDateTime: DateTime(
                    CustomDatePickerController.to.year,
                    CustomDatePickerController.to.month,
                    CustomDatePickerController.to.day,
                  ),
                  onDateTimeChanged: (value) {
                    CustomDatePickerController.to.setYear(value.year);
                    CustomDatePickerController.to.setMonth(value.month);
                    CustomDatePickerController.to.setDay(value.day);
                    CustomDatePickerController.to.setDate();
                  },
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    shadowColor: Colors.black,
                    elevation: 2,
                  ),
                  onPressed: () {
                    CustomDatePickerController.to.setDateToToday();
                    setState(() {
                      _key = UniqueKey();
                    });
                  },
                  icon: Icon(
                    Icons.restart_alt_rounded,
                    size: height / 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
