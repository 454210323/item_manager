import "package:flutter/material.dart";
import "package:flutter_application_1/widgets/register_item_form.dart";

class RegisterItemPage extends StatelessWidget {
  const RegisterItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register New Item'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: RegisterItemForm(),
        ));
  }
}
