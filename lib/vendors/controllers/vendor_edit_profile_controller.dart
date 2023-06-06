import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:second_chance/vendors/models/vendor_user_models.dart';

class VendorEditProfileController {
  final TextEditingController businessNamecontroller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAccountNameController =
      TextEditingController();
  final TextEditingController bankAccountNumberController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void initControllerData(dynamic vendorData) {
    businessNamecontroller.text = vendorData.businessName;
    emailController.text = vendorData.email;
    phoneController.text = vendorData.phoneNumber;
    addressController.text = vendorData.address;
    postalCodeController.text = vendorData.postalCode;
    bankNameController.text = vendorData.bankName;
    bankAccountNameController.text = vendorData.bankAccountName;
    bankAccountNumberController.text = vendorData.bankAccountNumber;
  }

  void disposeControllers() {
    businessNamecontroller.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    postalCodeController.dispose();
    bankNameController.dispose();
    bankAccountNameController.dispose();
    bankAccountNumberController.dispose();
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
        _storage.ref().child('storeImage').child(_auth.currentUser!.uid);
    final UploadTask uploadTask = ref.putData(imageBytes);
    final TaskSnapshot snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateStoreImage(Map<String, dynamic> vendorData,
      Function(String) setStateCallback) async {
    final imageBytes = await pickImage();
    if (imageBytes != null) {
      EasyLoading.show(status: 'Uploading...');
      final downloadUrl = await uploadImage(imageBytes);
      if (downloadUrl != null) {
        await _firestore
            .collection('vendors')
            .doc(_auth.currentUser!.uid)
            .update({'storeImage': downloadUrl});
        setStateCallback(downloadUrl);
        EasyLoading.showSuccess('Image uploaded successfully');
      } else {
        EasyLoading.showError('Failed to upload image');
      }
    }
  }

  Future<void> updateVendorProfile(VendorUserModel vendorData) async {
    final vendorUserModel = VendorUserModel(
      approved: vendorData.approved,
      vendorId: vendorData.vendorId,
      businessName: businessNamecontroller.text,
      address: addressController.text,
      postalCode: postalCodeController.text,
      bankName: bankNameController.text,
      bankAccountName: bankAccountNameController.text,
      bankAccountNumber: bankAccountNumberController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      storeImage: vendorData.storeImage,
    );

    await _firestore
        .collection('vendors')
        .doc(_auth.currentUser!.uid)
        .update(vendorUserModel.toJson());
  }
}
