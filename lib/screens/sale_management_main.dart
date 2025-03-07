import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/roasting_bean_sales_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
import 'package:bean_diary/widgets/bottom_button_border_container.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/usage_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleManagementMain extends StatefulWidget {
  const SaleManagementMain({Key? key}) : super(key: key);

  @override
  State<SaleManagementMain> createState() => _SaleManagementMainState();
}

class _SaleManagementMainState extends State<SaleManagementMain> {
  final WarehousingGreenBeanController _warehousingGreenBeanCtrl = Get.put(WarehousingGreenBeanController());
  final CustomDatePickerController _customDatePickerCtrl = Get.put(CustomDatePickerController());
  final RoastingBeanSalesController _roastingBeanSalesCtrl = Get.put(RoastingBeanSalesController());
  final _scrollCtrl = ScrollController();
  final _searchCtrl = SearchController();
  final _retailerFN = FocusNode();

  @override
  void initState() {
    super.initState();
    _roastingBeanSalesCtrl.getRetailers();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<WarehousingGreenBeanController>();
    Get.delete<CustomDatePickerController>();
    Get.delete<RoastingBeanSalesController>();
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    _retailerFN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("판매 관리"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              controller: _scrollCtrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(title: "판매 일자", subTitle: "Sale date"),
                  const CustomDatePicker(),
                  const SizedBox(height: 50),
                  const HeaderTitle(title: "판매처", subTitle: "Retailer"),
                  SearchAnchor(
                    searchController: _searchCtrl,
                    viewBackgroundColor: Colors.brown[50],
                    viewElevation: 2,
                    isFullScreen: false,
                    viewConstraints: BoxConstraints(
                      minHeight: 0,
                      maxHeight: height / 4,
                    ),
                    viewLeading: const SizedBox(),
                    headerTextStyle: Theme.of(context).textTheme.bodyMedium,
                    headerHintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                    viewShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    viewHintText: "업체명",
                    suggestionsBuilder: (context, controller) async {
                      List suggestions = _roastingBeanSalesCtrl.getRetailerSuggestions(controller.text);
                      return suggestions.isNotEmpty
                          ? suggestions
                              .map((e) => ListTile(
                                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    onTap: () {
                                      _searchCtrl.closeView(e);
                                      _retailerFN.unfocus();
                                    },
                                    title: Text(
                                      e.toString(),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    trailing: IconButton(
                                      style: IconButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        padding: const EdgeInsets.all(14),
                                        minimumSize: const Size(0, 0),
                                        shape: const CircleBorder(),
                                      ),
                                      onPressed: () => controller.text = e,
                                      icon: Icon(
                                        Icons.arrow_outward_rounded,
                                        size: height / 50,
                                      ),
                                    ),
                                  ))
                              .toList()
                          : const [EmptyWidget(content: "입력된 판매처가 없습니다.")];
                    },
                    viewTrailing: [
                      IconButton(
                        style: IconButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.all(14),
                          minimumSize: const Size(0, 0),
                          shape: const CircleBorder(),
                        ),
                        onPressed: () => _searchCtrl.clear(),
                        icon: Icon(
                          Icons.clear,
                          size: height / 50,
                        ),
                      ),
                    ],
                    viewOnSubmitted: (value) {
                      _searchCtrl.closeView(_searchCtrl.text);
                      _retailerFN.unfocus();
                    },
                    builder: (context, controller) => SearchBar(
                      controller: controller,
                      focusNode: _retailerFN,
                      textInputAction: TextInputAction.next,
                      hintText: "업체명",
                      onTap: () => controller.openView(),
                      onChanged: (value) {
                        List suggestions = _roastingBeanSalesCtrl.getRetailerSuggestions(value);
                        if (suggestions.isNotEmpty) controller.openView();
                      },
                    ),
                  ),
                  Divider(thickness: _retailerFN.hasFocus ? 2 : 1, color: _retailerFN.hasFocus ? Colors.brown : Colors.brown[200]),
                  const SizedBox(height: 50),
                  const HeaderTitle(title: "판매 원두 정보", subTitle: "Roasted coffee bean sale info"),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(
                        flex: 4,
                        child: BeanSelectDropdownButton(listType: 1),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 2,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _roastingBeanSalesCtrl.weightTECtrl,
                          focusNode: _roastingBeanSalesCtrl.weightFN,
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "판매 중량",
                            suffixText: "kg",
                          ),
                          onTap: () => Utility().moveScrolling(_scrollCtrl),
                          onSubmitted: (value) => _roastingBeanSalesCtrl.onTapSalesButton(context, _searchCtrl.text.trim()),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  const UsageAlertWidget(),
                  SizedBox(height: height / 9),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const BottomButtonBorderContainer(),
                  MediaQuery(
                    data: MediaQueryData(
                      textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            bool? confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                            if (confirm == true) {
                              _searchCtrl.clear();
                              _roastingBeanSalesCtrl.allValueInit();
                            }
                          },
                          child: Container(
                            color: Colors.brown[100],
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              " 초기화 ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: height / 50,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _roastingBeanSalesCtrl.onTapSalesButton(context, _searchCtrl.text.trim()),
                            child: Container(
                              color: Colors.brown,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                "판매 등록",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: height / 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
