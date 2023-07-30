
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadingDialog extends StatefulWidget {
  final String url;
  final String fileName;
  const DownloadingDialog(this.url,this.fileName, {Key? key}) : super(key: key);

  @override
  State<DownloadingDialog> createState() => _DownloadingDialogState();


}
class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    String progress = (this.progress * 100).toString();
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(
            height: 20,
          ),
          Text("Downloading $progress %",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          ),


          // CircularProgressIndicator(
          //   value: this.progress,
          // ),
        ],
      ),
    );
  }

  void startDownload() async{
    String downloadUrl = widget.url;
    String fileName = "tasvir ${widget.fileName}.png";
    String path = await _getFilePath(fileName);
    try {
      await dio.download(
        downloadUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
            });
          }
        },
      );

      // Download completed successfully, you can navigate to another screen or do other tasks here.
      Navigator.pop(context);
    } catch (e) {
      // Handle the download error.
      print('Error during download: $e');
      // You can show an error message to the user if needed.
    }
  }

  Future<String> _getFilePath(String fileName) async {
    // Assuming you want to use the "storage/emulated/..." directory
    final dir = Directory('/storage/emulated/0/Download/'); // Update this path based on your needs

    if (await dir.exists()) {
      return '${dir.path}/$fileName';
    } else {
      // Handle the case when the directory doesn't exist (e.g., not available on the device)
      throw Exception("Directory not found: ${dir.path}");
    }
  }

  @override
  void initState() {
    startDownload();
    super.initState();
  }

  void fileDownalod(){
    //You can download a single file

  }


}
