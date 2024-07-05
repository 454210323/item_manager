import 'package:flutter/material.dart';

class PageButton extends StatefulWidget {
  final int totalPages;
  final void Function(int) onCurrentPageChange;
  final void Function(int) onPageSizeChange;

  const PageButton({
    super.key,
    required this.totalPages,
    required this.onCurrentPageChange,
    required this.onPageSizeChange,
  });

  @override
  State<PageButton> createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> {
  int pageSize = 20;
  int currentPage = 1;

  Widget _buildPageButton(int page) {
    return TextButton(
      onPressed: () {
        setState(() {
          currentPage = page;
        });
        widget.onCurrentPageChange(page);
      },
      style: TextButton.styleFrom(
        foregroundColor: currentPage == page ? Colors.blue : Colors.black,
      ),
      child: Text(
        '$page',
        style: TextStyle(
          fontWeight: currentPage == page ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  List<Widget> _buildPageButtons() {
    List<Widget> buttons = [];
    if (widget.totalPages <= 7) {
      for (int i = 1; i <= widget.totalPages; i++) {
        buttons.add(_buildPageButton(i));
      }
    } else {
      buttons.add(_buildPageButton(1));
      buttons.add(_buildPageButton(2));

      if (currentPage > 4) {
        buttons.add(const Text(' ... '));
      }

      for (int i = currentPage - 1; i <= currentPage + 1; i++) {
        if (i > 2 && i < widget.totalPages - 1) {
          buttons.add(_buildPageButton(i));
        }
      }

      if (currentPage < widget.totalPages - 3) {
        buttons.add(const Text(' ... '));
      }

      buttons.add(_buildPageButton(widget.totalPages - 1));
      buttons.add(_buildPageButton(widget.totalPages));
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._buildPageButtons(),
            SizedBox(width: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   borderRadius: BorderRadius.circular(8.0),
              // ),
              child: DropdownButton<int>(
                value: pageSize,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      pageSize = newValue;
                    });
                    widget.onPageSizeChange(pageSize);
                  }
                },
                items: <int>[10, 20, 50, 100]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value per page'),
                  );
                }).toList(),
                underline: SizedBox(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
