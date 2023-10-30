import 'package:flutter/material.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:intl/intl.dart';

class AverageRatingPage extends StatelessWidget {
  final List<DayEntry> entries;

  const AverageRatingPage({super.key, required this.entries});

  Map<int, double> _calculateAverageRatings(List<DayEntry> entries) {
    Map<int, List<double>> ratingsByMonth = {};
    for (var entry in entries) {
      int month = entry.date.month;
      if (!ratingsByMonth.containsKey(month)) {
        ratingsByMonth[month] = [];
      }
      ratingsByMonth[month]!.add(entry.rating);
    }

    Map<int, double> averageRatings = {};
    ratingsByMonth.forEach((month, ratings) {
      double average = ratings.isNotEmpty
          ? ratings.reduce((a, b) => a + b) / ratings.length
          : 0;
      averageRatings[month] = average;
    });

    return averageRatings;
  }

  @override
  Widget build(BuildContext context) {
    Map<int, double> averageRatings = _calculateAverageRatings(entries);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Average Ratings for Each Month'),
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No entries have been made yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              children: averageRatings.keys.map((month) {
                return ListTile(
                  title: Text(
                      DateFormat('MMMM').format(DateTime(DateTime.now().year, month))),
                  subtitle: Text(
                      'Average Rating: ${averageRatings[month]!.toStringAsFixed(1)}'),
                );
              }).toList(),
            ),
    );
  }
}
