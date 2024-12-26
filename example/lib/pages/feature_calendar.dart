import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';

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
          Expanded(
            child: FlutterBSADCalendar(
              context: context,
              headerheight: 50,
              calendarType: _calendarType,
              initialDate: DateTime.now(),
              firstDate: DateTime(1970),
              lastDate: DateTime(2100),
              mondayWeek: false,
              weekendDays: const [DateTime.saturday],
              holidays: _holidays,
              primaryColor: Colors.purple,
              weekColor: Colors.cyan,
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
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Date: ${selectedDate?.toString() ?? 'No date selected'}',
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
