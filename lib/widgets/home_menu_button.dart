import 'package:flutter/material.dart';

class HomeMenuButton extends StatelessWidget {
  final List menus;
  final int index;
  final Function() onPressed;
  const HomeMenuButton({
    Key? key,
    required this.menus,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      clipBehavior: Clip.hardEdge,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        elevation: 5,
        shadowColor: Colors.brown[900],
        backgroundColor: Colors.brown[50],
      ),
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            menus[index]["title"],
            style: TextStyle(
              color: Colors.brown[900],
              fontSize: height / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              menus[index]["img"],
              width: height / 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final List menus;
  final int index;
  final Function() onPressed;
  const _MenuButton({
    Key? key,
    required this.menus,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      clipBehavior: Clip.hardEdge,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        elevation: 5,
        shadowColor: Colors.brown[900],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.brown,
      ),
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            menus[index]["title"],
            style: TextStyle(
              color: Colors.brown[900],
              fontSize: height / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              menus[index]["img"],
              width: height / 14,
            ),
          ),
        ],
      ),
    );
  }
}
