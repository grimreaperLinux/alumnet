import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DocumentPicker extends StatefulWidget {
  @override
  _DocumentPickerState createState() => _DocumentPickerState();
}

class _DocumentPickerState extends State<DocumentPicker> {
  final List<File?> _documents = [];
  final List<String> _filenames = [];

  String? getFileName(File file) {
    String path = file.path;
    List<String> pathComponents = path.split('/');
    String fileName = pathComponents.last;
    if (fileName.length > 14) {
      fileName = fileName.substring(0, 14) + '...' + '.pdf';
    }
    return fileName;
  }

  Future<void> _pickDocuments() async {
    if (_documents.length == 4) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Max 4 files only sorry",
        ),
      );
      return;
    }
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result != null) {
        for (PlatformFile pFile in result.files) {
          if (_documents.length >= 4) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: "Max 4 files only sorry",
              ),
            );
            break;
          }
          if (pFile.path != null) {
            File file = File(pFile.path!);
            if (file.lengthSync() <= 10 * 1024 * 1024) {
              _documents.add(file);
              _filenames.add(getFileName(file) as String);
            } else {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Max file size is 10 MB",
                ),
              );
            }
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Error selecting PDF files: $e');
    }
  }

  void _removeDocument(int index) {
    setState(() {
      _documents.removeAt(index);
      _filenames.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 15),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Wrap(
                children: _documents.map((doc) {
                  int index = _documents.indexOf(doc);
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.insert_drive_file,
                              color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Text(
                            _filenames[index],
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => _removeDocument(index),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              elevation: 5,
              color: const Color(0xff345C67),
              borderRadius: BorderRadius.circular(15.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.5,
                onPressed: () {
                  _pickDocuments();
                },
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'Select Documents',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
