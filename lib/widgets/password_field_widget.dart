import 'package:etr_mark/theme.dart';
import 'package:flutter/material.dart';

class PasswordFieldWidget extends StatefulWidget {
  const PasswordFieldWidget(
      {Key? key,
      this.prefixIcon,
      required this.controller,
      required this.label,
      this.marginBottom = 16})
      : super(key: key);
  final String label;
  final double marginBottom;
  final TextEditingController controller;
  final Widget? prefixIcon;
  @override
  State<PasswordFieldWidget> createState() => _PasswordFieldWidgetState();
}

class _PasswordFieldWidgetState extends State<PasswordFieldWidget> {
  bool hide = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: widget.marginBottom,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: widget.prefixIcon != null ? 8 : 24,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: hide,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          labelText: widget.label,
          border: InputBorder.none,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                hide = !hide;
              });
            },
            child: Icon(
              hide ? Icons.visibility_off : Icons.visibility,
              color: primaryColor,
              size: 21,
            ),
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
