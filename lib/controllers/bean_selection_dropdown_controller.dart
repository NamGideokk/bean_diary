import 'package:bean_diary/controllers/roasting_management_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:get/get.dart';

class BeanSelectionDropdownController extends GetxController {
  static BeanSelectionDropdownController get to => Get.find();

  final RxBool _isLoading = false.obs;
  final RxList _beans = [].obs;
  final Rxn<String> _selectedBean = Rxn<String>(null);

  get isLoading => _isLoading.value;
  get beans => _beans;
  get selectedBean => _selectedBean.value;

  /*
  목록 : 생두명, 생두명+재고, 원두명+재고
  액션 : 생두 선택, 생두 목록 추가, 원두 선택
   */

  /// 25-03-14
  ///
  /// 생두/생두 재고/원두 재고 목록 가져오기
  Future<void> getBeans(ListType listType) async {
    if (isLoading) return;
    _isLoading(true);
    if (listType == ListType.greenBean) {
      // 생두
      final result = await GreenBeansSqfLite().getGreenBeans();
      List list = [];
      if (result.isNotEmpty) {
        for (final bean in Utility().sortingName(result)) {
          list.add(bean["name"]);
        }
      }
      _beans(list);
    } else if (listType == ListType.greenBeanInventory) {
      // 생두 재고
      final result = await GreenBeanStockSqfLite().getGreenBeanStock();
      List list = [];
      if (result.isNotEmpty) {
        for (final bean in Utility().sortingName(result)) {
          list.add("${bean["name"]} / ${Utility().numberFormat(Utility().parseToDoubleWeight(bean["weight"]))}kg");
        }
      }
      _beans(list);
    } else {
      // 원두 재고
      final result = await RoastingBeanStockSqfLite().getRoastingBeanStock();
      List list = [];
      if (result.isNotEmpty) {
        for (final bean in Utility().sortingName(result)) {
          list.add("${bean["name"]} / ${Utility().numberFormat(Utility().parseToDoubleWeight(bean["roasting_weight"]))}kg");
        }
      }
      _beans(list);
    }
    _isLoading(false);
  }

  /// 25-03-14
  ///
  /// 목록 선택하기
  void onChanged(Object? value, ListType listType) {
    if (listType == ListType.greenBean) {
      // 생두 선택
      _selectedBean(value.toString());
    } else if (listType == ListType.greenBeanInventory) {
      // (블렌드 로스팅) 생두 목록 추가
      final roastingManagementCtrl = Get.find<RoastingManagementController>();
      if (roastingManagementCtrl.roastingType == 1) {
        // 싱글오리진
        _selectedBean(value.toString());
      } else {
        // 블렌드
        roastingManagementCtrl.addInputGreenBeans(value.toString());
      }
    } else {
      // 원두 선택
      _selectedBean(value.toString());
    }
  }

  /// 25-03-14
  ///
  /// 선택 값 null 할당하기
  void resetSelectedBean() => _selectedBean.value = null;
}
