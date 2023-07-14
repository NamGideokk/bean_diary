import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String content;
  const EmptyWidget({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text(
          content,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
