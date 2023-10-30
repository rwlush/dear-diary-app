import 'package:dear_diary_app/view/components/error_toast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';

class DiaryController {
  late Box<DayEntry> _diaryBox;

  Future<void> init() async {
    //Added encryption
    var encryptionKey = Hive.generateSecureKey();
    _diaryBox = await Hive.openBox<DayEntry>('diary', encryptionCipher: HiveAesCipher(encryptionKey));
  }

  Future<void> addEntry(DayEntry entry) async {
    List<DayEntry> entries = _diaryBox.values.toList();
    if (entries.any((element) =>
        element.date.year == entry.date.year &&
        element.date.month == entry.date.month &&
        element.date.day == entry.date.day)) {
      ErrorToast.show('An entry for the current date already exists!');
    }
    else {
      await _diaryBox.add(entry);
    }
  }

  Future<void> removeEntry(DateTime date) async {
    final index =
        _diaryBox.values.toList().indexWhere((element) => element.date == date);
    if (index != -1) {
      await _diaryBox.deleteAt(index);
    } else {
      ErrorToast.show('Entry not found!');
    }
  }

  List<DayEntry> getAllEntries() {
    return _diaryBox.values.toList();
  }

  List<DayEntry> filterEntriesByMonth(int month) {
    return _diaryBox.values
        .where((entry) => entry.date.month == month)
        .toList();
  }

  Future<void> closeBox() async {
    await _diaryBox.close();
  }
}
