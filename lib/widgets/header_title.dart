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
    final textScaleFactor = MediaQuery.of(context).textScaler.scale(1);
    return Padding(
      padding: EdgeInsets.only(bottom: 10 * textScaleFactor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 2.0),
            style: TextStyle(
              fontSize: height / 40,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Visibility(
            visible: subTitle != "",
            child: Text(
              subTitle,
              textAlign: TextAlign.center,
              textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 2.0),
              style: TextStyle(
                fontSize: height / 64,
                color: Colors.black45,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
