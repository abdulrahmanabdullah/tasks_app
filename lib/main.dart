import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'data/task_database.dart';
import 'ui/home_page.dart';
import 'app_localizations.dart';

main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final db = AppDatabase();
    return MultiProvider(
      providers: [
        Provider(
          builder: (_) => db.taskDao,
        ),
        Provider(builder: (_) => db.tagDao)
      ],
      child: MaterialApp(
        title: "Tasks",
        supportedLocales: [
          Locale('ar', 'Arabic'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          // own class which contain our translate file.
          AppLocalizations.delegate,
          // built-in localization for material widget
          GlobalMaterialLocalizations.delegate,
          // built-in localization for text direction
          GlobalMaterialLocalizations.delegate,
        ],
        // Built-in function to return which local will be used.
        localeResolutionCallback: (locale, supported) {
          for (var supportedLocal in supported) {
            if (supportedLocal.languageCode == locale.languageCode &&
                supportedLocal.countryCode == locale.countryCode)
              return supportedLocal;
          }
          return supported.first;
        },

        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
