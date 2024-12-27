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

class NepaliYearPicker extends StatefulWidget {
  NepaliYearPicker({
    Key? key,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.selectedDate,
    required this.onChanged,
  })  : assert(!firstDate.isAfter(lastDate)),
        super(key: key);

  /// This date is subtly highlighted in the picker.
  final NepaliDateTime currentDate;

  /// The earliest date the user is permitted to pick.
  final NepaliDateTime firstDate;

  /// The latest date the user is permitted to pick.
  final NepaliDateTime lastDate;

  /// The initial date to center the year display around.
  final NepaliDateTime initialDate;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final NepaliDateTime selectedDate;

  /// Called when the user picks a year.
  final ValueChanged<NepaliDateTime> onChanged;

  @override
  State<NepaliYearPicker> createState() => _NepaliYearPickerState();
}

class _NepaliYearPickerState extends State<NepaliYearPicker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        initialScrollOffset: _scrollOffsetForYear(widget.selectedDate));
  }

  double _scrollOffsetForYear(DateTime date) {
    final int initialYearIndex = date.year - widget.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ 3;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    return _itemCount < 18 ? 0 : centeredYearRow * 52.0;
  }

  int get _itemCount {
    return widget.lastDate.year - widget.firstDate.year + 1;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    double itemWidth = MediaQuery.of(context).size.width * 0.3;
    double itemHeight = 50;

    return Column(
      children: <Widget>[
        const Divider(),
        Expanded(
          key: widget.key,
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemCount: _itemCount,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemBuilder: (_, index) {
              final int offset = _itemCount < 18 ? (18 - _itemCount) ~/ 2 : 0;
              final int year = widget.firstDate.year + index - offset;
              final bool isSelected = year == widget.selectedDate.year;
              final bool isCurrentYear = year == widget.currentDate.year;
              final bool isDisabled =
                  year < widget.firstDate.year || year > widget.lastDate.year;
              final Color textColor;
              BoxDecoration? decoration;

              if (isSelected) {
                textColor = colorScheme.onPrimary;
              } else if (isDisabled) {
                textColor = colorScheme.onSurface.withOpacity(0.38);
              } else if (isCurrentYear) {
                textColor = colorScheme.primary;
              } else {
                textColor = colorScheme.onSurface.withOpacity(0.87);
              }

              if (isSelected) {
                decoration = BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(18),
                );
              } else if (isCurrentYear && !isDisabled) {
                decoration = BoxDecoration(
                  border: Border.all(
                    color: colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(18),
                );
              }

              return InkWell(
                onTap: () => widget.onChanged(NepaliDateTime(
                    year, widget.initialDate.month, widget.initialDate.day)),
                child: Center(
                  child: Container(
                    decoration: decoration,
                    height: 36.0,
                    width: 72.0,
                    child: Center(
                      child: Semantics(
                        selected: isSelected,
                        button: true,
                        child: Text(
                          year.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.apply(color: textColor),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
