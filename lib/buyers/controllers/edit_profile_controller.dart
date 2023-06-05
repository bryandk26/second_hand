import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:second_chance/buyers/models/buyer_model.dart';

class EditProfileController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAccountNameController =
      TextEditingController();
  final TextEditingController bankAccountNumberController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<void> updateProfileImage() async {
    final imageBytes = await pickImage();
    if (imageBytes != null) {
      EasyLoading.show(status: 'Uploading...');
      final downloadUrl = await uploadImage(imageBytes);
      if (downloadUrl != null) {
        await _firestore
            .collection('buyers')
            .doc(_auth.currentUser!.uid)
            .update({'profileImage': downloadUrl});
        EasyLoading.showSuccess('Image uploaded successfully');
      } else {
        EasyLoading.showError('Failed to upload image');
      }
    }
  }

  Future<void> updateBuyerProfile(BuyerModel userData) async {
    final buyerModel = BuyerModel(
      email: emailController.text,
      fullName: fullNameController.text,
      phoneNumber: phoneController.text,
      buyerId: _auth.currentUser!.uid,
      address: addressController.text,
      postalCode: postalCodeController.text,
      bankName: bankNameController.text,
      bankAccountName: bankAccountNameController.text,
      bankAccountNumber: bankAccountNumberController.text,
      profileImage: userData.profileImage,
      registeredDate: userData.registeredDate,
    );

    await _firestore
        .collection('buyers')
        .doc(_auth.currentUser!.uid)
        .update(buyerModel.toMap());
  }
}
