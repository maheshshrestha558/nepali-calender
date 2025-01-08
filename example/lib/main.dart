import 'package:calendar_example/pages/dynamic_calendar.dart';
import 'package:calendar_example/pages/nepalieasydate.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bs_ad_calendar/flutter_bs_ad_calendar.dart';

import 'pages/basic_calendar.dart';
import 'pages/event_calendar.dart';
import 'pages/feature_calendar.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp(),
    ),

    // const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Nepali Calendar',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.lightBlue,
          secondary: Colors.red,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Nepali Calendar'),
    );
  }
}

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title,
  });

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            ElevatedButton(
              child: const Text('Basics Calendar'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BasicCalendar()),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: const Text('Dynamic Calendar'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DynamicCalendar()),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: const Text('Calendar with Features'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeatureCalendar()),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: const Text('Calendar with Event'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventCalendar()),
              ),
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: const Text('Nepali Calendar Dialog'),
              onPressed: () async {
                DateTime? date = await showFlutterBSADCalendarDialog(
                  context: context,
                );
              },
            ),
            const SizedBox(height: 15.0),
            ElevatedButton(
              child: const Text('English Calendar Dialog'),
              onPressed: () async {
                DateTime? date = await showFlutterBSADCalendarDialog(
                  context: context,
                  calendarType: CalendarType.ad,
                );
              },
            ),
            ElevatedButton(
              child: const Text('NepaliDateTimeLineExample'),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const NepaliDateTimeLineExample()));
              },
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
