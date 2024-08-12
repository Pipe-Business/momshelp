import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/date.dart';

class TimePicker extends StatefulWidget {
  final DateTime? dateTime;

  const TimePicker({super.key, required this.dateTime});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    print("rebuild ${widget.dateTime}");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimePickerSpinner(
          key: ValueKey(widget.dateTime),
          time: widget.dateTime,
          is24HourMode: false,
          spacing: 40,
          highlightedTextStyle: TextStyle(fontSize: 30,fontWeight: FontWeight.w600),
          normalTextStyle: TextStyle(fontSize: 30,color: Colors.grey),
          itemHeight: 70,
          isForce2Digits: true,
          onTimeChange: (time) {
            setState(() {
            });
          },
        )
      ],
    );
  }
}
