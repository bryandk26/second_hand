import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic userData;

  EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNamecontroller = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    setState(() {
      _fullNamecontroller.text = widget.userData['fullName'] ?? '';
      _emailController.text = widget.userData['email'] ?? '';
      _phoneController.text = widget.userData['phoneNumber'] ?? '';
      _addressController.text = widget.userData['address'] ?? '';
    });
    super.initState();
  }

  @override
  void dispose() {
    _fullNamecontroller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    super.dispose();
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

  Future<void> _updateBuyerProfile(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        await _firestore
            .collection('buyers')
            .doc(_auth.currentUser!.uid)
            .update({
          'fullName': _fullNamecontroller.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
        });

        setState(() {
          _isLoading = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                initialIndex: 5,
              ),
            ));
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      displayDialog(
        context,
        'Please fields must not be empty',
        Icon(
          Icons.error,
          color: Colors.red,
          size: 60,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String profileImage = widget.userData['profileImage'];
    if (profileImage.isEmpty) {
      profileImage =
          'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: blackColor),
        title: Text(
          'Edit Profile',
          style: subTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(28.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              profileImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: blackColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                color: whiteColor,
                                size: 20,
                              ),
                              onPressed: () {
                                _updateProfileImage();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Divider(),
                SizedBox(height: 10),
                TextFormGlobal(
                  text: 'Full Name',
                  textInputType: TextInputType.text,
                  context: context,
                  controller: _fullNamecontroller,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  enabled: false,
                  text: 'Email',
                  textInputType: TextInputType.emailAddress,
                  context: context,
                  controller: _emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Phone Number',
                  textInputType: TextInputType.phone,
                  context: context,
                  controller: _phoneController,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Address',
                  textInputType: TextInputType.phone,
                  context: context,
                  controller: _addressController,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            await _updateBuyerProfile(context);
          },
          child: ButtonGlobal(isLoading: _isLoading, text: 'Update Profile'),
        ),
      ),
    );
  }
}
