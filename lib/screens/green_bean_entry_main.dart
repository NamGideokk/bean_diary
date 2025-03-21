import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/green_bean_entry_controller.dart';
import 'package:bean_diary/screens/green_bean_management/green_bean_register.dart';
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

class GreenBeanEntryMain extends StatefulWidget {
  const GreenBeanEntryMain({Key? key}) : super(key: key);

  @override
  State<GreenBeanEntryMain> createState() => _GreenBeanEntryMainState();
}

class _GreenBeanEntryMainState extends State<GreenBeanEntryMain> {
  final GreenBeanEntryController _greenBeanEntryCtrl = Get.put(GreenBeanEntryController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _greenBeanEntryCtrl.getSuppliers();
      BeanSelectionDropdownController.to.getBeans(ListType.greenBean);
    });
  }

  @override
  void dispose() {
    super.dispose();
    CustomDatePickerController.to.setDateToToday();
    Get.delete<GreenBeanEntryController>();
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
            physics: const BouncingScrollPhysics(),
            controller: _greenBeanEntryCtrl.scrollCtrl,
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
                        controller: _greenBeanEntryCtrl.supplierTECtrl,
                        focusNode: _greenBeanEntryCtrl.supplierFN,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(hintText: "업체명"),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onTap: () => _greenBeanEntryCtrl.setAllSuppliers(),
                        onChanged: (value) => _greenBeanEntryCtrl.getSupplierSuggestions(),
                        onEditingComplete: () => _greenBeanEntryCtrl.supplierFN.unfocus(),
                      ),
                      SuggestionsView(
                        suggestions: _greenBeanEntryCtrl.supplierSuggestions,
                        textEditingCtrl: _greenBeanEntryCtrl.supplierTECtrl,
                        focusNode: _greenBeanEntryCtrl.supplierFN,
                      ),
                      const UiSpacing(),
                      const HeaderTitle(title: "생두 정보", subTitle: "Green coffee bean info"),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GreenBeanRegister(),
                            ),
                          ),
                          child: const Text("생두 등록 / 관리"),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const NewBeanSelectionDropdown(listType: ListType.greenBean),
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
                              controller: _greenBeanEntryCtrl.weightTECtrl,
                              focusNode: _greenBeanEntryCtrl.weightFN,
                              keyboardType: TextInputType.number,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: "입고 중량",
                                suffixIconConstraints: const BoxConstraints(minWidth: 25),
                                suffixIcon: Text(
                                  "kg",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                                ),
                              ),
                              onTap: () => Utility().moveScrolling(_greenBeanEntryCtrl.scrollCtrl),
                              onSubmitted: (value) => _greenBeanEntryCtrl.registerWarehousingGreenBean(context),
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
                            bool? confirm = await CustomDialog().showAlertDialog(context, "초기화", "모든 입력값을 초기화하시겠습니까?");
                            if (confirm == true && context.mounted) {
                              _greenBeanEntryCtrl.clearData(context);
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
                            onTap: () => _greenBeanEntryCtrl.registerWarehousingGreenBean(context),
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
