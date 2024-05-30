import 'package:etr_mark/theme.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    this.prefixIcon,
    required this.controller,
    required this.label,
    this.marginBottom = 16,
  }) : super(key: key);
  final String label;
  final double marginBottom;
  final TextEditingController controller;
  final Widget? prefixIcon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: marginBottom,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: prefixIcon != null ? 8 : 24,
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
