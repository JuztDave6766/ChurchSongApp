import 'package:flutter/material.dart';

import '../../core/strings.dart';
import '../home/home_screen.dart';
import '../library/library_screen.dart';
import '../setlists/setlists_screen.dart';
import '../settings/settings_screen.dart';
import '../calendar/calendar_screen.dart';
import '../shared/section_header.dart';

/// Responsive shell: bottom navigation on phones, navigation rail on tablets
/// and desktops.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _openSetlists() => setState(() => _index = 3);

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= 960;
    final extended = width >= 1240;

    final pages = <Widget>[
      HomeScreen(onOpenSetlists: _openSetlists),
      const CalendarScreen(),
      const LibraryScreen(),
      const SetlistsScreen(),
      const SettingsScreen(),
    ];

    final content = IndexedStack(index: _index, children: pages);

    if (useRail) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              right: false,
              child: NavigationRail(
                extended: extended,
                selectedIndex: _index,
                onDestinationSelected: (value) =>
                    setState(() => _index = value),
                groupAlignment: -0.85,
                labelType: extended ? null : NavigationRailLabelType.all,
                leading: Padding(
                  padding: EdgeInsets.fromLTRB(
                    extended ? 20 : 0,
                    16,
                    extended ? 20 : 0,
                    24,
                  ),
                  child: extended
                      ? Row(
                          children: [
                            const AppMark(size: 28),
                            const SizedBox(width: 10),
                            Text(
                              strings.appName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        )
                      : const AppMark(size: 30),
                ),
                destinations: [
                  NavigationRailDestination(
                    icon: const Icon(Icons.wb_sunny_outlined),
                    selectedIcon: const Icon(Icons.wb_sunny_rounded),
                    label: Text(strings.navHome),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.calendar_month_outlined),
                    selectedIcon: const Icon(Icons.calendar_month_rounded),
                    label: Text(strings.navCalendar),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.library_music_outlined),
                    selectedIcon: const Icon(Icons.library_music_rounded),
                    label: Text(strings.navSongs),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.queue_music_outlined),
                    selectedIcon: const Icon(Icons.queue_music_rounded),
                    label: Text(strings.navSetlists),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.tune_outlined),
                    selectedIcon: const Icon(Icons.tune_rounded),
                    label: Text(strings.navSettings),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(child: content),
          ],
        ),
      );
    }

    return Scaffold(
      body: content,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.wb_sunny_rounded),
            label: strings.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month_rounded),
            label: strings.navCalendar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_music_outlined),
            selectedIcon: const Icon(Icons.library_music_rounded),
            label: strings.navSongs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.queue_music_outlined),
            selectedIcon: const Icon(Icons.queue_music_rounded),
            label: strings.navSetlists,
          ),
          NavigationDestination(
            icon: const Icon(Icons.tune_outlined),
            selectedIcon: const Icon(Icons.tune_rounded),
            label: strings.navSettings,
          ),
        ],
      ),
    );
  }
}
