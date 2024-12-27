/*
 * Copyright (c) 2023 Biwesh Shrestha
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../flutter_bs_ad_calendar.dart';

typedef OnSelectedDate<T> = Function(T selectedDate, List<Event>? events);
typedef OnMonthChanged<T> = Function(T selectedDate, List<Event>? events);

class FlutterBSADCalendar<T> extends StatefulWidget {
  /// The [CalendarType] displayed in the calendar.
  final CalendarType calendarType;

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest date the user is permitted to pick [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick [firstDate].
  final DateTime lastDate;

  /// The List of holiday dates.
  final List<DateTime>? holidays;

  /// List of events assigned to a specified day.
  final List<Event>? events;

  /// Weather Start of the week is [Sunday] or [Monday].
  final bool mondayWeek;
  final BuildContext? context;

  /// List of days in week to be considered as weekend.
  /// Use built-in [DateTime] weekday constants (e.g '1' is for 'DateTime.monday')
  final List<int> weekendDays;

  /// Primary calendar theme color
  final Color? primaryColor;

  /// Week name color
  final Color? weekColor;

  /// Holiday calendar theme color
  final Color? holidayColor;

  /// Event calendar theme color
  final Color? eventColor;

  /// Decoration for today's cell.
  final BoxDecoration? todayDecoration;

  /// Decoration for selected day's cell.
  final BoxDecoration? selectedDayDecoration;

  /// Builds the widget for particular day.
  final Widget Function(DateTime)? dayBuilder;

  /// Called when the user picks a day.
  final OnSelectedDate onDateSelected;
  final double? headerheight;

  /// Called when the user changes month.
  final OnMonthChanged? onMonthChanged;
  const FlutterBSADCalendar({
    Key? key,
    this.context,
    this.calendarType = CalendarType.bs,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.holidays,
    this.mondayWeek = false,
    this.weekendDays = const [DateTime.saturday],
    this.events,
    this.primaryColor,
    this.weekColor,
    this.holidayColor,
    this.eventColor,
    this.todayDecoration,
    this.selectedDayDecoration,
    this.dayBuilder,
    this.headerheight,
    required this.onDateSelected,
    this.onMonthChanged,
  }) : super(key: key);

  @override
  State<FlutterBSADCalendar<T>> createState() => _FlutterBSADCalendarState<T>();
}

class _FlutterBSADCalendarState<T> extends State<FlutterBSADCalendar<T>> {
  late PageController _pageController;
  late List<DateTime> _daysInMonth;
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  late int _currentMonthIndex;
  late DatePickerMode _displayType;

  late Map<int, List<int>> _nepaliMonthDays;

  @override
  void initState() {
    super.initState();

    NepaliUtils(Language.nepali);
    _displayType = DatePickerMode.day;
    _daysInMonth = [];
    _selectedDate = DateTime.now();
    _focusedDate = widget.initialDate;
    _nepaliMonthDays = initializeDaysInMonths();
    _currentMonthIndex = widget.initialDate.month - 1;
    _pageController = PageController(initialPage: _currentMonthIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      const Duration monthScrollDuration = Duration(milliseconds: 100);
      _pageController.animateToPage(
        DateTime.now().month - 1,
        duration: monthScrollDuration,
        curve: Curves.easeInOut,
      );
    });
  }

  /// Get the days in the month in english calendar
  List<DateTime> _englishDaysInMonth(DateTime date) {
    final first = Utils.firstDayOfMonth(date);
    final daysBefore =
        (widget.mondayWeek ? first.weekday - 1 : first.weekday) % 7;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = Utils.lastDayOfMonth(date);
    var daysAfter = 7 - (widget.mondayWeek ? last.weekday - 1 : last.weekday);
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    final lastToDisplay = last.add(Duration(days: daysAfter));
    return Utils.daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  /// Get the days in the month in nepali calendar
  List<DateTime> _nepaliDaysInMonth(DateTime date) {
    NepaliDateTime nepalitDate = date.toNepaliDateTime();
    DateTime first =
        NepaliDateTime(nepalitDate.year, nepalitDate.month, 1).toDateTime();
    DateTime last = NepaliDateTime(nepalitDate.year, nepalitDate.month,
            _nepaliMonthDays[nepalitDate.year]![nepalitDate.month])
        .toDateTime();
    final daysBefore =
        (widget.mondayWeek ? first.weekday - 1 : first.weekday) % 7;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    var daysAfter = 7 - (widget.mondayWeek ? last.weekday - 1 : last.weekday);
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    final lastToDisplay = last.add(Duration(days: daysAfter));
    return Utils.daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  void _handleDisplayTypeChanged() {
    setState(() {
      _displayType = _displayType == DatePickerMode.day
          ? DatePickerMode.year
          : DatePickerMode.day;
    });
  }

  // callend on page changed
  void _handleMonthPageChanged(int monthPage) {
    if (monthPage > _currentMonthIndex) {
      int year =
          _focusedDate.month == 12 ? _focusedDate.year + 1 : _focusedDate.year;
      int month = _focusedDate.month == 12 ? 1 : _focusedDate.month + 1;
      _focusedDate = DateTime(year, month, _focusedDate.day);
      _currentMonthIndex = monthPage == 12 ? 0 : monthPage;
    } else {
      int year =
          _focusedDate.month == 1 ? _focusedDate.year - 1 : _focusedDate.year;
      int month = _focusedDate.month == 1 ? 12 : _focusedDate.month - 1;
      _focusedDate = DateTime(year, month, _focusedDate.day);
      _currentMonthIndex = monthPage == 0 ? 12 : monthPage;
    }
    _handleMonthChanged(_focusedDate);
    setState(() {});
  }

  // on year changed
  void _handleYearChanged(DateTime value) {
    if (value.isBefore(widget.firstDate)) {
      value = widget.firstDate;
    } else if (value.isAfter(widget.lastDate)) {
      value = widget.lastDate;
    }
    _displayType = DatePickerMode.day;
    _focusedDate = value;
    _selectedDate = value;
    _handleMonthChanged(value);
    setState(() {});
  }

  // on month changed
  void _handleMonthChanged(DateTime currentDate) {
    if (_focusedDate.year != currentDate.year ||
        _focusedDate.month != currentDate.month) {
      var date = widget.calendarType == CalendarType.ad
          ? currentDate
          : currentDate.toNepaliDateTime();
      List<Event>? monthsEvents = widget.events
          ?.where((item) => item.date?.month == currentDate.month)
          .toList();
      widget.onMonthChanged?.call(date, monthsEvents);
    }
  }

  // on date selected
  void _handleDateSelected(DateTime currentDate) {
    var date = widget.calendarType == CalendarType.ad
        ? currentDate
        : currentDate.toNepaliDateTime();

    List<Event>? todaysEvents = widget.events
        ?.where((item) => item.date?.difference(currentDate).inDays == 0)
        .toList();
    _selectedDate = currentDate;
    widget.onDateSelected.call(date, todaysEvents);
    setState(() {});
  }

  // check if event exist in the selected date
  bool _checkEventOnDate(DateTime day) {
    if (widget.events != null) {
      for (Event event in widget.events!) {
        if (event.date?.difference(day).inDays == 0) {
          if (widget.calendarType == CalendarType.ad &&
              day.month == _focusedDate.month) {
            return true;
          } else if (widget.calendarType == CalendarType.bs &&
              day.toNepaliDateTime().month ==
                  _focusedDate.toNepaliDateTime().month) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Widget _buildWeekRow(BuildContext context, int index) {}

  Widget _buildYearPicker() {
    switch (widget.calendarType) {
      case CalendarType.ad:
        return YearPicker(
          key: widget.key,
          currentDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          initialDate: _focusedDate,
          selectedDate: _selectedDate,
          onChanged: _handleYearChanged,
        );
      case CalendarType.bs:
        return NepaliYearPicker(
          currentDate: _selectedDate.toNepaliDateTime(),
          firstDate: widget.firstDate.toNepaliDateTime(),
          lastDate: widget.lastDate.toNepaliDateTime(),
          initialDate: _focusedDate.toNepaliDateTime(),
          selectedDate: _selectedDate.toNepaliDateTime(),
          onChanged: (date) => _handleYearChanged(date.toDateTime()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    _daysInMonth = widget.calendarType == CalendarType.bs
        ? _nepaliDaysInMonth(_focusedDate)
        : _englishDaysInMonth(_focusedDate);

    List weeks = [];
    if (widget.mondayWeek) {
      weeks = widget.calendarType == CalendarType.bs
          ? Utils.nepaliMondayWeek
          : Utils.englishMondayWeek;
    } else {
      weeks = widget.calendarType == CalendarType.bs
          ? Utils.nepaliWeek
          : Utils.englishWeek;
    }
    return Expanded(
      key: widget.key,
      child: Column(
        key: widget.key,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _handleDisplayTypeChanged,
                  child: MonthName(
                    headerheight: widget.headerheight,
                    date: _focusedDate,
                    primaryColor: widget.primaryColor,
                    calendarType: widget.calendarType,
                  ),
                ),
                Visibility(
                  visible: _displayType == DatePickerMode.day,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          size: 30.0,
                          color: widget.primaryColor ??
                              Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Utils.isDisplayingFirstMonth(
                                widget.firstDate, _selectedDate)
                            ? null
                            : _handleMonthPageChanged(_currentMonthIndex - 1),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          size: 30.0,
                          color: widget.primaryColor ??
                              Theme.of(context).primaryColor,
                        ),
                        onPressed: () => Utils.isDisplayingLastMonth(
                                widget.lastDate, _selectedDate)
                            ? null
                            : _handleMonthPageChanged(_currentMonthIndex + 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          if (_displayType == DatePickerMode.day)
            Table(
              children: <TableRow>[
                TableRow(
                  children: weeks
                      .map(
                        (day) => Center(
                          child: Text(
                            day,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: widget.weekColor ??
                                        Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.color),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          const SizedBox(height: 5.0),
          _displayType == DatePickerMode.day
              ? Expanded(
                  key: widget.key,
                  child: PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: DateUtils.monthDelta(
                            widget.firstDate, widget.lastDate) +
                        1,
                    onPageChanged: _handleMonthPageChanged,
                    itemBuilder: (context, index) {
                      return GridView.builder(
                        key: widget.key,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _daysInMonth.length,
                        padding: EdgeInsets.zero,
                        gridDelegate: _daysInMonth.length == 35
                            ? SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: weeks.length,
                                mainAxisExtent: 60)
                            : SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: weeks.length,
                                mainAxisExtent: 50),
                        itemBuilder: (context, dayIndex) {
                          DateTime dayToBuild = _daysInMonth[dayIndex];
                          Color? mainDayColor;
                          Color? secondaryDayColor =
                              Theme.of(context).textTheme.bodyMedium?.color;
                          BoxDecoration decoration = const BoxDecoration();

                          if (Utils.isSameDay(dayToBuild, _selectedDate) &&
                              Utils.isSameMonth(widget.calendarType,
                                  _focusedDate, dayToBuild)) {
                            mainDayColor = Colors.white;
                            decoration = widget.selectedDayDecoration ??
                                BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  shape: BoxShape.circle,
                                );
                          } else if (Utils.isToday(dayToBuild)) {
                            mainDayColor = Theme.of(context).primaryColorDark;
                            decoration = widget.todayDecoration ??
                                BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  shape: BoxShape.circle,
                                );
                          } else if (!Utils.isSameMonth(
                              widget.calendarType, _focusedDate, dayToBuild)) {
                            mainDayColor = Colors.grey.withOpacity(0.5);
                            secondaryDayColor = Colors.grey.withOpacity(0.5);
                          } else if (Utils.isWeekend(dayToBuild,
                              weekendDays: widget.weekendDays)) {
                            mainDayColor = widget.holidayColor ??
                                Theme.of(context).colorScheme.secondary;
                          } else if (Utils.holidays(
                              dayToBuild, widget.holidays)) {
                            mainDayColor = widget.holidayColor ??
                                Theme.of(context).colorScheme.secondary;
                          } else {
                            mainDayColor =
                                Theme.of(context).textTheme.bodyMedium?.color;
                          }

                          return GestureDetector(
                            onTap: () {
                              if (Utils.isSameMonth(widget.calendarType,
                                  _focusedDate, dayToBuild)) {
                                _handleDateSelected(dayToBuild);
                              }
                            },
                            child: Container(
                              decoration: decoration,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                                vertical: 2.0,
                              ),
                              child: Stack(
                                children: [
                                  widget.dayBuilder == null
                                      ? DayBuilder(
                                          dayToBuild: dayToBuild,
                                          calendarType: widget.calendarType,
                                          dayColor: mainDayColor,
                                          secondaryDayColor: secondaryDayColor,
                                        )
                                      : widget.dayBuilder!(dayToBuild),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Visibility(
                                      visible: _checkEventOnDate(dayToBuild),
                                      child: Container(
                                        width: 5.0,
                                        height: 5.0,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                          vertical: 10.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: widget.eventColor ??
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(1000.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : Expanded(
                  key: widget.key,
                  child: _buildYearPicker(),
                ),
        ],
      ),
    );
  }
}
