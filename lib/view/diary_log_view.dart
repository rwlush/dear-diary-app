// ignore_for_file: library_private_types_in_public_api

import 'package:dear_diary_app/view/average_rating_page.dart';
import 'package:flutter/material.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:dear_diary_app/view/diary_entry_view.dart';
import 'package:intl/intl.dart';
import 'components/diary_entry_tile.dart';

class DiaryLogView extends StatefulWidget {
  final DiaryController controller;

  const DiaryLogView({super.key, required this.controller});

  @override
  _DiaryLogViewState createState() => _DiaryLogViewState();
}

class _DiaryLogViewState extends State<DiaryLogView> {
  late List<DayEntry> _entries = [];
  late final List<int> _months = List.generate(12, (index) => index + 1);
  late int _selectedMonth = -1;
  late bool _isFiltering = false;

  @override
  void initState() {
    super.initState();
    _updateEntries();
  }

  String _getMonthName(int year, int month) {
    return DateFormat('MMMM').format(DateTime(year, month));
  }

  Future<void> _updateEntries() async {
    await widget.controller.init();
    List<DayEntry> entries = widget.controller.getAllEntries();
    setState(() {
      _entries = entries;
    });
  }

  List<DayEntry> _filterEntriesByMonth(
      List<DayEntry> entries, int month, int year) {
    return entries
        .where((entry) => entry.date.month == month && entry.date.year == year)
        .toList();
  }

  List<DayEntry> _getEntriesToShow() {
    int currentYear = DateTime.now().year;
    if (_isFiltering) {
      return _filterEntriesByMonth(_entries, _selectedMonth, currentYear);
    } else {
      return _entries;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DayEntry> entriesToShow = _getEntriesToShow();

    List<DayEntry> reversedEntries = List.from(entriesToShow.reversed);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Log'),
      ),
      body: Column(children: [
        DropdownButton<int>(
          value: _selectedMonth != -1 ? _selectedMonth : null,
          hint: const Text('Select a month to filter entries by'),
          items: [
            const DropdownMenuItem<int>(
              value: -1,
              child: Text('No Filter'),
            ),
            ..._months.map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(DateFormat('MMMM').format(DateTime(2023, value))),
              );
            }).toList(),
          ],
          onChanged: (int? newValue) {
            setState(() {
              if (newValue == -1) {
                _isFiltering = false;
                _selectedMonth = -1;
              } else {
                _isFiltering = true;
                _selectedMonth = newValue!;
              }
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AverageRatingPage(entries: _entries),
              ),
            );
          },
          child: const Text('View Average Ratings'),
        ),
        Expanded(
          child: entriesToShow.isEmpty
              ? Center(
                  child: Text(
                    _isFiltering
                        ? 'No entries found for selected month.'
                        : 'Diary is empty.',
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: reversedEntries.length,
                  itemBuilder: (context, index) {
                    DayEntry entry = reversedEntries[index];
                    final previousEntry =
                        index == 0 ? null : reversedEntries[index - 1];
                    final currentDate =
                        DateFormat('yyyy-MM').format(entry.date);
                    final previousDate = previousEntry == null
                        ? null
                        : DateFormat('yyyy-MM').format(previousEntry.date);
                    final shouldDisplayDate = previousDate != currentDate;

                    return Column(
                      children: [
                        if (shouldDisplayDate)
                          ListTile(
                            title: Text(
                              getMonthName(entry.date),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        DiaryEntryTile(
                          entry: entry,
                          onDelete: () {
                            setState(() {
                              widget.controller.removeEntry(entry.date);
                              _updateEntries();
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DiaryEntryView(controller: widget.controller),
            ),
          );
          _updateEntries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String getMonthName(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }
}
