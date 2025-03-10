import 'package:flutter/material.dart';

class UiSpacing extends StatelessWidget {
  const UiSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
    return SizedBox(height: 40 * textScaleFactor);
  }
}
