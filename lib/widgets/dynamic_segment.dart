import 'package:flutter/material.dart';

class DynamicSegment extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onValueChanged;

  const DynamicSegment(
      {Key? key, required this.options, required this.onValueChanged})
      : super(key: key);

  @override
  State<DynamicSegment> createState() => _DynamicSegmentState();
}

class _DynamicSegmentState extends State<DynamicSegment> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = widget.options.map((String option) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(option),
      );
    }).toList();

    return ToggleButtons(
      children: children,
      onPressed: (int index) {
        setState(() {
          selectedIndex = index;
        });
        widget.onValueChanged(widget.options[index]);
      },
      isSelected: List.generate(
          widget.options.length, (index) => index == selectedIndex),
    );
  }
}
