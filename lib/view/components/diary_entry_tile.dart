import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';

class DiaryEntryTile extends StatelessWidget {
  final DayEntry entry;
  final VoidCallback onDelete;

  const DiaryEntryTile({super.key, required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMMd().format(entry.date);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: $formattedDate',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Description: ${entry.description}'),
            const SizedBox(height: 4),
            Row(
              children: List.generate(
                entry.rating.round(),
                (index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
