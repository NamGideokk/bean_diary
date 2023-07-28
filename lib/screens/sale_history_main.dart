import 'package:bean_diary/controller/sale_history_controller.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SaleHistoryController>();
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
            ? FloatingActionButton.small(
                backgroundColor: Colors.brown.withOpacity(0.85),
                foregroundColor: Colors.white,
                tooltip: "날짜순",
                elevation: 3,
                onPressed: () => _saleHistoryCtrl.setReverseDate(),
                child: Icon(
                  CupertinoIcons.arrow_up_arrow_down,
                  size: height / 40,
                ),
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
                              ? "\t\t${_saleHistoryCtrl.totalList.length} 건"
                              : _saleHistoryCtrl.filterValue == "싱글오리진"
                                  ? "\t\t${_saleHistoryCtrl.singleList.length} 건"
                                  : "\t\t${_saleHistoryCtrl.blendList.length} 건",
                          style: TextStyle(
                            fontSize: height / 60,
                            color: Colors.black87,
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _saleHistoryCtrl.setChangeFilterValue("전체"),
                        child: _FilterText(title: "전체", filterValue: _saleHistoryCtrl.filterValue),
                      ),
                      TextButton(
                        onPressed: () => _saleHistoryCtrl.setChangeFilterValue("싱글오리진"),
                        child: _FilterText(title: "싱글오리진", filterValue: _saleHistoryCtrl.filterValue),
                      ),
                      TextButton(
                        onPressed: () => _saleHistoryCtrl.setChangeFilterValue("블렌드"),
                        child: _FilterText(title: "블렌드", filterValue: _saleHistoryCtrl.filterValue),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 8, color: Colors.black12),
              _saleHistoryCtrl.showList.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: height / 11),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _saleHistoryCtrl.showList.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) => Card(
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
                                      "${Utility().parseToDoubleWeight(_saleHistoryCtrl.showList[index]["sales_weight"])}kg",
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
        fontWeight: filterValue == title ? FontWeight.bold : FontWeight.normal,
        fontSize: filterValue == title ? height / 56 : height / 60,
      ),
    );
  }
}
