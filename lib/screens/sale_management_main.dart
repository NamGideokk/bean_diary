import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/roasting_bean_sales_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bean_select_dropdown_button.dart';
import 'package:bean_diary/widgets/bottom_button_border_container.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/suggestions_view.dart';
import 'package:bean_diary/widgets/ui_spacing.dart';
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
  final RoastingBeanSalesController _roastingBeanSalesCtrl = Get.put(RoastingBeanSalesController());
  final _scrollCtrl = ScrollController();
  final _retailerTECtrl = TextEditingController();
  final _retailerFN = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _roastingBeanSalesCtrl.getRetailers();
    });
  }

  @override
  void dispose() {
    super.dispose();
    CustomDatePickerController.to.setDateToToday();
    Get.delete<WarehousingGreenBeanController>();
    Get.delete<RoastingBeanSalesController>();
    _scrollCtrl.dispose();
    _retailerTECtrl.dispose();
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
                  const UiSpacing(),
                  const HeaderTitle(title: "판매처", subTitle: "Retailer"),
                  TextField(
                    controller: _retailerTECtrl,
                    focusNode: _retailerFN,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: "업체명"),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onTap: () => _roastingBeanSalesCtrl.setAllRetailers(_retailerTECtrl),
                    onChanged: (value) => _roastingBeanSalesCtrl.getRetailerSuggestions(_retailerTECtrl.text),
                  ),
                  SuggestionsView(
                    suggestions: _roastingBeanSalesCtrl.retailerSuggestions,
                    textEditingCtrl: _retailerTECtrl,
                    focusNode: _retailerFN,
                  ),
                  const UiSpacing(),
                  const HeaderTitle(title: "판매 원두 정보", subTitle: "Roasted coffee bean sale info"),
                  const BeanSelectDropdownButton(listType: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "판매",
                        style: TextStyle(
                          fontSize: height / 54,
                          color: Colors.brown,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _roastingBeanSalesCtrl.weightTECtrl,
                          focusNode: _roastingBeanSalesCtrl.weightFN,
                          style: Theme.of(context).textTheme.bodyMedium,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "판매 중량",
                            suffixIconConstraints: const BoxConstraints(minWidth: 25),
                            suffixIcon: Text(
                              "kg",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                            ),
                          ),
                          onTap: () => Utility().moveScrolling(_scrollCtrl),
                          onSubmitted: (value) => _roastingBeanSalesCtrl.onTapSalesButton(
                            context,
                            _retailerTECtrl.text.trim(),
                            _retailerFN,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const UiSpacing(),
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
                              _retailerTECtrl.clear();
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
                            onTap: () => _roastingBeanSalesCtrl.onTapSalesButton(
                              context,
                              _retailerTECtrl.text.trim(),
                              _retailerFN,
                            ),
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
