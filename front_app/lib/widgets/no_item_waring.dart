import 'package:flutter/material.dart';

import '../pages/register_item_page.dart';

class NoItemWaring {
  static Future<void> showNoItemWaring(BuildContext context,
      {required String itemCode}) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('商品未登录'),
          content: Text('$itemCode这件商品没有登陆，需要登陆吗'),
          actions: <Widget>[
            TextButton(
              child: const Text('去登陆'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => RegisterItemPage(
                            itemCode: itemCode,
                          )),
                );
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
