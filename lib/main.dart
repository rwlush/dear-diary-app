import 'package:flutter/material.dart';
import 'package:dear_diary_app/controller/diary_controller.dart';
import 'package:dear_diary_app/view/diary_entry_view.dart';
import 'package:dear_diary_app/view/diary_log_view.dart';
import 'package:dear_diary_app/model/diary_entry_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DayEntryAdapter());
  final controller = DiaryController();
  await controller.init();
  runApp(MyApp(controller: controller));
}

class MyApp extends StatelessWidget {
  final DiaryController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dear Diary App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DiaryLogView(controller: controller),
      routes: {
        '/diaryEntry': (context) => DiaryEntryView(controller: controller),
      },
    );
  }
}