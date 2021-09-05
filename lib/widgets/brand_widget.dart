import 'package:flutter/material.dart';

class BrandWidget extends StatelessWidget {
  final double size;
  final double fontSize;

  const BrandWidget({
    required this.size,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlutterLogo(size: size),
          Text(
            "Teams",
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
