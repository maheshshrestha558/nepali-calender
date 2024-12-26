import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';

class BasicCalendar extends StatefulWidget {
  const BasicCalendar({Key? key}) : super(key: key);

  @override
  State<BasicCalendar> createState() => _BasicCalendarState();
}

class _BasicCalendarState extends State<BasicCalendar> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Calendar'),
      ),
      body: FlutterBSADCalendar(
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100),
        onMonthChanged: (date, events) {
          setState(() {
            _selectedDate = date;
          });
        },
        onDateSelected: (date, events) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
}
