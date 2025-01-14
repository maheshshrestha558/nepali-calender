import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  late List<Event> _events;
  DateTime? selectedDate;
  List<Event>? selectedDateEvents;

  @override
  void initState() {
    super.initState();

    _events = _getEvents();
  }

  List<Event> _getEvents() {
    return [
      Event(
        startDate: DateTime(2024, 12, 15),
        endDate: DateTime(2024, 12, 22),
        event: 'Public Holiday',
        color: Colors.red.withOpacity(0.1),
      ),
      Event(
        startDate: DateTime(2024, 12, 18),
        endDate: DateTime(2024, 12, 30),
        event: 'Special Event',
        color: Colors.orange.withOpacity(0.3),
      ),
      // Add more events here
    ];
  }

  List<Event> _filterEventsByMonthDay(DateTime date) {
    // Matches events based on month and day
    return _events.where((event) {
      return event.startDate!.month == date.month &&
          event.startDate!.day == date.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar with Events'),
      ),
      body: Column(
        children: [
          FlutterBSADCalendar(
            calendarType: CalendarType.ad,
            initialDate: DateTime.now(),
            firstDate: DateTime(1970),
            lastDate: DateTime(2100),
            handledate: true,
            nepalienglishtype: true,
            weekendDays: const [
              DateTime.saturday,
            ],
            markerbool: false,
            events: _events,
            onMonthChanged: (date, events) {
              setState(() {
                selectedDate = date;
                selectedDateEvents = _filterEventsByMonthDay(date);
                log("$selectedDateEvents");
              });
            },
            onDateSelected: (date, events) {
              setState(() {
                selectedDate = date;
                selectedDateEvents = _filterEventsByMonthDay(date);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
                itemCount:
                    selectedDateEvents != null ? selectedDateEvents!.length : 0,
                itemBuilder: (context, index) {
                  var data = selectedDateEvents![index];
                  return ListTile(
                    title: Text("${data.event}"),
                  );
                }),
          )
        ],
      ),
    );
  }
}
