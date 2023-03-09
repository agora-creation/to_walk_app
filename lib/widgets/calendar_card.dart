import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_walk_app/helpers/functions.dart';
import 'package:to_walk_app/models/steps.dart';

class CalendarCard extends StatelessWidget {
  final DateTime firstDay;
  final List<StepsModel> stepsList;

  const CalendarCard({
    required this.firstDay,
    required this.stepsList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('今までの歩いた記録'),
            ),
            const Divider(),
            TableCalendar(
              firstDay: firstDay,
              lastDay: DateTime.now(),
              focusedDay: DateTime.now(),
              locale: 'ja',
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  Map stepsNum = {};
                  String dayKey = dateText('yyyy-MM-dd', day);
                  stepsNum[dayKey] = 0;
                  for (StepsModel steps in stepsList) {
                    String stepsKey = dateText('yyyy-MM-dd', steps.createdAt);
                    stepsNum[stepsKey] += steps.stepsNum;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(day.day.toString()),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          NumberFormat('#,##0').format(stepsNum[dayKey]),
                          style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                disabledBuilder: (context, day, focusedDay) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.day.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Container(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
