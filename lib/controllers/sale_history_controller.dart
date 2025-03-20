import 'package:bean_diary/screens/sale_history/sale_history_filter_bottom_sheet.dart';
import 'package:bean_diary/sqflite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SaleHistoryController extends GetxController {
  final RxBool _isLoading = false.obs;

  final RxList _showList = [].obs;
  final RxList _totalList = [].obs;
  final RxList _singleList = [].obs;
  final RxList _blendList = [].obs;
  final RxList _yearsList = [].obs;
  final RxList _productList = [].obs;
  final RxList _sellerList = [].obs;

  final RxInt _totalSales = 0.obs;
  final RxInt _thisYearSales = 0.obs;
  final RxString _totalSalesMsg = "".obs;

  final RxString _sortByDate = "desc".obs;
  final RxString _sortByYear = "".obs;
  final RxString _sortByRoastingType = "".obs;
  final RxString _sortByProduct = "".obs;
  final RxString _sortBySeller = "".obs;
  final RxInt _sortCount = 0.obs;

  final RxDouble _markerWidth = 0.0.obs;

  // 판매 내역 통계 변수
  final RxString _salesPeriod = "".obs; // 판매기간
  final RxList _showSellerList = [].obs; // showList 판매처수
  final RxInt _totalSalesInShowList = 0.obs; // showList 총판매량
  final RxInt _minSales = 0.obs; // 최소판매량
  final RxInt _maxSales = 0.obs; // 최대판매량
  final RxList _monthlySales = [].obs; // 월별판매량
  final RxList _productSales = [].obs; // 상품별판매량
  final RxList _chartBySeller = [].obs; // 차트용 판매처별 판매량 리스트
  final RxInt _showChartInfo = 0.obs; // 0: 표출X, 1 ~: index - 1로 표출
  final RxDouble _showChartInfoOpacity = 0.0.obs;

  get isLoading => _isLoading.value;

  get showList => _showList;
  get totalList => _totalList;
  get singleList => _singleList;
  get blendList => _blendList;
  get yearsList => _yearsList;
  get productList => _productList;
  get sellerList => _sellerList;

  get totalSales => _totalSales.value;
  get thisYearSales => _thisYearSales.value;
  get totalSalesMsg => _totalSalesMsg.value;

  get sortByDate => _sortByDate.value;
  get sortByYear => _sortByYear.value;
  get sortByRoastingType => _sortByRoastingType.value;
  get sortByProduct => _sortByProduct.value;
  get sortBySeller => _sortBySeller.value;
  get sortCount => _sortCount.value;

  get markerWidth => _markerWidth.value;

  get salesPeriod => _salesPeriod.value;
  get showSellerList => _showSellerList;
  get totalSalesInShowList => _totalSalesInShowList.value;
  get minSales => _minSales.value;
  get maxSales => _maxSales.value;
  get monthlySales => _monthlySales;
  get productSales => _productSales;
  get chartBySeller => _chartBySeller;
  get showChartInfo => _showChartInfo.value;
  get showChartInfoOpacity => _showChartInfoOpacity.value;

  @override
  void onInit() {
    super.onInit();
    getSaleHistory();
  }

  void getSaleHistory() async {
    _isLoading(true);
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
      calcSalesContainer();
    } else {
      _totalList.clear();
      _showList.clear();
      _totalSales(0);
      _thisYearSales(0);
    }
    setTotalSalesMsg();
    _isLoading(false);
  }

  Future<void> openFilterBottomSheet(BuildContext context) async {
    await getYearsList();
    await getProductList();
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

  /// 25-02-23 리팩토링
  ///
  /// 상단 판매량 구하기 (누적, 올해)
  void calcSalesContainer() {
    int total = 0;
    int thisYear = 0;
    for (var e in _totalList) {
      total += e["sales_weight"] as int;
      if (e["date"].toString().substring(0, 4) == DateTime.now().year.toString()) {
        thisYear += e["sales_weight"] as int;
      }
    }
    _totalSales(total);
    _thisYearSales(thisYear);
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

  /// 25-02-23
  ///
  /// 판매 내역 필터 > 연도별 목록 불러오기
  Future getYearsList() async {
    List list = [];
    if (totalList.isNotEmpty) {
      Set removeDuplicateYearsList = {};
      for (final year in totalList) {
        List splitDate = year["date"].split("-");
        removeDuplicateYearsList.add(splitDate[0]);
      }
      list.addAll(removeDuplicateYearsList);
      list.sort((a, b) => a.compareTo(b));
      _yearsList(list);
    } else {
      _yearsList.clear();
    }
  }

  /// 25-03-19
  ///
  /// 판매 내역 필터 > 상품별 목록 불러오기
  Future getProductList() async {
    List list = [];
    if (totalList.isNotEmpty) {
      Set removeDuplicateProductList = {};
      for (final product in totalList) {
        removeDuplicateProductList.add(product["name"]);
      }
      list.addAll(removeDuplicateProductList);
      list.sort((a, b) => a.compareTo(b));
      _productList(list);
    } else {
      _productList.clear();
    }
  }

  /// 25-02-22
  ///
  /// 판매 내역 필터 > 판매처 목록 불러오기
  Future getSellerList() async {
    List list = [];
    if (totalList.isNotEmpty) {
      Set removeDuplicateSellerList = {};
      for (final seller in totalList) {
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
  void sort(String date, String year, String roastingType, String product, String seller) {
    List list = [];
    int sortCnt = 0;

    _sortByDate(date);
    if (date == "desc") {
      list = List.from(totalList);
    } else {
      list = List.from(totalList).reversed.toList();
    }

    _sortByYear(year);
    if (year != "") {
      list.removeWhere((element) {
        List splitDate = element["date"].split("-");
        return splitDate[0] != year;
      });
      sortCnt++;
    }

    _sortByRoastingType(roastingType);
    if (roastingType == "싱글오리진") {
      list.removeWhere((element) => element["type"] == "2");
      sortCnt++;
    } else if (roastingType == "블렌드") {
      list.removeWhere((element) => element["type"] == "1");
      sortCnt++;
    }

    _sortByProduct(product);
    if (product != "") {
      list.removeWhere((element) => element["name"] != product);
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

  /// 25-03-02
  ///
  /// 판매 내역 필터 초기화하기
  void resetSortFilter() => sort("desc", "", "", "", "");

  /// 25-02-24
  ///
  /// 상단 누적 판매량 툴팁 메시지 할당하기
  void setTotalSalesMsg() {
    if (totalList.isEmpty) {
      _totalSalesMsg("판매 내역이 없습니다.");
    } else {
      String sYear = totalList[totalList.length - 1]["date"].split("-")[0];
      String eYear = totalList[0]["date"].split("-")[0];
      if (totalList.length == 1 || sYear == eYear) {
        _totalSalesMsg("$sYear년 누적 판매량입니다.");
      } else {
        _totalSalesMsg("$sYear - $eYear년 동안의 누적 판매량입니다.");
      }
    }
  }

  /// 25-05-26
  ///
  /// 판매 내역 통계 계산하기
  Future<void> calcSalesStatistics() async {
    // 판매기간
    if (showList.isEmpty) {
      _salesPeriod("");
    } else if (showList.length == 1) {
      _salesPeriod(showList.first["date"]);
    } else {
      DateTime date1 = DateTime.parse(showList.first["date"]);
      DateTime date2 = DateTime.parse(showList.last["date"]);
      bool checkDate = date1.isBefore(date2);
      DateFormat dFormat = DateFormat("yyyy-MM-dd");

      _salesPeriod(checkDate ? "${dFormat.format(date1)} ~ ${dFormat.format(date2)}" : "${dFormat.format(date2)} ~ ${dFormat.format(date1)}");
    }

    // 판매처수
    if (showList.isEmpty) {
      _showSellerList.clear();
    } else {
      List list = [];
      Set removeDuplicateSellerList = {};
      for (final seller in showList) {
        removeDuplicateSellerList.add(seller["company"]);
      }
      list.addAll(removeDuplicateSellerList);
      list.sort((a, b) => a.compareTo(b));
      _showSellerList(list);
    }

    // 총판매량, 최소판매량, 최대판매량
    if (showList.isEmpty) {
      _totalSalesInShowList(0);
    } else {
      int total = 0;
      List list = [];
      for (final e in showList) {
        total += e["sales_weight"] as int;
        list.add(e["sales_weight"] as int);
      }
      list.sort();
      _totalSalesInShowList(total);
      _minSales(list.first);
      _maxSales(list.last);
    }

    // 월별판매량
    _monthlySales.clear();
    if (showList.isEmpty) {
    } else {
      Set set = {};
      List monthList = [];
      // List copyShowList = showList.map((e) => Map.from(e)).toList();
      DateFormat dFormat = DateFormat("yyyy-MM");
      for (final e in showList) {
        set.add(dFormat.format(DateTime.parse(e["date"])));
      }
      monthList = set.toList();
      monthList.sort();

      for (final e in monthList) {
        _monthlySales.add({
          "date": e.toString(),
          "sales": 0,
        });
      }
      for (final e in showList) {
        String parseDate = dFormat.format(DateTime.parse(e["date"]));
        for (final obj in monthlySales) {
          if (parseDate == obj["date"]) {
            obj["sales"] += e["sales_weight"] as int;
          }
        }
      }
    }

    // 상품별판매량
    _productSales.clear();
    if (showList.isNotEmpty) {
      List tempList = [];
      await getProductList();
      for (final e in productList) {
        tempList.add({
          "product": e,
          "sales": 0,
        });
      }
      for (final e in showList) {
        for (final obj in tempList) {
          if (e["name"] == obj["product"]) {
            obj["sales"] += e["sales_weight"] as int;
          }
        }
      }
      tempList.removeWhere((e) => e["sales"] == 0);
      _productSales(tempList);
    }
  }

  /// 25-02-26
  ///
  /// 판매 내역 통계 > 판매처별 차트 계산하기
  void calcChartBySeller() {
    List list = showSellerList
        .map((e) => {
              "seller": e,
              "sales": 0,
              "ratio": 0.0,
              "chartValue": 0.0,
            })
        .toList();

    for (final e in list) {
      for (final obj in showList) {
        if (e["seller"] == obj["company"]) {
          e["sales"] += obj["sales_weight"];
        }
      }
    }

    list.sort((a, b) => b["sales"].compareTo(a["sales"]));

    for (int i = 0; i < list.length; i++) {
      list[i]["ratio"] = list[i]["sales"] / totalSalesInShowList;

      if (i == 0) {
        list[i]["chartValue"] = list[i]["ratio"];
      } else {
        list[i]["chartValue"] = list[i - 1]["chartValue"] + list[i]["ratio"];
      }
    }
    _chartBySeller(list);
  }

  /// 25-02-27
  ///
  /// 차트 항목 탭 시 정보 보여주기
  Future<void> onTapShowChartInfo(int index) async {
    if (index + 1 == showChartInfo) {
      _showChartInfo(0);
      _showChartInfoOpacity(0.0);
    } else {
      _showChartInfo(index + 1);
      _showChartInfoOpacity(1);
    }
  }

  /// 25-03-01
  ///
  /// 차트 항목 정보 보이지 않기
  void resetShowChartInfo() {
    _showChartInfo(0);
    _showChartInfoOpacity(0.0);
  }

  /// 25-03-10
  ///
  /// 총 판매량 Text 너비 구하기
  void getMarkerWidth(double? value) => _markerWidth(value ?? 0.0);
}
