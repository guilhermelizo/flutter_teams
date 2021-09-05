import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class LockSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Ionicons.lock_closed_outline,
          size: 128,
        ),
        Text(
          "Seção bloqueada",
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}
