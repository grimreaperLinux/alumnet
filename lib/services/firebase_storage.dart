import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FileUpload {
  Future<String> imageupload(File imagefile, String path) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final ref = storageRef.child(path);

      await ref.putFile(
        File(imagefile.path),
      );

      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Error();
    }
  }

  Future<String> pdfupload(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(file);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
      throw Error();
    }
  }
}
