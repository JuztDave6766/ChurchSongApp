import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/strings.dart';
import '../../core/theme.dart';
import '../../domain/catalog.dart';
import '../../domain/models.dart';

/// Immersive celebration mode.
///
/// The "presentation" advances through stanzas automatically: it is a guided
/// lyric display, since the demo ships without audio files. When real audio
/// assets are added, this screen is the single place where playback controls
/// need to be wired in.
class EventScreen extends StatefulWidget {
  const EventScreen({super.key, required this.setlist});

  final Setlist setlist;

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  static const _secondsPerSection = 18;
  static const _text = Color(0xFFF5F0E6);
  static const _muted = Color(0xFFA9A2B8);
  static const _dim = Color(0xFF746D84);

  final _scroll = ScrollController();
  late final List<SetlistItem> _items;
  final Set<int> _visited = {};
  List<GlobalKey> _sectionKeys = const [];

  int _index = 0;
  int _sectionIndex = 0;
  int _elapsed = 0;
  bool _presenting = false;
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _items = widget.setlist.items
        .where((item) => kSongsById.containsKey(item.songId))
        .toList();
    _resetKeys();
    if (_items.isNotEmpty) {
      _visited.add(0);
      _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  Song? get _currentSong =>
      _items.isEmpty ? null : kSongsById[_items[_index].songId];

  List<SongSection> get _sections => _currentSong?.sections ?? const [];

  LiturgicalMoment? get _moment {
    final function = kFunctionsById[widget.setlist.functionId];
    final id = _items.isEmpty ? null : _items[_index].momentId;
    if (id == null) return null;
    return function?.momentById(id);
  }

  void _resetKeys() {
    _sectionKeys = List.generate(
      _sections.length,
      (_) => GlobalKey(),
    );
  }

  void _tick(Timer timer) {
    if (!mounted) return;
    setState(() {
      _elapsed++;
      if (_presenting) {
        _progress += 1 / _secondsPerSection;
        if (_progress >= 1) {
          if (_sectionIndex < _sections.length - 1) {
            _sectionIndex++;
            _progress = 0;
            _scrollToCurrentSection();
          } else {
            _progress = 1;
            _presenting = false;
          }
        }
      }
    });
  }

  void _scrollToCurrentSection() {
    if (_sectionIndex < 0 || _sectionIndex >= _sectionKeys.length) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _sectionKeys[_sectionIndex].currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.18,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _togglePresentation() {
    setState(() {
      if (_presenting) {
        _presenting = false;
        return;
      }
      if (_sectionIndex == _sections.length - 1 && _progress >= 0.999) {
        _sectionIndex = 0;
        _progress = 0;
        _scrollToCurrentSection();
      }
      _presenting = true;
    });
  }

  void _changeSection(int delta) {
    final next = _sectionIndex + delta;
    if (next < 0 || next >= _sections.length) return;
    setState(() {
      _sectionIndex = next;
      _progress = 0;
      _presenting = false;
    });
    _scrollToCurrentSection();
  }

  void _goToSong(int newIndex) {
    if (newIndex < 0 || newIndex >= _items.length) return;
    setState(() {
      _index = newIndex;
      _sectionIndex = 0;
      _progress = 0;
      _presenting = false;
      _visited.add(newIndex);
      _resetKeys();
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Future<void> _finish({bool confirm = true}) async {
    final strings = AppStrings.of(context);
    if (confirm) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(strings.finishEvent),
          content: Text(strings.finishEventQuestion),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(strings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(strings.finishEvent),
            ),
          ],
        ),
      );
      if (ok != true || !mounted) return;
    }

    _timer?.cancel();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle_outline_rounded),
        title: Text(strings.eventComplete),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(strings.eventCompleteBody, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            _SummaryRow(
              icon: Icons.music_note_rounded,
              label: strings.songsSung(_visited.length),
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              icon: Icons.timer_outlined,
              label:
                  '${strings.elapsedLabel}: ${_formatDuration(_elapsed)}',
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(strings.backToSetlist),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmExit() async {
    final strings = AppStrings.of(context);
    final leave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.exitEvent),
        content: Text(strings.exitEventQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.stay),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.exit),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final song = _currentSong;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        backgroundColor: AppColors.night,
        body: Container(
          decoration: BoxDecoration(gradient: AppColors.eventGradient()),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, strings),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: _items.isEmpty
                          ? 0
                          : (_index + 1) / _items.length,
                      minHeight: 3,
                      backgroundColor: Colors.white.withValues(alpha: 0.10),
                      color: AppColors.goldSoft,
                    ),
                  ),
                ),
                Expanded(
                  child: song == null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              strings.eventNoSongs,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: _muted),
                            ),
                          ),
                        )
                      : _buildLyrics(context, strings, song),
                ),
                if (song != null) _buildControls(context, strings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppStrings strings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
      child: Row(
        children: [
          IconButton(
            tooltip: strings.close,
            onPressed: _confirmExit,
            icon: const Icon(Icons.close_rounded, color: _muted),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.eventMode.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.goldSoft,
                        letterSpacing: 1.6,
                      ),
                ),
                Text(
                  widget.setlist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _text,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, size: 14, color: _muted),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(_elapsed),
                  style: const TextStyle(
                    color: _text,
                    fontFeatures: [FontFeature.tabularFigures()],
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLyrics(BuildContext context, AppStrings strings, Song song) {
    final moment = _moment;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: ListView(
          controller: _scroll,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          children: [
            Row(
              children: [
                if (moment != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.goldSoft.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      moment
                          .label(strings.languageCode)
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.goldSoft,
                        fontSize: 10.5,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (moment != null) const SizedBox(width: 10),
                Text(
                  strings.stanzaProgress(_index + 1, _items.length),
                  style: const TextStyle(color: _dim, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              song.title(strings.languageCode),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: _text,
                    fontSize: 42,
                  ),
            ),
            if (song.author != null) ...[
              const SizedBox(height: 4),
              Text(
                song.author!,
                style: const TextStyle(color: _muted, fontSize: 13.5),
              ),
            ],
            if (_presenting) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: _progress.clamp(0.0, 1.0),
                  minHeight: 2,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  color: AppColors.goldSoft.withValues(alpha: 0.9),
                ),
              ),
            ],
            const SizedBox(height: 22),
            for (var i = 0; i < _sections.length; i++)
              _buildSection(context, strings, i),
            if (_index < _items.length - 1) ...[
              const SizedBox(height: 20),
              _Upcoming(
                moment: _momentLabelFor(_items[_index + 1], strings),
                title: kSongsById[_items[_index + 1].songId]
                        ?.title(strings.languageCode) ??
                    '',
                label: strings.upcoming,
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String? _momentLabelFor(SetlistItem item, AppStrings strings) {
    final momentId = item.momentId;
    if (momentId == null) return null;
    return kFunctionsById[widget.setlist.functionId]
        ?.momentById(momentId)
        ?.label(strings.languageCode);
  }

  Widget _buildSection(BuildContext context, AppStrings strings, int index) {
    final section = _sections[index];
    final isCurrent = index == _sectionIndex;
    final label = switch (section.kind) {
      SectionKind.verse =>
        strings.sectionVerse(_verseNumber(index)),
      SectionKind.chorus => strings.sectionChorus,
      SectionKind.bridge => strings.sectionBridge,
      SectionKind.response => strings.sectionResponse,
    };

    return GestureDetector(
      key: _sectionKeys[index],
      onTap: () {
        setState(() {
          _sectionIndex = index;
          _progress = 0;
          _presenting = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: isCurrent
              ? Colors.white.withValues(alpha: 0.065)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: isCurrent ? AppColors.goldSoft : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: isCurrent ? AppColors.goldSoft : _dim,
                fontSize: 10.5,
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              section.text,
              style: TextStyle(
                color: isCurrent ? _text : _muted,
                fontSize: 17,
                height: 1.65,
                fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _verseNumber(int sectionIndex) {
    var verse = 0;
    for (var i = 0; i <= sectionIndex; i++) {
      if (_sections[i].kind == SectionKind.verse) verse++;
    }
    return verse;
  }

  Widget _buildControls(BuildContext context, AppStrings strings) {
    final isLastSong = _index == _items.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: strings.previousSong,
                    onPressed: _sectionIndex == 0
                        ? null
                        : () => _changeSection(-1),
                    icon: const Icon(Icons.chevron_left_rounded, size: 26),
                    color: _muted,
                    disabledColor: _dim.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: FilledButton(
                      onPressed: _sections.isEmpty ? null : _togglePresentation,
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.goldSoft,
                        foregroundColor: AppColors.night,
                      ),
                      child: Icon(
                        _presenting
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    tooltip: strings.nextSong,
                    onPressed: _sectionIndex >= _sections.length - 1
                        ? null
                        : () => _changeSection(1),
                    icon: const Icon(Icons.chevron_right_rounded, size: 26),
                    color: _muted,
                    disabledColor: _dim.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    strings.stanzaProgress(
                      _sectionIndex + 1,
                      _sections.length,
                    ),
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed:
                          _index == 0 ? null : () => _goToSong(_index - 1),
                      icon: const Icon(Icons.skip_previous_rounded, size: 19),
                      label: Text(
                        strings.previousSong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: _muted,
                        disabledForegroundColor:
                            _dim.withValues(alpha: 0.4),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _finish(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.goldSoft,
                    ),
                    child: Text(strings.finishEvent),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: isLastSong
                          ? null
                          : () => _goToSong(_index + 1),
                      icon: const Icon(Icons.skip_next_rounded, size: 19),
                      label: Text(
                        strings.nextSong,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: _text,
                        disabledForegroundColor: _dim.withValues(alpha: 0.4),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Upcoming extends StatelessWidget {
  const _Upcoming({
    required this.moment,
    required this.title,
    required this.label,
  });

  final String? moment;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.skip_next_rounded, size: 16, color: _EventScreenState._dim),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label · ${moment != null ? '$moment · ' : ''}$title',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _EventScreenState._dim,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 17, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
