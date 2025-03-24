import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_history_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  final RxList _greenBeanInventory = [].obs;
  final RxList _roastingBeanStockList = [].obs;
  final RxBool _isConvert = true.obs;

  get greenBeanInventory => _greenBeanInventory;
  get roastingBeanStockList => _roastingBeanStockList;
  get isConvert => _isConvert.value;

  @override
  void onInit() {
    super.onInit();
    getGreenBeanInventory();
    getRoastingBeanStockList();
  }

  void getGreenBeanInventory() async {
    final list = await GreenBeanInventorySqfLite().getGreenBeanInventory();
    List copyList = list.map((e) => Map.from(e)).toList();
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        copyList[i]["history"] = await GreenBeanInventoryHistorySqfLite().getInventoryHistories(list[i]["id"]);
      }
    }
    _greenBeanInventory(copyList);
  }

  void getRoastingBeanStockList() async {
    final list = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    if (list.isNotEmpty) {
      List singles = [];
      List blends = [];
      for (final item in Utility().sortingName(list)) {
        item["type"] == "1" ? singles.add(item) : blends.add(item);
      }
      _roastingBeanStockList.insertAll(0, singles);
      _roastingBeanStockList.addAll(blends);
    }
  }

  /// 25-03-19
  ///
  /// 상세 내역의 누적량 구하기
  String getHistoryTotal(List list) {
    int sum = 0;
    for (final item in list) {
      sum += item["weight"] as int ?? item["roasting_weight"] as int;
    }
    return isConvert ? Utility().convertWeightUnit(Utility().parseToDoubleWeight(sum)) : "${Utility().numberFormat(Utility().parseToDoubleWeight(sum))}kg";
  }

  /// 25-03-19
  ///
  /// 상세 내역 누적량 표현 형식 변환하기
  void setChangeIsConvert() => _isConvert(!isConvert);
}
