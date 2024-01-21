import 'dart:convert';

import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DataManagementController extends GetxController {
  final RxList _greenBeans = [].obs;
  final RxList _greenBeanStock = [].obs;
  final RxList _roastingBeanStock = [].obs;
  final RxList _salesHistory = [].obs;

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

  Future<Map<String, dynamic>> getBackupData(int type) async {
    List list;
    String title;
    switch (type) {
      case 0:
        await getGreenBeans();
        list = greenBeans;
        title = "생두 목록";
        break;
      case 1:
        await getGreenBeanStock();
        list = greenBeanStock;
        title = "생두 재고";
        break;
      case 2:
        await getRoastingBeanStock();
        list = roastingBeanStock;
        title = "원두 재고";
        break;
      case 3:
        await getSalesHistory();
        list = salesHistory;
        title = "판매 내역";
        break;
      default:
        return {"bool": false, "title": "없음"};
    }
    if (list.isEmpty) {
      return {"bool": false, "title": title};
    } else {
      final jsonString = jsonEncode({title: list});
      Clipboard.setData(ClipboardData(text: jsonString));
      return {"bool": true, "title": title};
    }
  }
}
