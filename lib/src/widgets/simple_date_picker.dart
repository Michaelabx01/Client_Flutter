import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../utils/my_colors.dart';

class SimpleDatePicker extends StatelessWidget {
  const SimpleDatePicker({
    Key? key,
    required this.text,
    required this.onConfirm,
    this.formatDatePattern,
    this.minTime,
    this.maxTime,
    this.currentTime,
  }) : super(key: key);

  final String text;
  final DateTime? minTime;
  final DateTime? maxTime;
  final DateTime? currentTime;
  final void Function(DateTime date, String dateFormatted)? onConfirm;
  final String? formatDatePattern;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      // padding: const EdgeInsets.all(3),
      height: 75,
      // decoration: BoxDecoration(
      //   color: MyColors.secondaryColorOpacity,
      //   borderRadius: BorderRadius.circular(25),
      // ),
      child: Material(
        // elevation: 6,
        color: MyColors.secondaryColorOpacity,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: () {
            DatePicker.showDatePicker(context,
                theme: const DatePickerTheme(
                  containerHeight: 210.0,
                ),
                showTitleActions: true,
                minTime: minTime,
                maxTime: maxTime, onConfirm: (date) {
              if (onConfirm != null) {
                String dateFormatted;
                if (formatDatePattern != null &&
                    formatDatePattern!.isNotEmpty) {
                  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                  dateFormatted = dateFormat.format(date);
                } else {
                  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                  dateFormatted = dateFormat.format(date);
                }
                onConfirm!(date, dateFormatted);
              }
            },
                currentTime: currentTime, //.AddSeconds(86399)
                locale: LocaleType.es);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: MyColors.primaryColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Cumpleaños",
                      style:
                          TextStyle(fontSize: 17, color: MyColors.primaryColor),
                    ),
                  ],
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 20, color: MyColors.primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
