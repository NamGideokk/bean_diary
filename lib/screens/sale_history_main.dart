import 'package:bean_diary/controllers/sale_history_controller.dart';
import 'package:bean_diary/controllers/year_picker_controller.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/custom_year_picker.dart';
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
  final YearPickerController _yearPickerController = Get.put(YearPickerController());
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(title: "판매 내역", subTitle: "sale history"),
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
                          child: Column(
                            children: [
                              Text(
                                "누적",
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
                                "${Utility().parseToDoubleWeight(_saleHistoryCtrl.totalSales)}kg",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.brown),
                              ),
                            ],
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
                                "${Utility().parseToDoubleWeight(_saleHistoryCtrl.thisYearSales)}kg",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // _saleHistoryCtrl.totalList.length > 0
              //     ? Padding(
              //         padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           crossAxisAlignment: CrossAxisAlignment.baseline,
              //           textBaseline: TextBaseline.ideographic,
              //           children: [
              //             Row(
              //               crossAxisAlignment: CrossAxisAlignment.baseline,
              //               textBaseline: TextBaseline.ideographic,
              //               children: [
              //                 TextButton(
              //                   style: TextButton.styleFrom(
              //                     minimumSize: const Size(0, 0),
              //                     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(5),
              //                     ),
              //                   ),
              //                   onPressed: () {
              //                     showModalBottomSheet(
              //                       showDragHandle: true,
              //                       backgroundColor: Colors.white,
              //                       context: context,
              //                       builder: (context) => const CustomYearPicker(),
              //                     );
              //                   },
              //                   child: Text(
              //                     _yearPickerController.selectedYear,
              //                     style: TextStyle(
              //                       fontSize: height / 40,
              //                     ),
              //                   ),
              //                 ),
              //                 Text(
              //                   "년 총 판매량",
              //                   style: TextStyle(
              //                     fontSize: height / 60,
              //                     color: Colors.black87,
              //                     fontWeight: FontWeight.w300,
              //                     letterSpacing: -0.3,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             Expanded(
              //               child: Text(
              //                 _saleHistoryCtrl.totalWeightForYear != 0 ? "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.totalWeightForYear))}kg" : "판매 내역이 없습니다",
              //                 textAlign: TextAlign.right,
              //                 style: TextStyle(
              //                   fontSize: _saleHistoryCtrl.totalWeightForYear != 0 ? height / 46 : height / 60,
              //                   fontWeight: _saleHistoryCtrl.totalWeightForYear != 0 ? FontWeight.w600 : FontWeight.w300,
              //                   color: _saleHistoryCtrl.totalWeightForYear != 0 ? Colors.black : Colors.black54,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: _saleHistoryCtrl.sortByYear != "",
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.brown[100],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _saleHistoryCtrl.sortByYear,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _saleHistoryCtrl.sortByRoastingType != "",
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.brown[200],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _saleHistoryCtrl.sortByRoastingType,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _saleHistoryCtrl.sortBySeller != "",
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.brown[300],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  _saleHistoryCtrl.sortBySeller,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        "총 ${Utility().numberFormat(_saleHistoryCtrl.showList.length.toString(), isWeight: false)}건",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              _saleHistoryCtrl.showList.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: height / 8.5),
                        controller: _scrollCtrl,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
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
                          ],
                        ),
                      ),
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
    );
  }
}
