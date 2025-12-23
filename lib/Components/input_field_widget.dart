import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constants.dart';

class CustomInputField extends StatefulWidget {
  final bool isDark;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool enable;
  final Widget? sufixWidget;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const CustomInputField({
    required this.isDark,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.enable = true,
    this.sufixWidget,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.validator,
    this.onChanged,
    super.key,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            widget.label,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: Constants.getTextColor(widget.isDark),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          cursorColor: Constants.accentColor,
          controller: widget.controller,
          obscureText: widget.isPassword,
          validator: widget.validator,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          enabled: widget.enable,
          style: TextStyle(
            color: Constants.getTextColor(widget.isDark),
            fontSize: 15,
            fontFamily: Constants.onboardingTextFont,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Constants.getTextSecondaryColor(widget.isDark).withOpacity(0.6),
              fontSize: 15,
              fontFamily: Constants.onboardingTextFont,
            ),
            filled: true,
            fillColor: Constants.getInputBackgroundColor(widget.isDark),
            contentPadding: const EdgeInsets.all(20),
            suffixIcon: widget.sufixWidget,
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Constants.getBorderColor(widget.isDark),
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Constants.errorColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Constants.getBorderColor(widget.isDark),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Constants.accentColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
