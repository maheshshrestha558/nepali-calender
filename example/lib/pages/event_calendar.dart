import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';

class Content {
  String? title;

  Content({
    this.title,
  });
}

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  late CalendarType _calendarType;
  late List<Event> _events;
  DateTime? selectedDate;
  List<Event>? selectedDateEvents;

  @override
  void initState() {
    super.initState();

    _calendarType = CalendarType.bs;
    _events = _getEvents();
  }

  List<Event> _getEvents() {
    return [
      Event(
        date: DateTime(2024, 12, 26),
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 26),
        event: 'Public Holiday',
        color: Colors.red,
      ),
      Event(
        date: DateTime(2024, 12, 26),
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 26),
        event: 'Special Event',
        color: Colors.orange,
      ),
      Event(
        date: DateTime(2024, 12, 26),
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 26),
        event: 'Summer Festival',
        color: Colors.purple,
      ),
      Event(
        date: DateTime(2024, 12, 26),
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 26),
        event: 'Summer Festival',
        color: Colors.purple,
      ),
      Event(
        date: DateTime(2024, 12, 26),
        startDate: DateTime(2024, 12, 20),
        endDate: DateTime(2024, 12, 26),
        event: 'Summer Festival',
        color: Colors.purple,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar with Events'),
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
      body: FlutterBSADCalendar(
        calendarType: _calendarType,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2100),
        mondayWeek: false, // true is for Monday, false is  for Sunday
        weekendDays: const [
          DateTime.saturday,
        ],
        events: _events,
        onMonthChanged: (date, events) {
          setState(() {
            selectedDate = date;
            selectedDateEvents = events;
          });
        },
        onDateSelected: (date, events) {
          setState(() {
            selectedDate = date;
            selectedDateEvents = events;
          });
        },
      ),
    );
  }
}
