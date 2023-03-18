import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/models/steps.dart';
import 'package:to_walk_app/providers/steps.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/widgets/calendar_card.dart';
import 'package:to_walk_app/widgets/ranking_card.dart';

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

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: stepsProvider.streamList(
              userId: userProvider.user?.id,
            ),
            builder: (context, snapshot) {
              List<StepsModel> stepsList = [];
              if (snapshot.hasData) {
                for (DocumentSnapshot<Map<String, dynamic>> doc
                    in snapshot.data!.docs) {
                  stepsList.add(StepsModel.fromSnapshot(doc));
                }
              }
              return CalendarCard(
                firstDay: userProvider.user?.createdAt ?? DateTime.now(),
                stepsList: stepsList,
              );
            },
          ),
          const SizedBox(height: 8),
          FutureBuilder<int>(
            future: stepsProvider.getDayRanking(
              userId: userProvider.user?.id,
            ),
            builder: (context, snapshot) {
              return RankingCard(
                labelText: '今日の総歩数ランキング',
                ranking: snapshot.data ?? 0,
              );
            },
          ),
          const SizedBox(height: 8),
          FutureBuilder<int>(
            future: stepsProvider.getMonthRanking(
              userId: userProvider.user?.id,
            ),
            builder: (context, snapshot) {
              return RankingCard(
                labelText: '今月の総歩数ランキング',
                ranking: snapshot.data ?? 0,
              );
            },
          ),
        ],
      ),
    );
  }
}
