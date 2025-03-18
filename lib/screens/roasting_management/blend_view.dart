import 'package:bean_diary/controllers/roasting_management_controller.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/suggestions_view.dart';
import 'package:bean_diary/widgets/ui_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlendView extends StatelessWidget {
  const BlendView({super.key});

  @override
  Widget build(BuildContext context) {
    final roastingManagementCtrl = Get.find<RoastingManagementController>();
    return Column(
      children: [
        const HeaderTitle(title: "블렌드명", subTitle: "Blend name"),
        TextField(
          controller: roastingManagementCtrl.blendNameTECtrl,
          focusNode: roastingManagementCtrl.blendNameFN,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(hintText: "블렌드명"),
        ),
        SuggestionsView(
          suggestions: roastingManagementCtrl.blendNameSuggestions,
          textEditingCtrl: roastingManagementCtrl.blendNameTECtrl,
          focusNode: roastingManagementCtrl.blendNameFN,
        ),
        const UiSpacing(),
        const HeaderTitle(title: "투입 생두 정보", subTitle: "Green coffee bean input info"),
      ],
    );
  }
}
