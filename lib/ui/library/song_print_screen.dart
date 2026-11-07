import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../core/strings.dart';
import '../../data/library_controller.dart';
import '../../domain/chordpro.dart';
import '../../domain/models.dart';
import '../shared/chord_text.dart';

/// A4 song sheet: a readable on-screen preview plus a real PDF export through
/// the platform print dialog.
class SongPrintScreen extends StatelessWidget {
  const SongPrintScreen({super.key, required this.songId});

  final String songId;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final library = context.watch<LibraryController>();
    final song = library.songById(songId);

    if (song == null) {
      return Scaffold(
        appBar: AppBar(title: Text(strings.printSong)),
        body: Center(child: Text(strings.noSongsYet)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.printSong),
        actions: [
          IconButton(
            tooltip: strings.printSong,
            onPressed: () => _print(song, strings),
            icon: const Icon(Icons.print_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Text(
              strings.printHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.6,
              maxScale: 2.4,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 760),
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: 210 / 297,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(34),
                      child: _Preview(song: song, strings: strings),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _print(Song song, AppStrings strings) async {
    await Printing.layoutPdf(
      name: '${song.id}.pdf',
      onLayout: (_) => _buildPdf(song, strings),
    );
  }

  Future<Uint8List> _buildPdf(Song song, AppStrings strings) async {
    final doc = pw.Document(
      title: song.title(strings.languageCode),
      author: song.author ?? 'ChurchSongApp',
      subject: strings.printHint,
    );
    final theme = pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
      boldItalic: pw.Font.helveticaBoldOblique(),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(42, 42, 42, 46),
        theme: theme,
        header: (context) => context.pageNumber == 1
            ? pw.SizedBox()
            : pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 12),
                child: pw.Text(
                  song.title(strings.languageCode),
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 12),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'ChurchSongApp · ${strings.demoBadge}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
              pw.Text(
                '${context.pageNumber} / ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
            ],
          ),
        ),
        build: (_) => [
          pw.Text(
            song.title(strings.languageCode),
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          if (song.version != null && song.version!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                song.version!,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ),
          pw.SizedBox(height: 6),
          pw.Wrap(
            spacing: 14,
            runSpacing: 3,
            children: [
              if (song.author != null && song.author!.isNotEmpty)
                pw.Text(
                  song.author!,
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                ),
              if (song.keySignature != null && song.keySignature!.isNotEmpty)
                pw.Text(
                  '${strings.keyField}: ${song.keySignature}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                ),
              if (song.sourceNote != null && song.sourceNote!.isNotEmpty)
                pw.Text(
                  '${strings.personalSourceLabel}: ${song.sourceNote}',
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Divider(color: PdfColors.grey500, thickness: 0.6),
          pw.SizedBox(height: 10),
          ..._pdfSections(song, strings),
          pw.SizedBox(height: 14),
          pw.Text(
            '${strings.licenseName(song.license)} · ${strings.demoBadge}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    return doc.save();
  }

  List<pw.Widget> _pdfSections(Song song, AppStrings strings) {
    final widgets = <pw.Widget>[];
    var verse = 0;
    for (final section in song.sections) {
      if (section.kind == SectionKind.verse) verse++;
      final label = switch (section.kind) {
        SectionKind.verse => strings.sectionVerse(verse),
        SectionKind.chorus => strings.sectionChorus,
        SectionKind.bridge => strings.sectionBridge,
        SectionKind.response => strings.sectionResponse,
      };
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                label.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 7.5,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 3),
              ..._pdfChordText(section.text),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  List<pw.Widget> _pdfChordText(String text) {
    const lyricStyle = pw.TextStyle(fontSize: 11, lineSpacing: 2);
    const chordStyle = pw.TextStyle(
      fontSize: 8.5,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey800,
    );

    final lines = ChordProParser.parse(text);
    final widgets = <pw.Widget>[];
    for (final line in lines) {
      if (!line.hasChords) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(line.plainText, style: lyricStyle),
          ),
        );
        continue;
      }
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 2),
          child: pw.Wrap(
            spacing: 0,
            runSpacing: 3,
            crossAxisAlignment: pw.WrapCrossAlignment.end,
            children: [
              for (final segment in line.segments)
                ..._pdfSegment(segment, lyricStyle, chordStyle),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  List<pw.Widget> _pdfSegment(
    ChordSegment segment,
    pw.TextStyle lyricStyle,
    pw.TextStyle chordStyle,
  ) {
    if (segment.chord == null) {
      return _pdfWords(segment.lyric, null, lyricStyle, chordStyle);
    }
    return _pdfWords(segment.lyric, segment.chord, lyricStyle, chordStyle);
  }

  List<pw.Widget> _pdfWords(
    String lyric,
    String? chord,
    pw.TextStyle lyricStyle,
    pw.TextStyle chordStyle,
  ) {
    if (lyric.isEmpty) {
      return [
        pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (chord != null) pw.Text(chord, style: chordStyle),
            pw.Text('\u00a0', style: lyricStyle),
          ],
        ),
      ];
    }

    final tokens = RegExp(r'\S+\s*').allMatches(lyric).map((m) => m.group(0)!);
    final widgets = <pw.Widget>[];
    var first = true;
    for (final token in tokens) {
      final isSpace = token.trim().isEmpty;
      if (isSpace) {
        widgets.add(pw.Text(token, style: lyricStyle));
        continue;
      }
      widgets.add(
        pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (first && chord != null) pw.Text(chord, style: chordStyle),
            pw.Text(token, style: lyricStyle),
          ],
        ),
      );
      first = false;
    }
    if (widgets.isEmpty) {
      widgets.add(pw.Text(lyric, style: lyricStyle));
    }
    return widgets;
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.song, required this.strings});

  final Song song;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF1A1A1A);
    const muted = Color(0xFF555555);
    const chordColor = Color(0xFF7A4B00);

    final titleStyle = const TextStyle(
      fontFamily: 'Cormorant',
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: ink,
    );
    final bodyStyle = const TextStyle(
      fontFamily: 'Manrope',
      fontSize: 12.5,
      height: 1.55,
      color: ink,
    );

    var verse = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(song.title(strings.languageCode), style: titleStyle),
        if (song.version != null && song.version!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            song.version!,
            style: const TextStyle(fontSize: 11, color: muted),
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 14,
          runSpacing: 3,
          children: [
            if (song.author != null && song.author!.isNotEmpty)
              Text(song.author!, style: const TextStyle(fontSize: 10.5, color: muted)),
            if (song.keySignature != null && song.keySignature!.isNotEmpty)
              Text(
                '${strings.keyField}: ${song.keySignature}',
                style: const TextStyle(fontSize: 10.5, color: muted),
              ),
            if (song.sourceNote != null && song.sourceNote!.isNotEmpty)
              Text(
                '${strings.personalSourceLabel}: ${song.sourceNote}',
                style: const TextStyle(fontSize: 10.5, color: muted),
              ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: Color(0xFFCCCCCC), height: 1),
        ),
        for (final section in song.sections) ...[
          Builder(
            builder: (_) {
              if (section.kind == SectionKind.verse) verse++;
              final label = switch (section.kind) {
                SectionKind.verse => strings.sectionVerse(verse),
                SectionKind.chorus => strings.sectionChorus,
                SectionKind.bridge => strings.sectionBridge,
                SectionKind.response => strings.sectionResponse,
              };
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    ChordProText(
                      text: section.text,
                      style: bodyStyle,
                      chordStyle: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: chordColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 8),
        Text(
          '${strings.licenseName(song.license)} · ${strings.demoBadge}',
          style: const TextStyle(fontSize: 8.5, color: muted),
        ),
      ],
    );
  }
}
