import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/screens/register_green_bean.dart';
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

class GreenBeanWarehousingMain extends StatefulWidget {
  const GreenBeanWarehousingMain({Key? key}) : super(key: key);

  @override
  State<GreenBeanWarehousingMain> createState() => _GreenBeanWarehousingMainState();
}

class _GreenBeanWarehousingMainState extends State<GreenBeanWarehousingMain> {
  final CustomDatePickerController _customDatePickerCtrl = Get.put(CustomDatePickerController());
  final WarehousingGreenBeanController _warehousingGreenBeanCtrl = Get.put(WarehousingGreenBeanController());

  final _scrollCtrl = ScrollController();
  final _searchCtrl = SearchController();
  final _supplierFN = FocusNode();

  @override
  void initState() {
    super.initState();
    _warehousingGreenBeanCtrl.getSuppliers();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CustomDatePickerController>();
    Get.delete<WarehousingGreenBeanController>();
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    _supplierFN.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("생두 입고 관리"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            physics: const ClampingScrollPhysics(),
            controller: _scrollCtrl,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderTitle(title: "입고 일자", subTitle: "Receiving date"),
                      const CustomDatePicker(),
                      const SizedBox(height: 50),
                      const HeaderTitle(title: "공급처", subTitle: "Supplier"),
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
                          List suggestions = _warehousingGreenBeanCtrl.getSupplierSuggestions(controller.text);
                          return suggestions.isNotEmpty
                              ? suggestions
                                  .map((e) => ListTile(
                                        contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        onTap: () {
                                          _searchCtrl.closeView(e);
                                          _supplierFN.unfocus();
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
                              : const [EmptyWidget(content: "입력된 공급처가 없습니다.")];
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
                          _supplierFN.unfocus();
                        },
                        builder: (context, controller) => SearchBar(
                          controller: controller,
                          focusNode: _supplierFN,
                          textInputAction: TextInputAction.next,
                          hintText: "업체명",
                          onTap: () => controller.openView(),
                          onChanged: (value) {
                            List suggestions = _warehousingGreenBeanCtrl.getSupplierSuggestions(value);
                            if (suggestions.isNotEmpty) controller.openView();
                          },
                        ),
                      ),
                      Divider(thickness: 1, color: Colors.brown[200]),
                      const SizedBox(height: 50),
                      const HeaderTitle(title: "생두 정보", subTitle: "Green coffee bean info"),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterGreenBean(),
                            ),
                          ),
                          child: const Text("생두 등록 / 관리"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            flex: 4,
                            child: BeanSelectDropdownButton(listType: 0),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 2,
                            child: TextField(
                              controller: _warehousingGreenBeanCtrl.weightTECtrl,
                              focusNode: _warehousingGreenBeanCtrl.weightFN,
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "입고 중량",
                                suffixText: "kg",
                              ),
                              onTap: () => Utility().moveScrolling(_scrollCtrl),
                              onSubmitted: (value) => _warehousingGreenBeanCtrl.registerWarehousingGreenBean(context, _searchCtrl.text.trim()),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      const UsageAlertWidget(),
                    ],
                  ),
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
                            bool confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                            if (confirm) {
                              _searchCtrl.clear();
                              _warehousingGreenBeanCtrl.setInitGreenBeanWarehousingInfo();
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
                            onTap: () => _warehousingGreenBeanCtrl.registerWarehousingGreenBean(context, _searchCtrl.text.trim()),
                            child: Container(
                              color: Colors.brown,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text(
                                "입고 등록",
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
