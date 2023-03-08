import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/models/steps.dart';
import 'package:to_walk_app/providers/steps.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/widgets/custom_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final stepsProvider = Provider.of<StepsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: stepsProvider.streamList(userId: userProvider.user?.id),
          builder: (context, snapshot) {
            List<StepsModel> stepsList = [];
            if (snapshot.hasData) {
              for (DocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.data!.docs) {
                stepsList.add(StepsModel.fromSnapshot(doc));
              }
            }
            return CustomCalendar(
              firstDay: userProvider.user?.createdAt ?? DateTime.now(),
              stepsList: stepsList,
            );
          },
        ),
      ],
    );
  }
}
