import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverScrollBehavior extends ScrollBehavior{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return GlowingOverscrollIndicator(axisDirection: axisDirection,
        showTrailing: false,
        showLeading: false,
        child: child,
        color: Colors.transparent);
  }
}