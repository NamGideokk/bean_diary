import 'package:bean_diary/controller/sale_history_controller.dart';
import 'package:bean_diary/controller/year_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomYearPicker extends StatelessWidget {
  const CustomYearPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final saleHistoryCtrl = Get.find<SaleHistoryController>();
    final yearPickerCtrl = Get.find<YearPickerController>();
    final now = DateTime.now();

    return Container(
      height: height / 3.5,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: SafeArea(
        child: YearPicker(
          currentDate: now,
          initialDate: now,
          firstDate: DateTime(2000),
          lastDate: now,
          selectedDate: now,
          onChanged: (value) {
            yearPickerCtrl.setSelectedYear(value.year);
            saleHistoryCtrl.calcYearTotalSalesWeight(value.year);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
