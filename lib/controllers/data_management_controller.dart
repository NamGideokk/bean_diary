import 'dart:convert';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DataManagementController extends GetxController {
  final backupDataTECtrl = TextEditingController();
  final backupDataFN = FocusNode();

  final RxList _greenBeans = [].obs;
  final RxList _greenBeanInventory = [].obs;
  final RxList _roastedBeanInventory = [].obs;
  final RxList _salesHistory = [].obs;
  final RxList _hasDataOpacities = [0.0, 0.0, 0.0, 0.0].obs;
  final RxList _noDataOpacities = [0.0, 0.0, 0.0, 0.0].obs;

  get greenBeans => _greenBeans;
  get greenBeanInventory => _greenBeanInventory;
  get roastedBeanInventory => _roastedBeanInventory;
  get salesHistory => _salesHistory;
  get hasDataOpacities => _hasDataOpacities;
  get noDataOpacities => _noDataOpacities;

  /// 25-03-26
  ///
  /// 데이터 백업하기
  Future backupData(BuildContext context, int type) async {
    String title = type == 0
        ? "생두 목록"
        : type == 1
            ? "생두 재고"
            : type == 2
                ? "원두 재고"
                : "판매 내역";
    bool hasData = true;
    String jsonString = "";
    if (type == 0) {
      // 생두 목록
      final list = await GreenBeansSqfLite().getGreenBeans();
      _greenBeans(list);
      if (list.isNotEmpty) {
        hasData = true;
        jsonString = jsonEncode({title: list});
      } else {
        hasData = false;
      }
      print("🥦🤤 $list");
    } else if (type == 1) {
      // 생두 재고
      final list = await GreenBeanInventorySqfLite().getGreenBeanInventory();
      // history 추가 필요
      _greenBeanInventory(list);
      if (list.isNotEmpty) {
        hasData = true;
        jsonString = jsonEncode({title: list});
      } else {
        hasData = false;
      }
      print("🥦🤤 $list");
    } else if (type == 2) {
      // 원두 재고
      final list = await RoastedBeanInventorySqfLite().getRoastedBeanInventory();
      _roastedBeanInventory(list);
      if (list.isNotEmpty) {
        hasData = true;
        jsonString = jsonEncode({title: list});
      } else {
        hasData = false;
      }
      print("🥦🤤 $list");
    } else {
      // 판매 내역
      final list = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
      _salesHistory(list);
      if (list.isNotEmpty) {
        hasData = true;
        jsonString = jsonEncode({title: list});
      } else {
        hasData = false;
      }
      print("🥦🤤 $list");
    }
    if (hasData) {
      setHasDataOpacity(type);
      Clipboard.setData(ClipboardData(text: jsonString));
    } else {
      setNoDataOpacity(type);
    }
    if (context.mounted) {
      CustomDialog().showSnackBar(
        context,
        hasData ? "$title 데이터가 복사되었습니다.\n복사된 텍스트를 다른 곳에 붙여넣기 하여 보관해 주세요." : "$title 데이터가 없습니다.",
        isError: !hasData,
      );
    }
  }

  /// 25-03-26
  ///
  /// 백업 완료 아이콘 투명도 조절하기
  Future setHasDataOpacity(int i) async {
    _hasDataOpacities[i] = 1.0;
    Future.delayed(const Duration(seconds: 3), () {
      _hasDataOpacities[i] = 0.0;
    });
  }

  /// 25-03-26
  ///
  /// 백업 불가 아이콘 투명도 조절하기
  Future setNoDataOpacity(int i) async {
    _noDataOpacities[i] = 1.0;
    Future.delayed(const Duration(seconds: 3), () {
      _noDataOpacities[i] = 0.0;
    });
  }
}
