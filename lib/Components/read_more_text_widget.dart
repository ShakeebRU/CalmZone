import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/constants.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int trimLength;

  const ReadMoreText({
    super.key,
    required this.text,
    this.trimLength = 100, // Adjust based on your UI
  });

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.text;
    final isTrimmed = text.length > widget.trimLength;
    final displayText = isExpanded || !isTrimmed
        ? text
        : text.substring(0, widget.trimLength).trim();

    return RichText(
      text: TextSpan(
        text: displayText,
        style: GoogleFonts.outfit(
          fontSize: 12,
          color: Color(0xFF9B9B9B),
          fontWeight: FontWeight.w400,
        ),
        children: isTrimmed
            ? [
                TextSpan(
                  text: isExpanded ? ' Read Less' : '...Read More',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Constants.secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                ),
              ]
            : [],
      ),
    );
  }
}
