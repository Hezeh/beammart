import 'package:beammart/providers/image_upload_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadingImagesWidget extends StatelessWidget {
  const UploadingImagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return (_imageUploadProvider.isUploadingImages != null)
        ? (_imageUploadProvider.isUploadingImages!)
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.pink,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text("Uploading Product Images..."),
                ),
              )
            : Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purple,
                      Colors.pink,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Images Uploaded Successfully"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan,
                      ),
                      onPressed: () {
                        // _postItem();
                      },
                      child: Text("Post Item"),
                    ),
                  ],
                ),
              )
        : Container(
            child: Text(""),
          );
  }
}
