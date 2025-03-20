import 'package:bean_diary/controllers/sale_history_controller.dart';
import 'package:bean_diary/controllers/year_picker_controller.dart';
import 'package:bean_diary/screens/sale_history/sale_history_information_main.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/roasting_type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleHistoryMain extends StatefulWidget {
  const SaleHistoryMain({Key? key}) : super(key: key);

  @override
  State<SaleHistoryMain> createState() => _SaleHistoryMainState();
}

class _SaleHistoryMainState extends State<SaleHistoryMain> {
  final SaleHistoryController _saleHistoryCtrl = Get.put(SaleHistoryController());
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SaleHistoryController>();
    Get.delete<YearPickerController>();
    _scrollCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: const Text("판매 내역"),
          centerTitle: true,
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.small(
              backgroundColor: Colors.brown.withOpacity(0.85),
              foregroundColor: Colors.white,
              heroTag: "chart",
              tooltip: "판매 내역 통계",
              elevation: 3,
              onPressed: _saleHistoryCtrl.showList.isEmpty
                  ? () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      CustomDialog().showSnackBar(context, "원두 판매 내역이 없습니다.");
                    }
                  : () => showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        useSafeArea: true,
                        isScrollControlled: true,
                        clipBehavior: Clip.hardEdge,
                        backgroundColor: Colors.white,
                        builder: (context) => const SaleHistoryInformationMain(),
                      ),
              child: Icon(
                CupertinoIcons.chart_pie_fill,
                size: height / 40,
              ),
            ),
            Badge(
              label: Text(
                "${_saleHistoryCtrl.sortCount}",
                textScaler: TextScaler.noScaling,
              ),
              isLabelVisible: _saleHistoryCtrl.sortCount > 0 ? true : false,
              child: FloatingActionButton.small(
                backgroundColor: Colors.brown.withOpacity(0.85),
                foregroundColor: Colors.white,
                heroTag: "filter",
                tooltip: "판매 내역 필터",
                elevation: 3,
                onPressed: () => _saleHistoryCtrl.openFilterBottomSheet(context),
                child: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  size: height / 40,
                ),
              ),
            ),
          ],
        ),
        body: _saleHistoryCtrl.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: height / 14,
                    ),
                    Text(
                      "불러오는 중...",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                controller: _scrollCtrl,
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderTitle(title: "판매 내역", subTitle: "Sales history"),
                      IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: MediaQuery(
                            data: MediaQueryData(
                              textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    showDuration: const Duration(seconds: 3),
                                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                    decoration: BoxDecoration(
                                      color: Colors.brown.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    message: _saleHistoryCtrl.totalSalesMsg,
                                    child: Column(
                                      children: [
                                        Badge(
                                          backgroundColor: Colors.transparent,
                                          offset: const Offset(13, -9),
                                          label: Icon(
                                            CupertinoIcons.info_circle,
                                            color: Colors.black38,
                                            size: height / 55,
                                          ),
                                          child: Text(
                                            "누적",
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Text(
                                          "판매량",
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                                        ),
                                        Text(
                                          Utility().convertWeightUnit(_saleHistoryCtrl.totalSales.toString()),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.brown),
                                        ),
                                        Visibility(
                                          visible: _saleHistoryCtrl.totalSales >= 10000,
                                          child: Text(
                                            "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.totalSales))}kg",
                                            textAlign: TextAlign.center,
                                            textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54, height: 1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 50,
                                  thickness: 1,
                                  indent: 5,
                                  endIndent: 5,
                                  color: Colors.black12,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "올해",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        "판매량",
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                                      ),
                                      Text(
                                        Utility().convertWeightUnit(_saleHistoryCtrl.totalSales.toString()),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.brown),
                                      ),
                                      Visibility(
                                        visible: _saleHistoryCtrl.totalSales >= 10000,
                                        child: Text(
                                          "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.thisYearSales))}kg",
                                          textAlign: TextAlign.center,
                                          textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54, height: 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible: _saleHistoryCtrl.sortByYear != "",
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          // color: Colors.brown[100],
                                          color: ColorsList().chip5Color,
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          border: const Border.symmetric(
                                            vertical: BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "${_saleHistoryCtrl.sortByYear}년",
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _saleHistoryCtrl.sortByRoastingType != "",
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          // color: Color(0xFFc9bfbb),
                                          color: ColorsList().chip5Color,
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          border: const Border.symmetric(
                                            vertical: BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          _saleHistoryCtrl.sortByRoastingType,
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _saleHistoryCtrl.sortByProduct != "",
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          // color: Color(0xFFbcb2ae),
                                          color: ColorsList().chip5Color,
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          border: const Border.symmetric(
                                            vertical: BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          _saleHistoryCtrl.sortByProduct,
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _saleHistoryCtrl.sortBySeller != "",
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          // color: Color(0xFFaea5a1),
                                          color: ColorsList().chip5Color,
                                          borderRadius: const BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                          border: const Border.symmetric(
                                            vertical: BorderSide(
                                              color: Colors.white,
                                              width: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          _saleHistoryCtrl.sortBySeller,
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Visibility(
                              visible: _saleHistoryCtrl.showList.isNotEmpty,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Text(
                                  "총 ${Utility().numberFormat(_saleHistoryCtrl.showList.length.toString(), isWeight: false)}건",
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _saleHistoryCtrl.showList.isNotEmpty
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _saleHistoryCtrl.showList.length,
                                  separatorBuilder: (context, index) => const Divider(),
                                  itemBuilder: (context, index) => Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(index == 0 ? 8 : 0),
                                        bottom: Radius.circular(index == _saleHistoryCtrl.showList.length - 1 ? 8 : 0),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.ideographic,
                                        children: [
                                          Text(
                                            Utility().dateFormattingYYMMDD(_saleHistoryCtrl.showList[index]["date"]),
                                            style: TextStyle(
                                              fontSize: height / 54,
                                              color: Colors.brown[700],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              _saleHistoryCtrl.showList[index]["company"],
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.brown[700],
                                                fontSize: height / 54,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RoastingTypeWidget(type: _saleHistoryCtrl.showList[index]["type"].toString()),
                                                  Text(
                                                    _saleHistoryCtrl.showList[index]["name"],
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: height / 54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.showList[index]["sales_weight"]))}kg",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: height / 48,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _saleHistoryCtrl.showList.length >= 10,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: IconButton(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context).cardTheme.color,
                                        foregroundColor: Colors.brown,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () => _saleHistoryCtrl.scrollToTop(_scrollCtrl),
                                      icon: Icon(
                                        Icons.vertical_align_top_rounded,
                                        size: height / 40,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height / 12),
                              ],
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.brown[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const EmptyWidget(content: "원두 판매 내역이 없습니다."),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
