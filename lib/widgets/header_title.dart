import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  final String title, subTitle;
  const HeaderTitle({
    Key? key,
    required this.title,
    this.subTitle = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(
            fontSize: height / 50,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          children: [
            if (subTitle != "")
              TextSpan(
                text: "\t\t$subTitle",
                style: TextStyle(
                  fontSize: height / 60,
                  color: Colors.black45,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
