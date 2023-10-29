import 'package:hive/hive.dart';

part 'diary_entry_model.g.dart';

@HiveType(typeId: 0)
class DayEntry {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String description;

  @HiveField(2)
  int rating;

  DayEntry({required this.date, required this.description, required this.rating});
}