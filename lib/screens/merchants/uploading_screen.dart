import 'package:flutter/material.dart';

class UploadingScreen extends StatelessWidget {
  const UploadingScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Uploading...'),
        centerTitle: true,
      ),
      body: LinearProgressIndicator(),
    );
  }
}