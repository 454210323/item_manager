import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final String hint;
  final List<String> options;
  final void Function(String) onSelected;
  final String? initialValue;

  const CustomDropdownButton({
    super.key,
    required this.hint,
    required this.options,
    required this.onSelected,
    this.initialValue,
  });

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double boxWidth = 100;
    if (screenWidth < 800) {
      boxWidth = 50;
    } else if (screenWidth < 1600) {
      boxWidth = 100;
    } else {
      boxWidth = 200;
    }

    return SizedBox(
      width: boxWidth,
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(widget.hint),
        value: _selectedValue,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedValue = newValue;
            });
            widget.onSelected(newValue);
          }
        },
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
            ),
          );
        }).toList(),
      ),
    );
  }
}
