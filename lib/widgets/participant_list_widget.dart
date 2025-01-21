import 'package:flutter/material.dart';
import '../screens/home_screen.dart';  // Import for Winner class

class ParticipantListWidget extends StatelessWidget {
  final String title;
  final List<Winner> winners;

  const ParticipantListWidget({
    super.key,
    required this.title,
    required this.winners,
  });

  @override
  Widget build(BuildContext context) {
    // Create a reversed list of winners
    final reversedWinners = winners.reversed.toList();

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFE31837),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFE31837),
              thickness: 2,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...reversedWinners.map((winner) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF1DB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE31837),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            winner.prize,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE31837),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Color(0xFFFFD700),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                winner.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 