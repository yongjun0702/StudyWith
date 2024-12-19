import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const CustomContainer({
    Key? key,
    required this.child,
    this.width,
    this.padding,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color ?? Colors.white,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: child,
      ),
    );
  }
}
