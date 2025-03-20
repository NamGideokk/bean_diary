import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';

class LabelContentRow extends StatelessWidget {
  final int? type;
  final String label;
  final String? content;
  final List? chips;
  final List? contents;
  final int? length;

  /// int type
  /// * 0 : 기본형
  /// * 1 : expansionTile형
  /// * 2 : chip형
  const LabelContentRow({
    super.key,
    this.type = 0,
    required this.label,
    this.content,
    this.chips,
    this.contents,
    this.length,
  });

  factory LabelContentRow.list({
    int? type,
    required String label,
    required String content,
    required int length,
  }) {
    return LabelContentRow(
      type: 1,
      label: label,
      content: content,
      length: length,
    );
  }

  factory LabelContentRow.chip({
    int? type,
    required String label,
    required List chips,
    required List contents,
  }) {
    return LabelContentRow(
      type: 2,
      label: label,
      chips: chips,
      contents: contents,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.brown[50],
          borderRadius: BorderRadius.circular(5),
        ),
        child: type == 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.brown),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      content!,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )
            : type == 1
                ? ListTileTheme(
                    // ExpansionTile 의 기본 패딩 완전히 없애기
                    data: const ListTileThemeData(
                      minTileHeight: 0,
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                    ),
                    child: ExpansionTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      collapsedShape: LinearBorder.none,
                      shape: LinearBorder.none,
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                      showTrailingIcon: true,
                      minTileHeight: 0,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.brown),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              length == 0 ? "" : "${Utility().numberFormat(length.toString(), isWeight: false)}곳",
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            content!,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          Text(
                            label,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.brown),
                          ),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              "${Utility().numberFormat(chips!.length.toString(), isWeight: false)}건",
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      for (int i = 0; i < chips!.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.brown,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  chips![i],
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  contents![i],
                                  textAlign: TextAlign.right,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
      ),
    );
  }
}
