import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/warehousing_green_bean_controller.dart';
import 'package:bean_diary/screens/register_green_bean.dart';
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

class GreenBeanWarehousingMain extends StatefulWidget {
  const GreenBeanWarehousingMain({Key? key}) : super(key: key);

  @override
  State<GreenBeanWarehousingMain> createState() => _GreenBeanWarehousingMainState();
}

class _GreenBeanWarehousingMainState extends State<GreenBeanWarehousingMain> {
  final WarehousingGreenBeanController _warehousingGreenBeanCtrl = Get.put(WarehousingGreenBeanController());

  final _scrollCtrl = ScrollController();
  final _supplierTECtrl = TextEditingController();
  final _supplierFN = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _warehousingGreenBeanCtrl.getSuppliers();
    });
  }

  @override
  void dispose() {
    super.dispose();
    CustomDatePickerController.to.setDateToToday();
    Get.delete<WarehousingGreenBeanController>();
    _scrollCtrl.dispose();
    _supplierTECtrl.dispose();
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
                      const UiSpacing(),
                      const HeaderTitle(title: "공급처", subTitle: "Supplier"),
                      TextField(
                        controller: _supplierTECtrl,
                        focusNode: _supplierFN,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(hintText: "업체명"),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onTap: () => _warehousingGreenBeanCtrl.setAllSuppliers(_supplierTECtrl),
                        onChanged: (value) => _warehousingGreenBeanCtrl.getSupplierSuggestions(_supplierTECtrl.text),
                      ),
                      SuggestionsView(
                        suggestions: _warehousingGreenBeanCtrl.supplierSuggestions,
                        textEditingCtrl: _supplierTECtrl,
                        focusNode: _supplierFN,
                      ),
                      const UiSpacing(),
                      const HeaderTitle(title: "생두 정보", subTitle: "Green coffee bean info"),
                      Center(
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
                      const SizedBox(height: 20),
                      const BeanSelectDropdownButton(listType: 0),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "입고",
                            style: TextStyle(
                              fontSize: height / 54,
                              color: Colors.brown,
                            ),
                          ),
                          Expanded(
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
                              onSubmitted: (value) => _warehousingGreenBeanCtrl.registerWarehousingGreenBean(
                                context,
                                _supplierTECtrl.text.trim(),
                                _supplierFN,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const UiSpacing(),
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
                              _supplierTECtrl.clear();
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
                            onTap: () => _warehousingGreenBeanCtrl.registerWarehousingGreenBean(
                              context,
                              _supplierTECtrl.text.trim(),
                              _supplierFN,
                            ),
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
