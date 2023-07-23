import 'package:bean_diary/controller/warehousing_green_bean_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeanSelectDropdownButton extends StatefulWidget {
  final int listType;

  /// int listType :
  /// * 0 = 생두 (green bean)
  /// * 1 = 원두 (coffee bean)
  /// * 2 = 생두 재고 (green bean stock)
  const BeanSelectDropdownButton({
    Key? key,
    required this.listType,
  }) : super(key: key);

  @override
  State<BeanSelectDropdownButton> createState() => _BeanSelectDropdownButtonState();
}

class _BeanSelectDropdownButtonState extends State<BeanSelectDropdownButton> {
  final _warehousingGreenBeanCtrl = Get.find<WarehousingGreenBeanController>();
  final _beanSelectFN = FocusNode();

  @override
  void initState() {
    super.initState();
    _warehousingGreenBeanCtrl.setListType(widget.listType);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.brown[100]!,
          width: 0.8,
        ),
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Obx(
        () => DropdownButton(
          isExpanded: true,
          focusNode: _beanSelectFN,
          disabledHint: Text(
            widget.listType == 0 || widget.listType == 2 ? "생두를 등록해 주세요" : "로스팅된 원두가 없습니다",
            style: TextStyle(
              fontSize: height / 52,
            ),
          ),
          underline: const SizedBox(),
          value: _warehousingGreenBeanCtrl.selectedBean,
          menuMaxHeight: height / 3,
          dropdownColor: Colors.brown[50],
          borderRadius: BorderRadius.circular(5),
          style: TextStyle(
            fontSize: height / 52,
            color: Colors.black,
          ),
          iconEnabledColor: Colors.brown,
          hint: Text(widget.listType == 0 || widget.listType == 2 ? "생두 선택" : "원두 선택"),
          items: _warehousingGreenBeanCtrl.beanList?.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (value) {
            _warehousingGreenBeanCtrl.setSelectBean(value.toString());
          },
        ),
      ),
    );
  }
}
