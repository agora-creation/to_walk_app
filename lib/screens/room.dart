import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_walk_app/models/steps.dart';
import 'package:to_walk_app/models/user_alk.dart';
import 'package:to_walk_app/providers/steps.dart';
import 'package:to_walk_app/providers/user.dart';
import 'package:to_walk_app/widgets/steps_text.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stepsProvider = Provider.of<StepsProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    UserAlkModel? alk = userProvider.alk;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stepsProvider.streamListNow(
                userId: userProvider.user?.id,
              ),
              builder: (context, snapshot) {
                int nowSteps = 0;
                if (snapshot.hasData) {
                  for (DocumentSnapshot<Map<String, dynamic>> doc
                      in snapshot.data!.docs) {
                    nowSteps += StepsModel.fromSnapshot(doc).stepsNum;
                  }
                }
                return StepsText(steps: nowSteps);
              },
            ),
            Container(),
            Column(
              children: [
                Text(
                  alk?.getRoomMessage() ?? '',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  alk?.getRoomMessage2() ?? '',
                  style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        alk?.getImage() ?? Container(),
      ],
    );
  }
}
