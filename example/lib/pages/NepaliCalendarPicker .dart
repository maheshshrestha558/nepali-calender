import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart'; // Make sure you have the correct package imported

class NepaliCalendarPicker extends StatefulWidget {
  const NepaliCalendarPicker({super.key});

  @override
  _NepaliCalendarPickerState createState() => _NepaliCalendarPickerState();
}

class _NepaliCalendarPickerState extends State<NepaliCalendarPicker> {
  final ValueNotifier<NepaliDateTime> _selectedDate =
      ValueNotifier<NepaliDateTime>(NepaliDateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepali Calendar Picker'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CalendarDatePicker(
              initialDate: NepaliDateTime.now(),
              firstDate: NepaliDateTime(2070, 1, 1),
              lastDate: NepaliDateTime(2090, 12, 31),
              onDateChanged: (date) {
                _selectedDate.value = date.toNepaliDateTime();
                print('Selected date: ${date.year}-${date.month}-${date.day}');
              },
            ),
            ValueListenableBuilder<NepaliDateTime>(
              valueListenable: _selectedDate,
              builder: (context, date, child) {
                return Text(
                  'Selected Date: ${date.year}-${date.month}-${date.day}',
                  style: const TextStyle(fontSize: 18),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
