import 'package:bean_diary/controllers/bean_selection_dropdown_controller.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewBeanSelectionDropdown extends StatefulWidget {
  final ListType listType;

  /// enum listType :
  /// * greenBean = 생두
  /// * greenBeanInventory = 생두 재고
  /// * roastedBeanInventory = 원두 재고
  const NewBeanSelectionDropdown({
    Key? key,
    required this.listType,
  }) : super(key: key);

  @override
  State<NewBeanSelectionDropdown> createState() => _NewBeanSelectionDropdownState();
}

class _NewBeanSelectionDropdownState extends State<NewBeanSelectionDropdown> {
  final _beanSelectFN = FocusNode();

  @override
  void initState() {
    super.initState();
    BeanSelectionDropdownController.to.resetSelectedBean();
  }

  @override
  void dispose() {
    super.dispose();
    _beanSelectFN.dispose();
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
          itemHeight: null,
          disabledHint: Text(
            widget.listType == ListType.greenBean
                ? "생두를 등록해 주세요"
                : widget.listType == ListType.greenBeanInventory
                    ? "입고된 생두가 없습니다"
                    : "로스팅된 원두가 없습니다.",
            style: TextStyle(
              fontSize: height / 52,
            ),
          ),
          underline: const SizedBox(),
          value: BeanSelectionDropdownController.to.selectedBean,
          menuMaxHeight: height / 3,
          dropdownColor: Colors.brown[50],
          borderRadius: BorderRadius.circular(5),
          style: Theme.of(context).textTheme.bodyMedium,
          iconEnabledColor: Colors.brown,
          hint: Text(widget.listType == ListType.greenBean || widget.listType == ListType.greenBeanInventory ? "투입 생두 선택" : "원두 선택"),
          items: BeanSelectionDropdownController.to.beans?.map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            );
          }).toList(),
          onChanged: (value) => BeanSelectionDropdownController.to.onChanged(value, widget.listType),
        ),
      ),
    );
  }
}
