import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/strings.dart';
import 'core/theme.dart';
import 'data/library_controller.dart';
import 'data/calendar_service.dart';
import 'data/local_store.dart';
import 'data/setlist_controller.dart';
import 'data/settings_controller.dart';
import 'data/sundays_service.dart';
import 'domain/models.dart';
import 'ui/shell/app_shell.dart';

class ChurchSongApp extends StatelessWidget {
  const ChurchSongApp({
    super.key,
    required this.store,
    this.personalSongs = const [],
  });

  final LocalStore store;
  final List<Song> personalSongs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsController(store)),
        ChangeNotifierProvider(
          create: (_) =>
              LibraryController(store: store, catalogue: personalSongs),
        ),
        ChangeNotifierProvider(create: (_) => SetlistController(store)),
        ChangeNotifierProvider(create: (_) => LiturgicalCalendarController()),
        ChangeNotifierProvider(create: (_) => SundaysController()),
      ],
      child: const _App(),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return MaterialApp(
      onGenerateTitle: (context) => AppStrings.of(context).appName,
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: const [Locale('it'), Locale('en')],
      localizationsDelegates: const [
        AppStringsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      home: const AppShell(),
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.3,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
