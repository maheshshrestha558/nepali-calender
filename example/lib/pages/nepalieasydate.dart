// ignore_for_file: deprecated_member_use

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

class NepaliDateTimeLineExample extends StatefulWidget {
  const NepaliDateTimeLineExample({super.key});

  @override
  NepaliDateTimeLineExampleState createState() =>
      NepaliDateTimeLineExampleState();
}

class NepaliDateTimeLineExampleState extends State<NepaliDateTimeLineExample> {
  DateTime _selectedDate = DateTime.now();
  String convertToNepaliNumber(int number) {
    const List<String> nepaliDigits = [
      '०',
      '१',
      '२',
      '३',
      '४',
      '५',
      '६',
      '७',
      '८',
      '९'
    ];
    return number
        .toString()
        .split('')
        .map((digit) => nepaliDigits[int.parse(digit)])
        .join('');
  }

  String getNepaliWeekday(int weekday) {
    const List<String> nepaliWeekdays = [
      "सोमवार", // Monday
      "मंगलवार", // Tuesday
      "बुधवार", // Wednesday
      "बिहीवार", // Thursday
      "शुक्रवार", // Friday
      "शनिवार", // Saturday
      "आइतवार", // Sunday
    ];
    return nepaliWeekdays[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepali Date Timeline'),
      ),
      body: Column(
        children: [
          EasyDateTimeLine(
            initialDate: _selectedDate,
            disabledDates: const [], // Add disabled dates if needed
            onDateChange: (newDate) {
              setState(() {
                _selectedDate = newDate;
              });
            },
            dayProps: const EasyDayProps(
              height: 70,
              width: 70,
              activeDayNumStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              activeDayStrStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
              activeMothStrStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
            itemBuilder: (context, date, isSelected, onTap) {
              final nepaliDate = NepaliDateTime.fromDateTime(date);
              final nepaliWeekday = getNepaliWeekday(nepaliDate.weekday);
              return GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 70,
                  width: 70,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getNepaliMonth(nepaliDate.month), // Nepali month
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          locale: const Locale("ne_NP"),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        convertToNepaliNumber(nepaliDate.day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          locale: const Locale("ne_NP"),
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        nepaliWeekday, // Display Nepali weekday
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          locale: const Locale("ne_NP"),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Selected Date: ${NepaliDateTime.fromDateTime(_selectedDate)}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Returns the Nepali month name for a given month number
String getNepaliMonth(int month) {
  // List of Nepali month names
  List<String> nepaliMonths = [
    "बैशाख",
    "जेठ",
    "असार",
    "साउन",
    "भदौ",
    "असोज",
    "कात्तिक",
    "मंसिर",
    "पुष",
    "माघ",
    "फागुन",
    "चैत्र"
  ];

  // Ensure the month number is valid
  if (month < 1 || month > 12) {
    throw ArgumentError('Invalid month number: $month');
  }

  return nepaliMonths[month - 1];
}

int getDaysInMonth(int year, int month) {
  // Validate the input year and month
  if (year < 2000 || year > 2090) {
    throw ArgumentError('Year should be between 2000 and 2090.');
  }
  if (month < 1 || month > 12) {
    throw ArgumentError('Month should be between 1 and 12.');
  }

  // Get the first day of the next month
  NepaliDateTime firstDayOfNextMonth;
  if (month == 12) {
    // If it's December, next month will be January of the next year
    firstDayOfNextMonth = NepaliDateTime(year + 1, 1, 1);
  } else {
    // Otherwise, simply increment the month
    firstDayOfNextMonth = NepaliDateTime(year, month + 1, 1);
  }

  // Subtract one day to get the last day of the current month
  NepaliDateTime lastDayOfCurrentMonth =
      firstDayOfNextMonth.subtract(const Duration(days: 1));

  // Return the day of the last day, which represents the total days in the month
  return lastDayOfCurrentMonth.day;
}
