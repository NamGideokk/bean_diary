import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/controllers/custom_date_picker_controller.dart';
import 'package:bean_diary/controllers/roasting_management_controller.dart';
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

class RoastingManagementMain extends StatefulWidget {
  const RoastingManagementMain({Key? key}) : super(key: key);

  @override
  State<RoastingManagementMain> createState() => _RoastingManagementMainState();
}

class _RoastingManagementMainState extends State<RoastingManagementMain> {
  final RoastingManagementController _roastingManagementCtrl = Get.put(RoastingManagementController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _roastingManagementCtrl.getBlendNames();
      BeanSelectionDropdownController.to.getBeans(ListType.greenBeanInventory);
    });
  }

  /// 로스팅 등록
  Future registerRoasting() async {
    if (_roastingManagementCtrl.roastingType == 1) {
      await _roastingManagementCtrl.registerSingleOriginRoasting(context);
    } else {
      await _roastingManagementCtrl.registerBlendRoasting(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    CustomDatePickerController.to.setDateToToday();
    Get.delete<RoastingManagementController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
    return Scaffold(
      appBar: AppBar(
        title: const Text("로스팅 관리"),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              controller: _roastingManagementCtrl.scrollCtrl,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderTitle(title: "로스팅 일자", subTitle: "Roasting date"),
                    const CustomDatePicker(),
                    const UiSpacing(),
                    const HeaderTitle(title: "로스팅 타입", subTitle: "Roast type"),
                    Row(
                      children: [
                        Expanded(
                          child: FilterChip(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            selectedColor: _roastingManagementCtrl.roastingType == 1 ? Colors.brown[50] : Colors.white,
                            side: BorderSide(color: _roastingManagementCtrl.roastingType == 1 ? Colors.brown[200]! : Colors.brown[100]!),
                            checkmarkColor: Colors.orange,
                            surfaceTintColor: Colors.white,
                            selected: _roastingManagementCtrl.roastingType == 1 ? true : false,
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            label: const Text("싱글오리진"),
                            onSelected: (value) => _roastingManagementCtrl.setRoastingType(1),
                          ),
                        ),
                        Expanded(
                          child: FilterChip(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            selectedColor: _roastingManagementCtrl.roastingType == 2 ? Colors.brown[50] : Colors.white,
                            side: BorderSide(color: _roastingManagementCtrl.roastingType == 2 ? Colors.brown[200]! : Colors.brown[100]!),
                            checkmarkColor: Colors.orange,
                            surfaceTintColor: Colors.blue,
                            selected: _roastingManagementCtrl.roastingType == 2 ? true : false,
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            label: const Text("블렌드"),
                            onSelected: (value) => _roastingManagementCtrl.setRoastingType(2),
                          ),
                        ),
                      ],
                    ),
                    const UiSpacing(),
                    if (_roastingManagementCtrl.roastingType == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeaderTitle(title: "블렌드명", subTitle: "Blend name"),
                          TextField(
                            controller: _roastingManagementCtrl.blendNameTECtrl,
                            focusNode: _roastingManagementCtrl.blendNameFN,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: const InputDecoration(hintText: "블렌드명"),
                            onTap: () => _roastingManagementCtrl.setAllBlendNames(),
                            onChanged: (value) => _roastingManagementCtrl.getBlendNameSuggestions(),
                          ),
                          SuggestionsView(
                            suggestions: _roastingManagementCtrl.blendNameSuggestions,
                            textEditingCtrl: _roastingManagementCtrl.blendNameTECtrl,
                            focusNode: _roastingManagementCtrl.blendNameFN,
                          ),
                          const UiSpacing(),
                        ],
                      ),
                    const HeaderTitle(title: "투입 생두 정보", subTitle: "Green coffee bean input info"),
                    const NewBeanSelectionDropdown(listType: ListType.greenBeanInventory),
                    const SizedBox(height: 10),
                    if (_roastingManagementCtrl.roastingType == 2)
                      ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _roastingManagementCtrl.blendInputGreenBeans.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        itemBuilder: (context, index) => Obx(
                          () => AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _roastingManagementCtrl.opacityList[index],
                            curve: Curves.easeInOut,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10 * textScaleFactor),
                                  padding: EdgeInsets.fromLTRB(15, 15 * textScaleFactor, 10, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.brown[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              Utility().splitNameAndWeight(_roastingManagementCtrl.blendInputGreenBeans[index].toString(), 1),
                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          FocusScope(
                                            canRequestFocus: false,
                                            child: IconButton(
                                              style: IconButton.styleFrom(
                                                visualDensity: VisualDensity.compact,
                                              ),
                                              onPressed: () => _roastingManagementCtrl.deleteBlendBeanListItem(index),
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.black,
                                                size: height / 40,
                                                applyTextScaling: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                            margin: const EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                              color: Colors.brown,
                                              borderRadius: BorderRadius.circular(7),
                                            ),
                                            child: Text(
                                              "보유량",
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              Utility().splitNameAndWeight(_roastingManagementCtrl.blendInputGreenBeans[index].toString(), 2),
                                              textAlign: TextAlign.right,
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, height: 0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: GestureDetector(
                                              onTap: () {
                                                String maxWeight = _roastingManagementCtrl.blendInputGreenBeans[index].split(" / ")[1].replaceAll(RegExp(r"[,kg]"), "");
                                                _roastingManagementCtrl.blendInputWeightTECtrlList[index].text = maxWeight;
                                              },
                                              child: Text(
                                                "전량\n입력",
                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.brown, height: 1.1),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: IntrinsicWidth(
                                              child: TextField(
                                                controller: _roastingManagementCtrl.blendInputWeightTECtrlList[index],
                                                focusNode: _roastingManagementCtrl.blendInputWeightFNList[index],
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.number,
                                                style: Theme.of(context).textTheme.bodyLarge,
                                                textAlign: TextAlign.right,
                                                decoration: InputDecoration(
                                                  hintText: "투입 중량",
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                    borderSide: const BorderSide(color: Colors.white),
                                                  ),
                                                  suffixIconConstraints: const BoxConstraints(minWidth: 25),
                                                  suffixIcon: Text(
                                                    "kg",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 15,
                                  top: -5 * textScaleFactor,
                                  child: Text(
                                    (index + 1).toString().padLeft(2, "0"),
                                    style: TextStyle(
                                      fontSize: height / 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown[600],
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    // 싱글오리진
                    _roastingManagementCtrl.roastingType == 1
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "투입",
                                                style: TextStyle(
                                                  fontSize: height / 54,
                                                  color: Colors.brown,
                                                ),
                                              ),
                                              Flexible(
                                                child: TextField(
                                                  controller: _roastingManagementCtrl.singleInputWeightTECtrl,
                                                  focusNode: _roastingManagementCtrl.singleInputWeightFN,
                                                  textAlign: TextAlign.center,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.next,
                                                  decoration: InputDecoration(
                                                    hintText: "투입 중량",
                                                    suffixIconConstraints: const BoxConstraints(minWidth: 25),
                                                    suffixIcon: FocusScope(
                                                      canRequestFocus: false,
                                                      child: Text(
                                                        "kg",
                                                        textAlign: TextAlign.center,
                                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                                                      ),
                                                    ),
                                                  ),
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                  onTap: () => Utility().moveScrolling(_roastingManagementCtrl.scrollCtrl),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: TextButton(
                                              onPressed: () {
                                                if (BeanSelectionDropdownController.to.selectedBean == null) return;
                                                String maxWeight = BeanSelectionDropdownController.to.selectedBean.split(" / ")[1].replaceAll(RegExp(r"[,kg]"), "");
                                                _roastingManagementCtrl.singleInputWeightTECtrl.text = maxWeight;
                                              },
                                              child: Text(
                                                "전량 입력",
                                                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.brown),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      "배출",
                                      style: TextStyle(
                                        fontSize: height / 54,
                                        color: Colors.brown,
                                      ),
                                    ),
                                    Flexible(
                                      child: TextField(
                                        controller: _roastingManagementCtrl.singleOutputWeightTECtrl,
                                        focusNode: _roastingManagementCtrl.singleOutputWeightFN,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                          hintText: "로스팅 후 중량",
                                          suffixIconConstraints: const BoxConstraints(minWidth: 25),
                                          suffixIcon: Text(
                                            "kg",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                                          ),
                                        ),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        onTap: () => Utility().moveScrolling(_roastingManagementCtrl.scrollCtrl),
                                        onSubmitted: (value) => registerRoasting(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        // ? Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         "투입",
                        //         style: TextStyle(
                        //           fontSize: height / 54,
                        //           color: Colors.brown,
                        //         ),
                        //       ),
                        //       Flexible(
                        //         child: TextField(
                        //           controller: _roastingManagementCtrl.singleInputWeightTECtrl,
                        //           focusNode: _roastingManagementCtrl.singleInputWeightFN,
                        //           textAlign: TextAlign.center,
                        //           keyboardType: TextInputType.number,
                        //           textInputAction: TextInputAction.next,
                        //           decoration: InputDecoration(
                        //             hintText: "투입 중량",
                        //             suffixIconConstraints: const BoxConstraints(minWidth: 25),
                        //             suffixIcon: FocusScope(
                        //               canRequestFocus: false,
                        //               child: Text(
                        //                 "kg",
                        //                 textAlign: TextAlign.center,
                        //                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                        //               ),
                        //             ),
                        //           ),
                        //           style: Theme.of(context).textTheme.bodyMedium,
                        //           onTap: () => Utility().moveScrolling(_roastingManagementCtrl.scrollCtrl),
                        //         ),
                        //       ),
                        //       const SizedBox(width: 15),
                        //       Text(
                        //         "배출",
                        //         style: TextStyle(
                        //           fontSize: height / 54,
                        //           color: Colors.brown,
                        //         ),
                        //       ),
                        //       Flexible(
                        //         child: TextField(
                        //           controller: _roastingManagementCtrl.singleOutputWeightTECtrl,
                        //           focusNode: _roastingManagementCtrl.singleOutputWeightFN,
                        //           textAlign: TextAlign.center,
                        //           keyboardType: TextInputType.number,
                        //           textInputAction: TextInputAction.done,
                        //           decoration: InputDecoration(
                        //             hintText: "로스팅 후 중량",
                        //             suffixIconConstraints: const BoxConstraints(minWidth: 25),
                        //             suffixIcon: Text(
                        //               "kg",
                        //               textAlign: TextAlign.center,
                        //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                        //             ),
                        //           ),
                        //           style: Theme.of(context).textTheme.bodyMedium,
                        //           onTap: () => Utility().moveScrolling(_roastingManagementCtrl.scrollCtrl),
                        //           onSubmitted: (value) => registerRoasting(),
                        //         ),
                        //       ),
                        //     ],
                        //   )
                        // 블렌드
                        : Row(
                            children: [
                              Text(
                                "배출",
                                style: TextStyle(
                                  fontSize: height / 54,
                                  color: Colors.brown,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _roastingManagementCtrl.blendOutputWeightTECtrl,
                                  focusNode: _roastingManagementCtrl.blendOutputWeightFN,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "로스팅 후 중량",
                                    suffixIconConstraints: const BoxConstraints(minWidth: 25),
                                    suffixIcon: Text(
                                      "kg",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  onTap: () => Utility().moveScrolling(_roastingManagementCtrl.scrollCtrl),
                                  onSubmitted: (value) => registerRoasting(),
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
                              if (confirm == true && context.mounted) _roastingManagementCtrl.clearData(context);
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
                              onTap: registerRoasting,
                              child: Container(
                                color: Colors.brown,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Text(
                                  "로스팅 등록",
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
      ),
    );
  }
}
