import 'package:bean_diary/sqflite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasting_bean_stock_sqf_lite.dart';
import 'package:get/get.dart';

class StockController extends GetxController {
  RxList _greenBeanStockList = [].obs;
  RxList _roastingBeanStockList = [].obs;

  get greenBeanStockList => _greenBeanStockList;
  get roastingBeanStockList => _roastingBeanStockList;

  @override
  void onInit() {
    super.onInit();
    print("⭕️ STOCK CONTROLLER INIT");
    getGreenBeanList();
    getRoastingBeanStockList();
  }

  void getGreenBeanList() async {
    await GreenBeanStockSqfLite().openDB();
    final list = await GreenBeanStockSqfLite().getGreenBeanStock();
    print("🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸 생 두 재 고 🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸🇺🇸\n$list");
    if (list.isNotEmpty) _greenBeanStockList(list);
  }

  void getRoastingBeanStockList() async {
    await RoastingBeanStockSqfLite().openDB();
    final list = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    print("🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵 원 두 재 고 🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵🇰🇵\n$list");
    if (list.isNotEmpty) _roastingBeanStockList(list);
  }

  @override
  void onClose() {
    super.onClose();
    print("❌ STOCK CONTROLLER CLOSE");
  }
}
