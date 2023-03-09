import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RankingCard extends StatelessWidget {
  final String labelText;
  final int ranking;

  const RankingCard({
    required this.labelText,
    required this.ranking,
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(labelText),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                  child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: NumberFormat('#,##0').format(ranking),
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' 位',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TsunagiGothic',
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
