import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionsView extends StatelessWidget {
  final List suggestions;
  final TextEditingController textEditingCtrl;
  final FocusNode focusNode;

  const SuggestionsView({
    super.key,
    required this.suggestions,
    required this.textEditingCtrl,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Visibility(
      visible: focusNode.hasFocus,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          constraints: BoxConstraints(maxHeight: height / 5),
          decoration: BoxDecoration(
            color: Colors.brown[50],
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 1)],
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) => ListTile(
                contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                onTap: () {
                  textEditingCtrl.text = suggestions[index];
                  focusNode.unfocus();
                },
                title: Text(
                  suggestions[index],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: IconButton(
                  style: IconButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(14),
                    minimumSize: const Size(0, 0),
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => textEditingCtrl.text = "${suggestions[index]} ",
                  icon: Icon(
                    Icons.arrow_outward_rounded,
                    size: height / 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
