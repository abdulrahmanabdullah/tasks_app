import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/task_database.dart';
import 'ui/home_page.dart';

main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    return MultiProvider(
      providers: [
        Provider(builder: (_) => db.taskDao,),
        Provider(builder: (_) => db.tagDao)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
