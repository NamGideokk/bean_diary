import 'package:flutter/material.dart';

class BottomButtonBorderContainer extends StatelessWidget {
  /// 하단 고정 버튼의 상단 그라디언트 컨테이너
  const BottomButtonBorderContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.01, 1],
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
    );
  }
}
