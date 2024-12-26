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
  DateTime? _selectedDate;
  List<Event>? _selectedDateEvents;

  @override
  void initState() {
    super.initState();

    _calendarType = CalendarType.bs;
    _events = _getEvents();
  }

  List<Event> _getEvents() {
    return [
      Event(
        date: DateTime(2023, 04, 14),
        event: Content(title: 'Event'),
      ),
      Event(
        date: DateTime(2023, 04, 16),
        event: Content(title: 'Event 01'),
      ),
      Event(
        date: DateTime(2023, 05, 01),
        event: Content(title: 'Event 02'),
      ),
      Event(
        date: DateTime(2023, 05, 14),
        event: Content(title: 'Event 03'),
      ),
      Event(
        date: DateTime(2023, 05, 26),
        event: Content(title: 'Event 04'),
      ),
      Event(
        date: DateTime(2023, 05, 29),
        event: Content(title: 'Event 05'),
      ),
      Event(
        date: DateTime(2023, 07, 21),
        event: Content(title: 'Event 06'),
      ),
      Event(
        date: DateTime(2023, 08, 22),
        event: Content(title: 'Event 07'),
      ),
      Event(
        date: DateTime(2023, 08, 23),
        event: Content(title: 'Event 08'),
      ),
      Event(
        date: DateTime(2023, 08, 30),
        event: Content(title: 'Event 09'),
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
        eventColor: Colors.purpleAccent,
        weekendDays: const [
          DateTime.saturday,
        ],
        events: _events,
        onMonthChanged: (date, events) {
          setState(() {
            _selectedDate = date;
            _selectedDateEvents = events;
          });
        },
        onDateSelected: (date, events) {
          setState(() {
            _selectedDate = date;
            _selectedDateEvents = events;
          });
        },
      ),
    );
  }
}
