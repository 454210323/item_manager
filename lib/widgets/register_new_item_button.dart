import 'package:flutter/material.dart';

import '../pages/register_item_page.dart';

class RegisterNewItemButton extends StatelessWidget {
  const RegisterNewItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RegisterItemPage()),
          );
        },
        child: const Text('Register New Item'),
      ),
    );
  }
}
