import 'package:flutter/material.dart';

/// Reusable SelectableText - allows users to select and copy text
class AppSelectableText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;

  const AppSelectableText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      data,
      style: style,
      textAlign: textAlign,
    );
  }
}
