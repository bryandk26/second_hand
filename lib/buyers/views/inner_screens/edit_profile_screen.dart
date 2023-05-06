import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //will give use access to the user input
  final TextEditingController _fullNamecontroller = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  // String? address;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    setState(() {
      _fullNamecontroller.text = widget.userData['fullName'];
      _emailController.text = widget.userData['email'];
      _phoneController.text = widget.userData['phoneNumber'];
      _addressController.text = widget.userData['address'];
    });
    super.initState();
  }

  Future<Uint8List?> pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    final imageBytes = await pickedImage.readAsBytes();
    return imageBytes;
  }

  Future<String?> uploadImage(Uint8List? imageBytes) async {
    if (imageBytes == null) return null;
    final Reference ref =
        _storage.ref().child('profilePics').child(_auth.currentUser!.uid);
    final UploadTask uploadTask = ref.putData(imageBytes);
    final TaskSnapshot snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _updateProfileImage() async {
    final imageBytes = await pickImage();
    if (imageBytes != null) {
      EasyLoading.show(status: 'Uploading...');
      final downloadUrl = await uploadImage(imageBytes);
      if (downloadUrl != null) {
        await _firestore
            .collection('buyers')
            .doc(_auth.currentUser!.uid)
            .update({'profileImage': downloadUrl});
        setState(() {
          widget.userData['profileImage'] = downloadUrl;
        });
        EasyLoading.showSuccess('Image uploaded successfully');
      } else {
        EasyLoading.showError('Failed to upload image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), // buat arrownya
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 3,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: widget.userData['profileImage'] != null
                          ? NetworkImage(widget.userData['profileImage'])
                          : null,
                      backgroundColor: Colors.yellow.shade900,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          _updateProfileImage();
                        },
                        icon: Icon(CupertinoIcons.photo),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fullNamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Enter Full Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Enter Phone Number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    // onChanged: (value) {
                    //   address = value;
                    // },
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Enter Address',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () async {
            EasyLoading.show(status: 'Updating');
            await _firestore
                .collection('buyers')
                .doc(_auth.currentUser!.uid)
                .update({
              'fullName': _fullNamecontroller.text,
              //Sebenarnya jika emailnya diganti, yg terganti hanya yg di Firestore, tetapi currentUser masih melakukan login dengan akunnya menggunakan email yang terdaftar di FirebaseAuth
              'email': _emailController.text,
              'phoneNumber': _phoneController.text,
              'address': _addressController.text,
            }).whenComplete(
              () {
                EasyLoading.dismiss();

                Navigator.pop(context);
              },
            );
          },
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(
              'UPDATE PROFILE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            )),
          ),
        ),
      ),
    );
  }
}
