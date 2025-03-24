import 'package:bean_diary/sqflite/green_bean_inventory_history_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_history_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:get/get.dart';

class InventoryController extends GetxController {
  final RxList _greenBeanInventory = [].obs;
  final RxList _roastedBeanInventory = [].obs;
  final RxBool _isConvert = true.obs;

  get greenBeanInventory => _greenBeanInventory;
  get roastedBeanInventory => _roastedBeanInventory;
  get isConvert => _isConvert.value;

  @override
  void onInit() {
    super.onInit();
    getGreenBeanInventory();
    getRoastedBeanInventory();
  }

  void getGreenBeanInventory() async {
    final list = await GreenBeanInventorySqfLite().getGreenBeanInventory();
    List copyList = [];
    if (list.isNotEmpty) {
      copyList = list.map((e) => Map.from(e)).toList();
      copyList = Utility().sortingName(copyList);
      for (int i = 0; i < list.length; i++) {
        copyList[i]["history"] = await GreenBeanInventoryHistorySqfLite().getInventoryHistories(list[i]["id"]);
      }
    }
    _greenBeanInventory(copyList);
  }

  void getRoastedBeanInventory() async {
    final list = await RoastedBeanInventorySqfLite().getRoastedBeanInventory();
    List copyList = [];
    List singles = [];
    List blends = [];
    if (list.isNotEmpty) {
      copyList = list.map((e) => Map.from(e)).toList();
      copyList = Utility().sortingName(copyList);
      for (int i = 0; i < list.length; i++) {
        copyList[i]["history"] = await RoastedBeanInventoryHistorySqfLite().getInventoryHistories(list[i]["id"]);
        copyList[i]["type"] == "1" ? singles.add(copyList[i]) : blends.add(copyList[i]);
      }
      _roastedBeanInventory.insertAll(0, singles);
      _roastedBeanInventory.addAll(blends);
    }
  }

  /// 25-03-19
  ///
  /// 상세 내역의 누적량 구하기
  String getHistoryTotal(List list) {
    int sum = 0;
    for (final item in list) {
      sum += item["weight"] as int;
    }
    return isConvert ? Utility().convertWeightUnit(Utility().parseToDoubleWeight(sum)) : "${Utility().numberFormat(Utility().parseToDoubleWeight(sum))}kg";
  }

  /// 25-03-19
  ///
  /// 상세 내역 누적량 표현 형식 변환하기
  void setChangeIsConvert() => _isConvert(!isConvert);
}
