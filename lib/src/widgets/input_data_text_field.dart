// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import '../utils/my_colors.dart';

class TextDataBasic extends StatelessWidget {
  TextDataBasic(
      {Key? key,
      required this.label,
      required this.icon,
      this.maxLength,
      this.maxLines,
      this.size,
      required this.type,
      required this.controller,
      this.readOnly = false,
      this.onTapSuffix,
      this.iconSuffix,
      this.colorIconSuffix})
      : super(key: key);

  final String? label;
  final IconData? icon;
  final int? maxLength;
  final int? maxLines;
  final double? size;
  final TextInputType? type;
  final TextEditingController? controller;
  final bool readOnly;
  Function()? onTapSuffix;
  IconData? iconSuffix = Icons.clear_sharp;
  Color? colorIconSuffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 80,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: MyColors.secondaryColorOpacity,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
      maxLines: maxLines,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 20),
      controller: controller,
      maxLength: maxLength,
      keyboardType: type,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: MyColors.primaryColor,
        ),
        labelText: label,
        counterText: "", 
        prefixIcon: Icon(
          icon,
          color: MyColors.primaryColor,
        ),
        suffix: onTapSuffix == null
            ? null
            : GestureDetector(
                child: Icon(
                  iconSuffix,
                  color: colorIconSuffix ?? MyColors.primaryColor,
                  size: 30,
                ),
                onTap: onTapSuffix,
              ),
      ),
    ),
    );
  }
}
