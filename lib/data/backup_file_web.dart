import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;

/// Downloads [content] as a JSON file in the browser.
Future<bool> saveBackupFile(String content, String fileName) async {
  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = fileName
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return true;
}

/// Opens the browser file picker and returns the selected JSON text.
Future<String?> pickBackupFile() async {
  final input = html.FileUploadInputElement()
    ..accept = 'application/json,.json'
    ..style.display = 'none';
  html.document.body?.children.add(input);

  final completer = Completer<String?>();
  input.onChange.listen((_) {
    final file = input.files?.firstOrNull;
    if (file == null) {
      completer.complete(null);
      input.remove();
      return;
    }
    final reader = html.FileReader();
    reader.onLoadEnd.listen((_) {
      completer.complete(reader.result as String?);
      input.remove();
    });
    reader.onError.listen((_) {
      completer.complete(null);
      input.remove();
    });
    reader.readAsText(file);
  });
  input.click();
  return completer.future;
}
