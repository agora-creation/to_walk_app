import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_walk_app/providers/user.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('今までの歩いた記録'),
                const Divider(),
                TableCalendar(
                  firstDay: userProvider.user?.createdAt ?? DateTime.now(),
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
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF333333),
                            width: 0.5,
                          ),
                        ),
                        alignment: Alignment.topCenter,
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(
                            color: Color(0xFF333333),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
