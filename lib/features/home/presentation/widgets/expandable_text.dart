import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLength;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLength = 100,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool shouldTrim = widget.text.length > widget.trimLength;
    final String visibleText = shouldTrim && !isExpanded
        ? '${widget.text.substring(0, widget.trimLength)}...'
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          visibleText,
          style: const TextStyle(fontSize: 16),
        ),
        if (shouldTrim)
          TextButton(
            onPressed: () => setState(() => isExpanded = !isExpanded),
            child: Text(
              isExpanded ? 'return' : 'Read More..',
              style: const TextStyle(color: Colors.purple),
            ),
          ),
      ],
    );
  }
}
