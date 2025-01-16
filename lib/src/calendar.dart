import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../flutter_bs_ad_calendar.dart';

typedef OnSelectedDate<T> = Function(T selectedDate, List<Event>? events);
typedef OnMonthChanged<T> = Function(T focusedDate, List<Event>? events);

class FlutterBSADCalendar<T> extends StatefulWidget {
  /// The [CalendarType] displayed in the calendar.
  final CalendarType calendarType;

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest date the user is permitted to pick [lastDate].
  final DateTime firstDate;

  /// The latest date the user is permitted to pick [firstDate].
  final DateTime lastDate;

  final bool? handledate;

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
  final double? calenderheight;

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

  /// Decoration for marker.
  final bool? markerbool;

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
    this.calenderheight,
    this.holidays,
    this.handledate,
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
    this.markerbool,
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
  late DateTime focusedDate;
  late int _currentMonthIndex;
  late DatePickerMode _displayType;

  late Map<int, List<int>> _nepaliMonthDays;

  @override
  void initState() {
    NepaliUtils(Language.nepali);
    super.initState();
    _displayType = DatePickerMode.day;
    _daysInMonth = [];
    _selectedDate = DateTime.now();
    focusedDate = widget.initialDate;
    _nepaliMonthDays = initializeDaysInMonths();
    _currentMonthIndex = widget.initialDate.month;

    _pageController = PageController(initialPage: _currentMonthIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.animateToPage(
        DateTime.now().month,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
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
    DateTime nepalitDate = date.toNepaliDateTime();
    log("kkm$nepalitDate");

    NepaliDateTime first =
        NepaliDateTime(nepalitDate.year, nepalitDate.month, 1);
    NepaliDateTime last = NepaliDateTime(nepalitDate.year, nepalitDate.month,
        _nepaliMonthDays[nepalitDate.year]![nepalitDate.month]);

    final daysBefore =
        (widget.mondayWeek ? first.weekday - 1 : first.weekday) % 7;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    var daysAfter = 7 - (widget.mondayWeek ? last.weekday - 1 : last.weekday);
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    final lastToDisplay = last.add(Duration(days: daysAfter));

    return Utils.daysInRange(
            firstToDisplay.toDateTime(), lastToDisplay.toDateTime())
        .toList();
  }

  // void _handleDisplayTypeChanged() {
  //   setState(() {
  //     _displayType = _displayType == DatePickerMode.day
  //         ? DatePickerMode.year
  //         : DatePickerMode.day;
  //   });
  // }

  void _handleMonthPageChanged(int monthPage) {
    if (monthPage > _currentMonthIndex) {
      int year =
          focusedDate.month == 12 ? focusedDate.year + 1 : focusedDate.year;
      int month = focusedDate.month == 12 ? 1 : focusedDate.month + 1;
      focusedDate = DateTime(year, month, focusedDate.day);
      log("elsefocusedDate$focusedDate");
      _currentMonthIndex = monthPage == 12 ? 0 : monthPage;
      log("elsefocusedDate$_currentMonthIndex");
    } else {
      int year =
          focusedDate.month == 1 ? focusedDate.year - 1 : focusedDate.year;
      int month = focusedDate.month == 1 ? 12 : focusedDate.month - 1;
      focusedDate = DateTime(year, month, focusedDate.day);
      log("elsefocusedDate$focusedDate");
      _currentMonthIndex = monthPage == 0 ? 12 : monthPage;
      log("elsefocusedDate$_currentMonthIndex");
    }
    _handleMonthChanged(focusedDate);
    setState(() {});
  }

  // on year changed
  // void _handleYearChanged(DateTime value) {
  //   if (value.isBefore(widget.firstDate)) {
  //     value = widget.firstDate;
  //   } else if (value.isAfter(widget.lastDate)) {
  //     value = widget.lastDate;
  //   }
  //   _displayType = DatePickerMode.day;
  //   focusedDate = value;
  //   _selectedDate = value;
  //   _handleMonthChanged(value);
  //   setState(() {});
  // }

  // on month changed
  void _handleMonthChanged(DateTime currentDate) {
    if (widget.handledate == true) {
      if (focusedDate.year != currentDate.year ||
          focusedDate.month != currentDate.month) {
        var date = widget.calendarType == CalendarType.ad
            ? currentDate
            : currentDate.toNepaliDateTime();
        List<Event>? monthsEvents = widget.events
            ?.where((item) => item.date?.month == currentDate.month)
            .toList();
        widget.onMonthChanged?.call(date, monthsEvents);
        setState(() {});
      } else {
        var date = currentDate;
        List<Event>? monthsEvents = widget.events
            ?.where((item) => item.date?.month == currentDate.month)
            .toList();
        widget.onMonthChanged?.call(date, monthsEvents);
        setState(() {});
      }
    } else {
      var date = currentDate;
      List<Event>? monthsEvents = widget.events
          ?.where((item) => item.date?.month == currentDate.month)
          .toList();
      widget.onDateSelected.call(date, monthsEvents);
      setState(() {});
    }
  }

  // on date selected
  void _handleDateSelected(DateTime currentDate) {
    if (widget.handledate == true) {
      var date = widget.calendarType == CalendarType.ad
          ? currentDate
          : currentDate.toNepaliDateTime();

      List<Event>? todaysEvents = widget.events
          ?.where((item) => item.date?.difference(currentDate).inDays == 0)
          .toList();
      _selectedDate = currentDate;
      widget.onDateSelected.call(
        date,
        todaysEvents,
      );
      setState(() {});
    } else {
      var date = currentDate;

      List<Event>? todaysEvents = widget.events
          ?.where((item) => item.date?.difference(currentDate).inDays == 0)
          .toList();
      _selectedDate = currentDate;
      widget.onDateSelected.call(
        date,
        todaysEvents,
      );
      setState(() {});
    }
  }

  // check if event exist in the selected date
  bool _checkEventOnDate(DateTime day) {
    if (widget.events != null) {
      for (Event event in widget.events!) {
        if (event.date?.difference(day).inDays == 0) {
          if (widget.calendarType == CalendarType.ad &&
              day.month == focusedDate.month) {
            return true;
          } else if (widget.calendarType == CalendarType.bs &&
              NepaliDateTime.fromDateTime(day).month ==
                  NepaliDateTime.fromDateTime(focusedDate).month) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // Widget _buildWeekRow(BuildContext context, int index) {}

  // Widget _buildYearPicker() {
  //   switch (widget.calendarType) {
  //     case CalendarType.ad:
  //       return YearPicker(
  //         currentDate: _selectedDate,
  //         firstDate: widget.firstDate,
  //         lastDate: widget.lastDate,
  //         initialDate: focusedDate,
  //         selectedDate: _selectedDate,
  //         onChanged: _handleYearChanged,
  //       );
  //     case CalendarType.bs:
  //       return NepaliYearPicker(
  //         currentDate: _selectedDate.toNepaliDateTime(),
  //         firstDate: widget.firstDate.toNepaliDateTime(),
  //         lastDate: widget.lastDate.toNepaliDateTime(),
  //         initialDate: focusedDate.toNepaliDateTime(),
  //         selectedDate: _selectedDate.toNepaliDateTime(),
  //         onChanged: (date) => _handleYearChanged(date.toDateTime()),
  //       );
  //   }
  // }

  Color? _getEventColor(DateTime date) {
    // Check if there are events on the specific date
    List<Event>? eventsForDay = widget.events?.where((event) {
      return event.date?.difference(date).inDays == 0;
    }).toList();

    if (eventsForDay != null && eventsForDay.isNotEmpty) {
      // Return the color for the first event or implement logic for multiple events
      return eventsForDay
          .first.color; // Assuming each Event has a color property
    }
    return null; // No events, no marker color
  }

  List<Color> _getEventColors(DateTime day) {
    List<Color> eventColors = [];
    if (widget.events != null) {
      for (var event in widget.events!) {
        if (day.isAfter(event.startDate!) && day.isBefore(event.endDate!)) {
          eventColors.add(event.color);
        }
      }
    }

    return eventColors;
  }

  @override
  Widget build(BuildContext context) {
    _daysInMonth = widget.calendarType == CalendarType.bs
        ? _nepaliDaysInMonth(focusedDate)
        : _englishDaysInMonth(focusedDate);

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
    return SizedBox(
      height: widget.calenderheight ?? 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MonthName(
                  headerheight: widget.headerheight,
                  date: focusedDate,
                  primaryColor: widget.primaryColor,
                  calendarType: widget.calendarType,
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
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta! > 0) {
                  // Handle swipe right
                  _handleMonthPageChanged(_currentMonthIndex + 1);
                } else if (details.primaryDelta! < 0) {
                  // Handle swipe left
                  _handleMonthPageChanged(_currentMonthIndex - 1);
                }
              },
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount:
                    DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1,
                onPageChanged: _handleMonthPageChanged,
                itemBuilder: (context, index) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _daysInMonth.length,
                    padding: EdgeInsets.zero,
                    gridDelegate: _daysInMonth.length == 35
                        ? SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: weeks.length, mainAxisExtent: 60)
                        : SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: weeks.length, mainAxisExtent: 50),
                    itemBuilder: (context, dayIndex) {
                      DateTime dayToBuild = _daysInMonth[dayIndex];
                      Color? mainDayColor;
                      Color? secondaryDayColor =
                          Theme.of(context).textTheme.bodyMedium?.color;
                      BoxDecoration decoration = const BoxDecoration();

                      if (Utils.isSameDay(dayToBuild, _selectedDate) &&
                          Utils.isSameMonth(
                              widget.calendarType, focusedDate, dayToBuild)) {
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
                          widget.calendarType, focusedDate, dayToBuild)) {
                        mainDayColor = Colors.grey.withOpacity(0.5);
                        secondaryDayColor = Colors.grey.withOpacity(0.5);
                      } else if (Utils.isWeekend(dayToBuild,
                          weekendDays: widget.weekendDays)) {
                        mainDayColor = widget.holidayColor ??
                            Theme.of(context).colorScheme.secondary;
                      } else if (Utils.holidays(dayToBuild, widget.holidays)) {
                        mainDayColor = widget.holidayColor ??
                            Theme.of(context).colorScheme.secondary;
                      } else {
                        mainDayColor =
                            Theme.of(context).textTheme.bodyMedium?.color;
                      }
                      final eventMarkerColor = _getEventColor(dayToBuild);
                      final eventColors = _getEventColors(dayToBuild);
                      final limitedEventColors = eventColors.take(4).toList();

                      return GestureDetector(
                        onTap: () {
                          if (Utils.isSameMonth(
                              widget.calendarType, focusedDate, dayToBuild)) {
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
                              if (eventMarkerColor != null)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Visibility(
                                    visible: _checkEventOnDate(dayToBuild),
                                    child: widget.markerbool == true
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                bottom: 10.0 + (index * 6)),
                                            child: Container(
                                              width: 5.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                color: widget.eventColor ??
                                                    eventMarkerColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1000.0),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 50.0,
                                            height: 55.0,
                                            decoration: BoxDecoration(
                                              color: widget.eventColor ??
                                                  eventMarkerColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                  ),
                                ),
                              // Display multiple event markers if events exist
                              if (eventColors.isNotEmpty)
                                ...limitedEventColors
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  Color markerColor = entry.value;

                                  return Align(
                                    alignment: Alignment.bottomLeft,
                                    child: widget.markerbool == true
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0,
                                                bottom: 10.0 + (index * 6)),
                                            child: Container(
                                              width: 5.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                color: widget.eventColor ??
                                                    markerColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        1000.0),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 50.0,
                                            height: 55.0,
                                            decoration: BoxDecoration(
                                              color: widget.eventColor ??
                                                  markerColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
