import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> children;

  CustomExpansionTile({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data:
          Theme.of(context).copyWith(dividerColor: Colors.transparent), // 去除边框线
      child: ExpansionTile(
        title: Text(title),
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(left: 16.0), // 子菜单缩进
                  child: child,
                ))
            .toList(),
      ),
    );
  }
}
