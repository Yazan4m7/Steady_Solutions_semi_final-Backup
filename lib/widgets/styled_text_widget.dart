import 'package:flutter/material.dart';

class BSText extends StatelessWidget {
  final String text;
  final TextStyle? style; // Allow for style overrides if needed

  const BSText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:Theme.of(context).textTheme.bodySmall, // Use bodyText1 as the default
    );
  }
}