import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final double? margin;
  final double? horizontalMargin;
  final double? verticalMargin;

  const GradientButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.margin,
      this.borderRadius,
      this.width,
      this.height = 40.0,
      this.horizontalMargin,
      this.verticalMargin,
      this.gradient = const LinearGradient(colors: [
        Color.fromRGBO(219, 0, 255, 1),
        Color.fromRGBO(61, 115, 255, 1),
        Color.fromRGBO(25, 5, 253, 1)
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)});

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(20);
    final horizontalMargin = this.horizontalMargin ?? 10.0;
    final verticalMargin = this.verticalMargin ?? 20.0;
    return Container(
      width: width,
      height: height,
      margin: EdgeInsetsDirectional.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
          padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 8,
            offset: Offset(4, 4),
          )
        ]
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: borderRadius)),
        child: child,
      ),
    );
  }
}
