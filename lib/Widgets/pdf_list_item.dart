import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pdf_file_model.dart';

class PdfListItem extends StatelessWidget {
  final PdfFileModel file;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const PdfListItem({
    required this.file,
    required this.onTap,
    required this.onLongPress,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(file.name),
      subtitle: Text('${(file.size / 1024).toStringAsFixed(2)} KB • ${DateFormat.yMd().add_jm().format(file.downloadedAt)}'),
      trailing: isSelected ? Icon(Icons.check_box) : Icon(Icons.picture_as_pdf),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
