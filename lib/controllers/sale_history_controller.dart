import 'package:bean_diary/screens/sale_history_filter_bottom_sheet.dart';
import 'package:bean_diary/sqflite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleHistoryController extends GetxController {
  final RxList _showList = [].obs;
  final RxList _totalList = [].obs;
  final RxList _singleList = [].obs;
  final RxList _blendList = [].obs;
  final RxList _sellerList = [].obs;

  final RxString _filterValue = "전체".obs;
  final RxInt _totalWeightForYear = 0.obs;

  final RxString _sortByDate = "desc".obs;
  final RxString _sortByRoastingType = "".obs;
  final RxString _sortBySeller = "".obs;
  final RxInt _sortCount = 0.obs;

  get showList => _showList;
  get totalList => _totalList;
  get singleList => _singleList;
  get blendList => _blendList;
  get sellerList => _sellerList;

  get filterValue => _filterValue.value;
  get totalWeightForYear => _totalWeightForYear.value;

  get sortByDate => _sortByDate.value;
  get sortByRoastingType => _sortByRoastingType.value;
  get sortBySeller => _sortBySeller.value;
  get sortCount => _sortCount.value;

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
      _showList(totalList);
      calcYearTotalSalesWeight(DateTime.now().year);
    } else {
      _totalList.clear();
      _showList.clear();
    }
  }

  Future<void> openFilterBottomSheet(BuildContext context) async {
    await getSellerList();
    if (context.mounted) {
      return await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        backgroundColor: Colors.white,
        builder: (context) => const SaleHistoryFilterBottomSheet(),
      );
    }
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

  /// 25-02-22
  ///
  /// 판매 내역 필터 > 판매처 목록 불러오기
  Future getSellerList() async {
    final result = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
    List list = [];
    if (result.isNotEmpty) {
      Set removeDuplicateSellerList = {};
      for (final seller in result) {
        removeDuplicateSellerList.add(seller["company"]);
      }
      list.addAll(removeDuplicateSellerList);
      list.sort((a, b) => a.compareTo(b));
      _sellerList(list);
    } else {
      _sellerList.clear();
    }
  }

  /// 25-02-22
  ///
  /// 판매 내역 필터 > 판매처 선택하기
  void selectSellerSort(String value) {
    if (sortBySeller != value) {
      _sortBySeller(value);
    }
  }

  /// 25-02-22
  ///
  /// 정렬하기
  void sort(String date, String roastingType, String seller) {
    List list = [];
    int sortCnt = 0;

    _sortByDate(date);
    if (date == "desc") {
      list = List.from(totalList);
    } else {
      list = List.from(totalList).reversed.toList();
    }

    _sortByRoastingType(roastingType);
    if (roastingType == "싱글오리진") {
      list.removeWhere((element) => element["type"] == "2");
      sortCnt++;
    } else if (roastingType == "블렌드") {
      list.removeWhere((element) => element["type"] == "1");
      sortCnt++;
    }

    _sortBySeller(seller);
    if (seller != "") {
      list.removeWhere((element) => element["company"] != seller);
      sortCnt++;
    }

    _showList(list);
    _sortCount(sortCnt);
  }
}
