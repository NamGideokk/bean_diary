import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:get/get.dart';

class StockController extends GetxController {
  final RxList _greenBeanStockList = [].obs;
  final RxList _roastingBeanStockList = [].obs;

  get greenBeanStockList => _greenBeanStockList;
  get roastingBeanStockList => _roastingBeanStockList;

  @override
  void onInit() {
    super.onInit();
    getGreenBeanList();
    getRoastingBeanStockList();
  }

  void getGreenBeanList() async {
    final list = await GreenBeanStockSqfLite().getGreenBeanStock();
    if (list.isNotEmpty) _greenBeanStockList(list);
  }

  void getRoastingBeanStockList() async {
    final list = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    if (list.isNotEmpty) _roastingBeanStockList(list);
  }
}
