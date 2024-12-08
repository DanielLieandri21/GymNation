import 'package:flutter/material.dart';

class DiscountItem extends StatelessWidget {
  final String title;
  final String discount;

  const DiscountItem({
    super.key,
    required this.title,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            Text(
              "$discount %",
              style: const TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
