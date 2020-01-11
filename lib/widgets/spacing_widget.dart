import 'package:flutter/material.dart';

class SpacingWidget extends StatelessWidget {
  final double bottomSpacing;
  final Widget child;

  SpacingWidget({this.bottomSpacing, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: child,
    );
  }
}
