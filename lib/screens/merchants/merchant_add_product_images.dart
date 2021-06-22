import 'dart:io';

import 'package:beammart/providers/image_upload_provider.dart';
import 'package:beammart/screens/merchants/camera_photo_screen.dart';
import 'package:beammart/utils/upload_files_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class AddImagesScreen extends StatefulWidget {
  final bool? editing;
  final String? itemId;
  final int? itemsLength;

  const AddImagesScreen({
    Key? key,
    this.editing,
    this.itemId,
    this.itemsLength,
  }) : super(key: key);
  @override
  _AddImagesScreenState createState() => _AddImagesScreenState();
}

class _AddImagesScreenState extends State<AddImagesScreen> {
  bool _loading = false;
  String? fileName;
  PickedFile? pickedImageFile;
  final picker = ImagePicker();
  List<File> _images = [];
  List<String?> _imageUrls = [];

  galleryImage(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  cameraImage(context) {}

  Future<void> uploadImages(
      List<File> files, String userId, String itemId) async {
    setState(() {
      _loading = true;
    });

    // Upload to Cloud Storage
    for (var image in files) {
      String? _imageUrl = await uploadFile(image);
      _imageUrls.add(_imageUrl);
    }
    // Update the Firestore Collection
    final DocumentReference _itemsRef = FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .collection('items')
        .doc(itemId);

    await _itemsRef.set({
      'images': FieldValue.arrayUnion(_imageUrls),
    }, SetOptions(merge: true)).whenComplete(() {
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pop();
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images = List.from(_images)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: (widget.editing != null && widget.editing!)
            ? (_loading)
                ? Text("Uploading...")
                : Text('Add New Images')
            : Text('Item Images'),
        actions: (widget.editing != null && widget.editing!)
            ? [
                (_images.length != 0)
                    ? TextButton(
                        onPressed: () {
                          uploadImages(
                              _images, currentUser!.uid, widget.itemId!);
                        },
                        child: (_loading)
                            ? Container()
                            : Text(
                                'Finish',
                                style: TextStyle(color: Colors.pink),
                              ),
                      )
                    : Container()
              ]
            : [
                (_images.length != 0)
                    ? TextButton(
                        onPressed: () {
                          _imageUploadProvider.uploadImages(_images);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => PickCategory(
                          //       images: _images,
                          //     ),
                          //     settings:
                          //         RouteSettings(name: 'PickCategoryScreen'),
                          //   ),
                          // );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Text(
                            'NEXT',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
      ),
      body: (_loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final File? _newCameraPhoto =
                            await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CameraPhotoScreen(),
                          ),
                        );
                        if (_newCameraPhoto != null) {
                          print(_newCameraPhoto.path);
                          setState(() {
                            _images.add(_newCameraPhoto);
                          });
                        }
                      },
                      label: Text('Camera'),
                      icon: Icon(
                        Icons.camera_outlined,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        galleryImage(context);
                      },
                      label: Text('Gallery'),
                      icon: Icon(
                        Icons.collections_outlined,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                (_images.length != 0)
                    ? GridView.builder(
                        itemCount: _images.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GridTile(
                                child: Image.file(
                                  _images[index],
                                  fit: BoxFit.cover,
                                ),
                                footer: GridTileBar(
                                  backgroundColor: Colors.black38,
                                  leading: IconButton(
                                    color: Colors.red,
                                    icon: Icon(
                                      Icons.delete_outline_outlined,
                                    ),
                                    onPressed: () => _removeImage(index),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'Please select an image from gallery or take one',
                        ),
                      ),
              ],
            ),
    );
  }
}
