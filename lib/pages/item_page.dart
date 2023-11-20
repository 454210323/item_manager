import 'package:flutter/material.dart';

import '../widgets/item_list.dart';
import '../widgets/register_new_item_button.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            RegisterNewItemButton(),
            Expanded(
              child: ItemList(),
            ),
          ],
        ),
      ),
    );
  }
}
