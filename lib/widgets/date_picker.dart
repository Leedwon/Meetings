import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:meetings/utils/date_utils.dart';

class DatePickerWidget extends StatelessWidget {
  final DateTime _dateTime;
  final Function(DateTime) _onDateTimeChanged;

  DatePickerWidget(this._dateTime, this._onDateTimeChanged);

  @override
  Widget build(BuildContext context) {
    if (_dateTime == null) {
      return Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.calendar_today, color: Colors.blue),
          ),
          GestureDetector(
            onTap: () => _openDatePicker(context),
            child: Text(
              "pick date",
              style: TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.calendar_today, color: Colors.blue),
          Text(_dateTime.formatDateTime()),
          GestureDetector(
            onTap: () => _openDatePicker(context),
            child: Text(
              "change date",
              style: TextStyle(fontSize: 16.0, color: Colors.blue),
            ),
          )
        ],
      );
    }
  }

  void _openDatePicker(BuildContext context) {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(), onConfirm: (date) => _onDateTimeChanged(date));
  }
}
