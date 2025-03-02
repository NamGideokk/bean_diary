import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';

class LabelContentRow extends StatelessWidget {
  final String label, content;
  final int? length;
  final bool expansionTileType;
  const LabelContentRow({
    super.key,
    required this.label,
    required this.content,
    this.length,
    this.expansionTileType = false,
  });

  factory LabelContentRow.list({
    required String label,
    required String content,
    required int length,
  }) {
    return LabelContentRow(
      label: label,
      content: content,
      length: length,
      expansionTileType: true,
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
        child: expansionTileType
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
                        content,
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
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
                      content,
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
