import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  late List<Event> event;
  DateTime? selectedDate;
  List<Event>? selectedDateEvents;
  DateTime focusDate = DateTime.now();
  List<Event> monthEvents = []; // Events filtered by the current month

  @override
  void initState() {
    super.initState();
    event = _getEvents();
    _filterEventsByMonth(focusDate); // Filter events for the current month
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

  void _filterEventsByMonth(DateTime date) {
    setState(() {
      monthEvents = event.where((event) {
        return event.startDate!.month == date.month &&
            event.startDate!.year == date.year;
      }).toList();
    });
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
            initialDate: DateTime.now().subtract(const Duration(days: 3)),
            firstDate: DateTime(1970),
            lastDate: DateTime(2100),
            handledate: true,
            calendarType: CalendarType.bs,
            weekendDays: const [
              DateTime.saturday,
            ],
            markerbool: false,
            events: event,
            onMonthChanged: (date, event) {
              // Update the filtered events when the month changes
              _filterEventsByMonth(date);
            },
            onDateSelected: (focusDate, events) {
              // setState(() {
              //   selectedDate = focusDate;
              //   selectedDateEvents = events;
              // });
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
