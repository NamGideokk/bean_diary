import 'package:bean_diary/sqflite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SaleHistoryController extends GetxController {
  final RxList _showList = [].obs;
  final RxList _totalList = [].obs;
  final RxList _singleList = [].obs;
  final RxList _blendList = [].obs;

  final RxString _filterValue = "전체".obs;
  final RxInt _totalWeightForYear = 0.obs;

  get showList => _showList;
  get totalList => _totalList;
  get singleList => _singleList;
  get blendList => _blendList;

  get filterValue => _filterValue.value;
  get totalWeightForYear => _totalWeightForYear.value;

  @override
  void onInit() {
    super.onInit();
    getSaleHistory();
  }

  void getSaleHistory() async {
    List list = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
    List sortingList;
    if (list.isNotEmpty) {
      sortingList = Utility().sortingDate(list);
      for (var item in sortingList) {
        if (item["type"] == "1") {
          _singleList.add(item);
        } else {
          _blendList.add(item);
        }
      }
      _totalList(sortingList);
      _showList([..._totalList]);
      calcYearTotalSalesWeight(DateTime.now().year);
    } else {
      _totalList.clear();
      _showList.clear();
    }
  }

  void setChangeFilterValue(String value) {
    _filterValue(value);
    switch (value) {
      case "전체":
        _showList(_totalList);
        return;
      case "싱글오리진":
        _showList(_singleList);
        return;
      case "블렌드":
        _showList(_blendList);
        return;
      default:
        _showList(_totalList);
    }
  }

  void setReverseDate() {
    List revList = _showList.reversed.toList();
    _showList(revList);
  }

  void calcYearTotalSalesWeight(int year) {
    int totalWeight = 0;
    for (var e in _totalList) {
      if (e["date"].toString().substring(0, 4) == year.toString()) {
        totalWeight += int.parse(e["sales_weight"].toString());
      }
    }
    _totalWeightForYear(totalWeight);
  }

  void scrollToTop(ScrollController ctrl) {
    if (ctrl.hasClients && ctrl.offset != 0.0) {
      ctrl.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
