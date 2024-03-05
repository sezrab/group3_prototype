import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final void Function() onPressed;
  final double? height;
  const WideButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.color,
      this.textColor,
      this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: color,
            foregroundColor: textColor,
            // minimumSize: Size(double.infinity, height ?? 50),
          ),
          child: child),
    );
  }
}
