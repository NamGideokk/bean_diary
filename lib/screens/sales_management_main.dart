import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/sales_management_controller.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/bottom_button_border_container.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/new_bean_selection_dropdown.dart';
import 'package:bean_diary/widgets/suggestions_view.dart';
import 'package:bean_diary/widgets/ui_spacing.dart';
import 'package:bean_diary/widgets/weight_input_guide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesManagementMain extends StatefulWidget {
  const SalesManagementMain({Key? key}) : super(key: key);

  @override
  State<SalesManagementMain> createState() => _SalesManagementMainState();
}

class _SalesManagementMainState extends State<SalesManagementMain> {
  final SalesManagementController _salesManagementCtrl = Get.put(SalesManagementController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _salesManagementCtrl.getRetailers();
      BeanSelectionDropdownController.to.getBeans(ListType.roastedBeanInventory);
    });
  }

  @override
  void dispose() {
    super.dispose();
    CustomDatePickerController.to.setDateToToday();
    Get.delete<SalesManagementController>();
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
              physics: const BouncingScrollPhysics(),
              controller: _salesManagementCtrl.scrollCtrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(title: "판매 일자", subTitle: "Sale date"),
                  const CustomDatePicker(),
                  const UiSpacing(),
                  const HeaderTitle(title: "판매처", subTitle: "Retailer"),
                  TextField(
                    controller: _salesManagementCtrl.retailerTECtrl,
                    focusNode: _salesManagementCtrl.retailerFN,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(hintText: "업체명"),
                    style: Theme.of(context).textTheme.bodyMedium,
                    onTap: () => _salesManagementCtrl.setAllRetailers(),
                    onChanged: (value) => _salesManagementCtrl.getRetailerSuggestions(),
                  ),
                  SuggestionsView(
                    suggestions: _salesManagementCtrl.retailerSuggestions,
                    textEditingCtrl: _salesManagementCtrl.retailerTECtrl,
                    focusNode: _salesManagementCtrl.retailerFN,
                  ),
                  const UiSpacing(),
                  const HeaderTitle(title: "판매 원두 정보", subTitle: "Roasted coffee bean sale info"),
                  const NewBeanSelectionDropdown(listType: ListType.roastedBeanInventory),
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
                          controller: _salesManagementCtrl.salesWeightTECtrl,
                          focusNode: _salesManagementCtrl.salesWeightFN,
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
                          onTap: () => Utility().moveScrolling(_salesManagementCtrl.scrollCtrl),
                          onSubmitted: (value) => _salesManagementCtrl.registerSales(context),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextButton.icon(
                        onPressed: () async => await showModalBottomSheet(
                          context: context,
                          showDragHandle: true,
                          isScrollControlled: true,
                          backgroundColor: Colors.brown[50],
                          builder: (ctx) => const WeightInputGuide(),
                        ),
                        icon: Icon(
                          Icons.help_outline_rounded,
                          size: height / 50,
                          color: Colors.red,
                          applyTextScaling: true,
                        ),
                        label: Text(
                          "중량 입력 안내",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
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
                            bool? confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                            if (confirm == true && context.mounted) {
                              _salesManagementCtrl.clearData(context);
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
                            onTap: () => _salesManagementCtrl.registerSales(context),
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
