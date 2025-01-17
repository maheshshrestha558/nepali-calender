// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';
import 'package:nepali_utils/nepali_utils.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  late List<Event> _events;
  DateTime? selectedDate;
  List<Event>? selectedDateEvents;
  DateTime focusDate = DateTime.now();
  List<Event> monthEvents = []; // Events filtered by the current Nepali month

  @override
  void initState() {
    super.initState();
    _events = _getEvents();
    _filterEventsByNepaliMonth(
        focusDate); // Filter events for the current Nepali month
  }

  List<Event> _getEvents() {
    return [
      Event(
        startDate: DateTime(2025, 2, 1),
        endDate: DateTime(2025, 2, 10),
        event: 'Public Holiday',
        color: Colors.red.withOpacity(0.1),
      ),
      Event(
        startDate: DateTime(2025, 2, 10),
        endDate: DateTime(2025, 2, 18),
        event: 'Special Event',
        color: Colors.orange.withOpacity(0.3),
      ),
      Event(
        startDate: DateTime(2025, 1, 10),
        endDate: DateTime(2025, 1, 18),
        event: 'Special Event',
        color: Colors.blueAccent.withOpacity(0.3),
      ),
      // Add more events here
    ];
  }

  void _filterEventsByNepaliMonth(DateTime date) {
    setState(() {
      // Convert Gregorian date to Nepali date
      NepaliDateTime nepaliDate = NepaliDateTime.fromDateTime(date);
      int nepaliMonth = nepaliDate.month;

      // Filter events based on Nepali month
      monthEvents = _events.where((event) {
        NepaliDateTime eventStartNepali =
            NepaliDateTime.fromDateTime(event.startDate!);
        NepaliDateTime eventEndNepali =
            NepaliDateTime.fromDateTime(event.endDate!);

        // Check if the event falls within the Nepali month
        return eventStartNepali.month == nepaliMonth ||
            eventEndNepali.month == nepaliMonth;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepali Calendar with Events'),
      ),
      body: Column(
        children: [
          FlutterBSADCalendar(
            initialDate: DateTime.now(),
            firstDate: DateTime(1970),
            lastDate: DateTime(2100),
            handledate: true,
            calendarType: CalendarType.bs,
            weekendDays: const [
              DateTime.saturday,
            ],
            markerbool: false,
            events: _events,
            onMonthChanged: (focusDate, events) {
              // Update the filtered events when the month changes
              _filterEventsByNepaliMonth(focusDate);
            },
            onDateSelected: (focusDate, events) {
              setState(() {
                selectedDate = focusDate;
                selectedDateEvents = events;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: monthEvents.length,
              itemBuilder: (context, index) {
                var event = monthEvents[index];
                return ListTile(
                  title: Text(event.event ?? "No Event"),
                  subtitle: Text(
                    "${event.startDate!.toLocal()} - ${event.endDate!.toLocal()}",
                  ),
                  leading: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: event.color,
                      shape: BoxShape.circle,
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
