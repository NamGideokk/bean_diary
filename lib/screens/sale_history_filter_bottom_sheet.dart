import 'package:bean_diary/controllers/sale_history_controller.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleHistoryFilterBottomSheet extends StatefulWidget {
  const SaleHistoryFilterBottomSheet({super.key});

  @override
  State<SaleHistoryFilterBottomSheet> createState() => _SaleHistoryFilterBottomSheetState();
}

class _SaleHistoryFilterBottomSheetState extends State<SaleHistoryFilterBottomSheet> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _saleHistoryCtrl = Get.find<SaleHistoryController>();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(
      () => Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: HeaderTitle(title: "판매 내역 필터"),
              ),
              SingleChildScrollView(
                padding: _saleHistoryCtrl.sortCount > 0 ? const EdgeInsets.fromLTRB(15, 0, 15, 5) : const EdgeInsets.only(top: 5),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Visibility(
                      visible: _saleHistoryCtrl.sortByRoastingType != "",
                      child: IntrinsicWidth(
                        child: ActionChip(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.brown[50],
                          shape: StadiumBorder(side: BorderSide(color: Colors.brown[50]!)),
                          onPressed: () => _saleHistoryCtrl.sort(
                            _saleHistoryCtrl.sortByDate,
                            "",
                            _saleHistoryCtrl.sortBySeller,
                          ),
                          label: Row(
                            children: [
                              Text(
                                "${_saleHistoryCtrl.sortByRoastingType} ",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1),
                              ),
                              Icon(
                                Icons.clear_outlined,
                                size: height / 60,
                                color: Colors.brown,
                                applyTextScaling: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Visibility(
                      visible: _saleHistoryCtrl.sortBySeller != "",
                      child: IntrinsicWidth(
                        child: ActionChip(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: Colors.brown[50],
                          shape: StadiumBorder(side: BorderSide(color: Colors.brown[50]!)),
                          onPressed: () => _saleHistoryCtrl.sort(
                            _saleHistoryCtrl.sortByDate,
                            _saleHistoryCtrl.sortByRoastingType,
                            "",
                          ),
                          label: Row(
                            children: [
                              Text(
                                "${_saleHistoryCtrl.sortBySeller} ",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 0),
                              ),
                              Icon(
                                Icons.clear_outlined,
                                size: height / 60,
                                color: Colors.brown,
                                applyTextScaling: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabCtrl,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.label,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                dividerColor: Colors.black12,
                indicatorWeight: 4,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
                unselectedLabelColor: Colors.black54,
                labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                tabs: const [
                  Text("날짜순"),
                  Text("로스팅타입별"),
                  Text("판매처별"),
                ],
              ),
              SizedBox(
                height: height / 3.5,
                child: TabBarView(
                  controller: _tabCtrl,
                  children: [
                    // 날짜순 view
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTileTheme(
                        horizontalTitleGap: 5,
                        child: Column(
                          children: [
                            RadioListTile.adaptive(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              visualDensity: VisualDensity.comfortable,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: _saleHistoryCtrl.sortByDate,
                              groupValue: "desc",
                              onChanged: (value) => _saleHistoryCtrl.sort(
                                "desc",
                                _saleHistoryCtrl.sortByRoastingType,
                                _saleHistoryCtrl.sortBySeller,
                              ),
                              title: Text(
                                "날짜 내림차순",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            RadioListTile.adaptive(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              visualDensity: VisualDensity.comfortable,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: _saleHistoryCtrl.sortByDate,
                              groupValue: "asc",
                              onChanged: (value) => _saleHistoryCtrl.sort(
                                "asc",
                                _saleHistoryCtrl.sortByRoastingType,
                                _saleHistoryCtrl.sortBySeller,
                              ),
                              title: Text(
                                "날짜 오름차순",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 로스팅타입별 view
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTileTheme(
                        horizontalTitleGap: 5,
                        child: Column(
                          children: [
                            RadioListTile.adaptive(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              visualDensity: VisualDensity.comfortable,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: _saleHistoryCtrl.sortByRoastingType,
                              groupValue: "싱글오리진",
                              onChanged: (value) => _saleHistoryCtrl.sort(
                                _saleHistoryCtrl.sortByDate,
                                "싱글오리진",
                                _saleHistoryCtrl.sortBySeller,
                              ),
                              title: Text(
                                "싱글오리진",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            RadioListTile.adaptive(
                              dense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              visualDensity: VisualDensity.comfortable,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: _saleHistoryCtrl.sortByRoastingType,
                              groupValue: "블렌드",
                              onChanged: (value) => _saleHistoryCtrl.sort(
                                _saleHistoryCtrl.sortByDate,
                                "블렌드",
                                _saleHistoryCtrl.sortBySeller,
                              ),
                              title: Text(
                                "블렌드",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 판매처별 view
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      itemCount: _saleHistoryCtrl.sellerList.length,
                      itemBuilder: (context, index) => ListTileTheme(
                        horizontalTitleGap: 5,
                        child: RadioListTile.adaptive(
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          visualDensity: VisualDensity.comfortable,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: _saleHistoryCtrl.sortBySeller,
                          groupValue: _saleHistoryCtrl.sellerList[index],
                          onChanged: (value) => _saleHistoryCtrl.sort(
                            _saleHistoryCtrl.sortByDate,
                            _saleHistoryCtrl.sortByRoastingType,
                            _saleHistoryCtrl.sellerList[index],
                          ),
                          title: Text(
                            _saleHistoryCtrl.sellerList[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
