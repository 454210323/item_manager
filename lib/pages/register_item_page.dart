import "package:flutter/material.dart";
import "package:flutter_application_1/widgets/register_item_form.dart";

class RegisterItemPage extends StatelessWidget {
  const RegisterItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: RegisterItemForm(),
    );
  }
}
