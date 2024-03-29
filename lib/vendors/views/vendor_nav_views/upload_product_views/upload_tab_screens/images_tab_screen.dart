import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/provider/product_provider.dart';
import 'package:uuid/uuid.dart';

class ImagesTabScreen extends StatefulWidget {
  const ImagesTabScreen({super.key});

  @override
  State<ImagesTabScreen> createState() => _ImagesTabScreenState();
}

class _ImagesTabScreenState extends State<ImagesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker picker = ImagePicker();

  List<File> _image = [];
  List<String> _imageUrlLists = [];

  _chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('no image picked');
    } else {
      EasyLoading.show(status: 'Uploading...');
      setState(() {
        _image.add(File(pickedFile.path));
      });
      await _uploadImage(_image.last);
    }
  }

  Future<void> _uploadImage(File image) async {
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final Reference ref =
        _firebaseStorage.ref().child('productImage').child(Uuid().v4());

    await ref.putFile(image).whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        setState(() {
          _imageUrlLists.add(value);
        });
        Provider.of<ProductProvider>(context, listen: false)
            .saveFormData(imageUrlList: _imageUrlLists);
        EasyLoading.dismiss();
      });
    });
  }

  void _removeImage(int index) {
    setState(() {
      String removedImageUrl = _imageUrlLists.removeAt(index);
      Provider.of<ProductProvider>(context, listen: false)
          .removeImageUrl(removedImageUrl);
      _image.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _image.length + 1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3 / 3,
              ),
              itemBuilder: ((context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                            onPressed: () {
                              _chooseImage();
                            },
                            icon: Icon(Icons.add)),
                      )
                    : Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_image[index - 1]),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _removeImage(index - 1);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
