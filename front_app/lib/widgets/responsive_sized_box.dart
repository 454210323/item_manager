import 'package:flutter/material.dart';

class ResponsiveSizedBox extends StatelessWidget {
  final Widget child;

  const ResponsiveSizedBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 800) {
      return SizedBox(
        width: 80,
        child: child,
      );
    } else if (screenWidth < 1600) {
      return SizedBox(
        width: 150,
        child: child,
      );
    } else {
      return SizedBox(
        width: 300,
        child: child,
      );
    }
  }
}
