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
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../../flutter_bs_ad_calendar.dart';

class MonthName extends StatelessWidget {
  MonthName({
    super.key,
    required this.date,
    required this.calendarType,
    required this.primaryColor,
    this.headerheight,
  });

  final DateTime date;
  final CalendarType calendarType;
  final Color? primaryColor;
  double? headerheight;

  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: primaryColor ?? Theme.of(context).primaryColor);

    TextStyle? subTitleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
        fontSize: 12.0, color: primaryColor ?? Theme.of(context).primaryColor);

    return SizedBox(
      height: headerheight ?? 40.0,
      child: calendarType == CalendarType.bs
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  NepaliDateFormat('MMMM yyyy').format(date.toNepaliDateTime()),
                  style: titleStyle,
                ),
                Text(
                  '${DateFormat.MMMM().format(date)}/${DateFormat.MMMM().format(date.add(const Duration(days: 32)))}',
                  style: subTitleStyle,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(date),
                  style: titleStyle,
                ),
                Text(
                  '${NepaliDateFormat.MMMM().format(date.toNepaliDateTime())}/${NepaliDateFormat.MMMM().format(date.add(const Duration(days: 32)).toNepaliDateTime())}',
                  style: subTitleStyle,
                ),
              ],
            ),
    );
  }
}
