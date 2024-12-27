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

import '../../flutter_bs_ad_calendar.dart';

class DayBuilder extends StatelessWidget {
  const DayBuilder({
    Key? key,
    required this.dayToBuild,
    required this.calendarType,
    required this.dayColor,
    required this.secondaryDayColor,
  }) : super(key: key);

  final DateTime dayToBuild;
  final CalendarType calendarType;
  final Color? dayColor;
  final Color? secondaryDayColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: key,
      children: [
        Container(
          key: key,
          alignment: Alignment.center,
          child: Text(
            calendarType == CalendarType.bs
                ? NepaliDateFormat.d().format(dayToBuild.toNepaliDateTime())
                : '${dayToBuild.day}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: dayColor),
          ),
        ),
        Positioned(
          key: key,
          right: 5.0,
          bottom: 3.0,
          child: Text(
            key: key,
            calendarType == CalendarType.bs
                ? '${dayToBuild.day}'
                : NepaliDateFormat.d().format(dayToBuild.toNepaliDateTime()),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(fontSize: 8.0, color: dayColor),
          ),
        ),
      ],
    );
  }
}
