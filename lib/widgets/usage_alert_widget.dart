import 'package:flutter/material.dart';

class UsageAlertWidget extends StatelessWidget {
  final bool? isWeightGuide;
  const UsageAlertWidget({
    Key? key,
    this.isWeightGuide = true,
  }) : super(key: key);

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
            isWeightGuide == true
                ? "중량은 반드시 소수점 첫째 자리까지 입력해 주세요.\n예) 10kg > 10.0, 100.5kg > 100.5\n* 10g 이하 단위는 지원하지 않습니다."
                : "백업을 눌러 복사된 텍스트 데이터는\n절대로 재가공하지 마세요.\n재가공하여 복구가 불가능할 경우,\n책임은 사용자 본인에게 있습니다.",
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
