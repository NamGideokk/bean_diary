import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DataManagementController extends GetxController {
  RxList _greenBeans = [].obs;
  RxList _greenBeanStock = [].obs;
  RxList _roastingBeanStock = [].obs;
  RxList _salesHistory = [].obs;

  final backupDataTECtrl = TextEditingController();
  final backupDataFN = FocusNode();

  get greenBeans => _greenBeans;
  get greenBeanStock => _greenBeanStock;
  get roastingBeanStock => _roastingBeanStock;
  get salesHistory => _salesHistory;

  Future<void> getGreenBeans() async {
    final list = await GreenBeansSqfLite().getGreenBeans();
    if (list.isNotEmpty) _greenBeans(list);
  }

  Future<void> getGreenBeanStock() async {
    final list = await GreenBeanStockSqfLite().getGreenBeanStock();
    if (list.isNotEmpty) _greenBeanStock(list);
  }

  Future<void> getRoastingBeanStock() async {
    final list = await RoastingBeanStockSqfLite().getRoastingBeanStock();
    if (list.isNotEmpty) _roastingBeanStock(list);
  }

  Future<void> getSalesHistory() async {
    final list = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
    if (list.isNotEmpty) _salesHistory(list);
  }
}
