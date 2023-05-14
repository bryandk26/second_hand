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

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('no image picked');
    } else {
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    List<String> _imageUrlList = [];

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
                              chooseImage();
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
                                  _image.removeAt(index - 1);
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
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () async {
              EasyLoading.show(status: 'Saving Images');
              for (var img in _image) {
                Reference ref = _firebaseStorage
                    .ref()
                    .child('productImage')
                    .child(Uuid().v4());

                await ref.putFile(img).whenComplete(() async {
                  await ref.getDownloadURL().then((value) {
                    setState(() {
                      _imageUrlList.add(value);
                    });
                  });
                });
              }
              setState(() {
                _product_provider.getFormData(imageUrlList: _imageUrlList);

                EasyLoading.dismiss();
              });
            },
            child: _image.isNotEmpty ? Text('Upload') : Text(''),
          ),
        ],
      ),
    );
  }
}
