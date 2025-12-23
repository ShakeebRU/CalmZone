import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/constants.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String? hint;
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String Function(T)? displayProperty;

  const CustomDropdown({
    super.key,
    this.hint,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.displayProperty,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            widget.label,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black),
          ),
        ),
        const SizedBox(height: 5.0),
        DropdownButtonFormField<T>(
          initialValue: widget.value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: Colors.black,
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: Constants.onboardingTextFont,
          ),
          isExpanded: true,
          decoration: InputDecoration(
            hintText: widget.hint ?? widget.label,
            hintStyle: TextStyle(
              color: const Color(0xFFC4C3C3),
              fontSize: 15,
              fontFamily: Constants.onboardingTextFont,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Color(0xFFD9D9D9),
                strokeAlign: 1,
                width: 1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Colors.red,
                strokeAlign: 1,
                width: 1,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Color(0xFFD9D9D9),
                strokeAlign: 1,
                width: 1,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(
                color: Color(0xFFD9D9D9),
                strokeAlign: 1,
                width: 1,
              ),
            ),
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(20),
          ),
          items: widget.items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    widget.displayProperty != null
                        ? widget.displayProperty!(item)
                        : item.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: Constants.onboardingTextFont,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ],
    );
  }
}
