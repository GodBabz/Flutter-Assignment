import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import '../services/file_service.dart';

class DownloadedReportsScreen extends StatefulWidget {
  @override
  State<DownloadedReportsScreen> createState() => _DownloadedReportsScreenState();
}

class _DownloadedReportsScreenState extends State<DownloadedReportsScreen> {
  List<FileSystemEntity> files = [];
  List<FileSystemEntity> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final list = await FileService.listDownloadedFiles();
    setState(() {
      files = list;
      selectedFiles.clear();
    });
  }

  void _onFileTap(FileSystemEntity file) {
    OpenFile.open(file.path);
  }

  void _onDeleteSelected() async {
    await FileService.deleteFiles(selectedFiles);
    _loadFiles();
  }

  void _onLongPress(FileSystemEntity file) {
    setState(() {
      if (selectedFiles.contains(file)) {
        selectedFiles.remove(file);
      } else {
        selectedFiles.add(file);
      }
    });
  }

  bool isSelected(FileSystemEntity file) => selectedFiles.contains(file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Downloaded Reports"),
        actions: selectedFiles.isNotEmpty
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _onDeleteSelected,
          )
        ]
            : [],
      ),
      body: files.isEmpty
          ? Center(child: Text("No downloaded reports"))
          : ListView.builder(
        itemCount: files.length,
        itemBuilder: (_, index) {
          final file = files[index];
          final name = file.path.split('/').last;
          return ListTile(
            title: Text(name),
            subtitle: Text(
              '${(File(file.path).lengthSync() / 1024).toStringAsFixed(2)} KB • '
                  '${File(file.path).lastModifiedSync().toLocal()}',
            ),
            tileColor: isSelected(file) ? Colors.grey[300] : null,
            onTap: () => _onFileTap(file),
            onLongPress: () => _onLongPress(file),
            trailing: isSelected(file)
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () async {
          final url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf";
          final file = await FileService.downloadPdf(url, 'report_${DateTime.now().millisecondsSinceEpoch}.pdf');
          _loadFiles();
        },
      ),
    );
  }
}
