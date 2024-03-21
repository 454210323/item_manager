import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, String type) {
  Color getColor(String type) {
    if (type == 'success') {
      return Colors.green;
    } else if (type == 'warning') {
      return Colors.blue;
    } else if (type == 'error') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 5),
    backgroundColor: getColor(type),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
