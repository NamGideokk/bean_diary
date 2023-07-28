import 'package:bean_diary/sqflite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:get/get.dart';

class SaleHistoryController extends GetxController {
  RxList _showList = [].obs;
  RxList _totalList = [].obs;
  RxList _singleList = [].obs;
  RxList _blendList = [].obs;

  RxString _filterValue = "전체".obs;

  get showList => _showList;
  get totalList => _totalList;
  get singleList => _singleList;
  get blendList => _blendList;

  get filterValue => _filterValue.value;

  @override
  void onInit() {
    super.onInit();
    getSaleHistory();
  }

  void getSaleHistory() async {
    List list = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
    if (list.isNotEmpty) {
      list = Utility().sortingDate(list);
      for (var item in list) {
        if (item["type"] == "1") {
          _singleList.add(item);
        } else {
          _blendList.add(item);
        }
      }
      _totalList(list);
      _showList([..._totalList]);
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

  @override
  void onClose() {
    super.onClose();
  }
}
