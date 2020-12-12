import 'package:flutter/material.dart';
import 'package:mobile/src/utils/Format.dart';

class WaterAmountComponent extends StatelessWidget {
  final String text;
  final double amount;
  final Color color;

  const WaterAmountComponent({Key key, this.text, this.amount, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$text",
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${Format.formatNumber(amount)} LITROS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
          color: color,
        ),
      ),
    );
  }
}
