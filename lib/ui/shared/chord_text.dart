import 'package:flutter/material.dart';

import '../../domain/chordpro.dart';

/// Renders a lyric block with ChordPro chords above the corresponding
/// syllables. When a block has no chords it degrades to plain text.
class ChordProText extends StatelessWidget {
  const ChordProText({
    super.key,
    required this.text,
    this.style,
    this.chordStyle,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle? style;
  final TextStyle? chordStyle;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final lines = ChordProParser.parse(text);
    if (!lines.any((line) => line.hasChords)) {
      return Text(text, style: style, textAlign: textAlign);
    }

    final scheme = Theme.of(context).colorScheme;
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final chord = chordStyle ??
        baseStyle.copyWith(
          color: scheme.secondary,
          fontWeight: FontWeight.w700,
          fontSize: (baseStyle.fontSize ?? 16) * 0.78,
          height: 1.1,
        );

    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: line.hasChords
                ? Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    runSpacing: 2,
                    children: [
                      for (final segment in line.segments)
                        _Segment(
                          segment: segment,
                          chordStyle: chord,
                          lyricStyle: baseStyle.copyWith(height: 1.35),
                        ),
                    ],
                  )
                : Text(
                    line.plainText,
                    style: baseStyle,
                    textAlign: textAlign,
                  ),
          ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.chordStyle,
    required this.lyricStyle,
  });

  final ChordSegment segment;
  final TextStyle chordStyle;
  final TextStyle lyricStyle;

  @override
  Widget build(BuildContext context) {
    final lyric = segment.lyric.isEmpty ? '\u00a0' : segment.lyric;
    if (segment.chord == null) {
      return Text(lyric, style: lyricStyle);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(segment.chord!, style: chordStyle),
        Text(lyric, style: lyricStyle),
      ],
    );
  }
}
