import 'package:flutter/material.dart';

class WeightAlert extends StatelessWidget {
  const WeightAlert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: height / 30,
            color: Colors.red,
          ),
          const SizedBox(height: 5),
          Text(
            "중량은 반드시 소수점을 포함해\n첫째 자리까지 입력해 주세요.\n예) 10kg > 10.0, 100.5kg > 100.5\n* 10g 이하 단위는 지원하지 않습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: height / 58,
            ),
          ),
        ],
      ),
    );
  }
}
