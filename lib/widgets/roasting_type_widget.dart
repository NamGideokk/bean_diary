import 'package:bean_diary/utility/colors_list.dart';
import 'package:flutter/material.dart';

class RoastingTypeWidget extends StatelessWidget {
  final String type;
  const RoastingTypeWidget({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        // color: Colors.brown[400]!.withOpacity(0.9),
        color: type == "1" ? ColorsList().chip8Color : ColorsList().chip3Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        type == "1" ? "싱글오리진" : "블렌드",
        style: TextStyle(
          color: Colors.white,
          fontSize: height / 67,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
