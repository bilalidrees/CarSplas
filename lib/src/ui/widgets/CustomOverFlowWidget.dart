import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOverFlowWidget extends StatelessWidget {
  Widget child;

  CustomOverFlowWidget({this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: child,
        )
      ],
    );
  }
}
