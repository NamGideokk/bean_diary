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
        floatingActionButton: _saleHistoryCtrl.totalList.length > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.small(
                    backgroundColor: Colors.brown.withOpacity(0.85),
                    foregroundColor: Colors.white,
                    heroTag: "filter",
                    tooltip: "날짜순",
                    elevation: 3,
                    onPressed: () => _saleHistoryCtrl.setReverseDate(),
                    child: Icon(
                      CupertinoIcons.arrow_up_arrow_down,
                      size: height / 40,
                    ),
                  ),
                  _saleHistoryCtrl.totalList.length >= 10
                      ? FloatingActionButton.small(
                          backgroundColor: Colors.brown.withOpacity(0.85),
                          foregroundColor: Colors.white,
                          heroTag: "moveTop",
                          tooltip: "맨 위로",
                          elevation: 3,
                          onPressed: () => _saleHistoryCtrl.scrollToTop(_scrollCtrl),
                          child: Icon(
                            Icons.vertical_align_top_rounded,
                            size: height / 40,
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            : const SizedBox(),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(title: "판매 내역", subTitle: "sale history"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _saleHistoryCtrl.totalList.length > 0
                      ? Text(
                          _saleHistoryCtrl.filterValue == "전체"
                              ? "\t\t${Utility().numberFormat(_saleHistoryCtrl.totalList.length.toString(), isWeight: false)} 건"
                              : _saleHistoryCtrl.filterValue == "싱글오리진"
                                  ? "\t\t${Utility().numberFormat(_saleHistoryCtrl.singleList.length.toString(), isWeight: false)} 건"
                                  : "\t\t${Utility().numberFormat(_saleHistoryCtrl.blendList.length.toString(), isWeight: false)} 건",
                          style: TextStyle(
                            fontSize: height / 60,
                            color: Colors.black87,
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        onPressed: () => _saleHistoryCtrl.setChangeFilterValue("전체"),
                        child: _FilterText(title: "전체", filterValue: _saleHistoryCtrl.filterValue),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        onPressed: () => _saleHistoryCtrl.setChangeFilterValue("싱글오리진"),
                        child: _FilterText(title: "싱글오리진", filterValue: _saleHistoryCtrl.filterValue),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        onPressed: () => _saleHistoryCtrl.setChangeFilterValue("블렌드"),
                        child: _FilterText(title: "블렌드", filterValue: _saleHistoryCtrl.filterValue),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 0, color: Colors.black12),
              _saleHistoryCtrl.totalList.length > 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 0),
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    showDragHandle: true,
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (context) => const CustomYearPicker(),
                                  );
                                },
                                child: Text(
                                  _yearPickerController.selectedYear,
                                  style: TextStyle(
                                    fontSize: height / 40,
                                  ),
                                ),
                              ),
                              Text(
                                "년 총 판매량",
                                style: TextStyle(
                                  fontSize: height / 60,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              _saleHistoryCtrl.totalWeightForYear != 0 ? "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.totalWeightForYear))}kg" : "판매 내역이 없습니다",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: _saleHistoryCtrl.totalWeightForYear != 0 ? height / 46 : height / 60,
                                fontWeight: _saleHistoryCtrl.totalWeightForYear != 0 ? FontWeight.w600 : FontWeight.w300,
                                color: _saleHistoryCtrl.totalWeightForYear != 0 ? Colors.black : Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              _saleHistoryCtrl.showList.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: height / 6.5),
                        controller: _scrollCtrl,
                        child: ListView.separated(
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
                      ),
                    )
                  : const EmptyWidget(content: "원두 판매 내역이 없습니다."),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterText extends StatelessWidget {
  final String title, filterValue;
  const _FilterText({
    Key? key,
    required this.title,
    required this.filterValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Text(
      title,
      style: TextStyle(
        fontWeight: filterValue == title ? FontWeight.bold : FontWeight.w300,
        color: filterValue == title ? null : Colors.black54,
        fontSize: height / 56,
      ),
    );
  }
}
