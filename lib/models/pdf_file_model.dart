class PdfFileModel {
  final String name;
  final String path;
  final int size;
  final DateTime downloadedAt;

  PdfFileModel({
    required this.name,
    required this.path,
    required this.size,
    required this.downloadedAt,
  });
}
