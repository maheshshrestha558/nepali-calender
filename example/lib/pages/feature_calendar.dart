import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';
import 'package:intl/intl.dart';

class FeatureCalendar extends StatefulWidget {
  const FeatureCalendar({Key? key}) : super(key: key);

  @override
  State<FeatureCalendar> createState() => _FeatureCalendarState();
}

class _FeatureCalendarState extends State<FeatureCalendar> {
  late CalendarType _calendarType;
  late List<DateTime> _holidays;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    _calendarType = CalendarType.bs;
    _holidays = [
      DateTime(2023, 04, 14),
      DateTime(2023, 05, 01),
      DateTime(2023, 05, 14),
      DateTime(2023, 05, 26),
      DateTime(2023, 05, 29),
      DateTime(2023, 07, 21),
      DateTime(2023, 08, 22),
      DateTime(2024, 08, 23),
      DateTime(2024, 12, 30),
      DateTime(2024, 12, 09),
      DateTime(2024, 12, 19),
      DateTime(2024, 12, 29),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar with Features'),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_calendarType == CalendarType.ad) {
                setState(() => _calendarType = CalendarType.bs);
              } else {
                setState(() => _calendarType = CalendarType.ad);
              }
            },
            child: Text(_calendarType == CalendarType.bs ? 'En' : 'ने'),
          ),
        ],
      ),
      body: Column(
        children: [
          FlutterBSADCalendar(
            key: widget.key,
            headerheight: 50,
            calendarType: _calendarType,
            initialDate: DateTime.now(),
            firstDate: DateTime(1970),
            lastDate: DateTime(2100),
            mondayWeek: false,
            weekendDays: const [DateTime.saturday],
            holidays: _holidays,
            primaryColor: Colors.black,
            weekColor: Colors.black,
            holidayColor: Colors.deepOrange,
            todayDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).primaryColorLight,
              shape: BoxShape.rectangle,
            ),
            selectedDayDecoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Theme.of(context).primaryColorDark,
              shape: BoxShape.rectangle,
            ),
            onMonthChanged: (date, events) {
              setState(() => selectedDate = date);
            },
            onDateSelected: (date, events) {
              setState(() => selectedDate = date);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffFDFDFD),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Card(
                          color: Colors.white,
                          shadowColor: const Color(0xffEBEBEB),
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  color: Color(0xFFEBEBEB),
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  DateFormat("MMMM").format(selectedDate!),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
