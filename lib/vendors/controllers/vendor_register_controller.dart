import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('storeImage').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

  Future<String> registerVendor(
    String businessName,
    String email,
    String phoneNumber,
    String address,
    String postalCode,
    String bankName,
    String bankAccountName,
    String bankAccountNumber,
    Uint8List? image,
  ) async {
    String res = 'some error occured';

    try {
      String? storeImage;

      if (image != null) {
        storeImage = await _uploadVendorImageToStorage(image);
      }

      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'businessName': businessName,
        'email': email,
        'phoneNumber': phoneNumber,
        'vendorAddress': address,
        'vendorPostalCode': postalCode,
        'vendorBankName': bankName,
        'vendorBankAccountName': bankAccountName,
        'vendorBankAccountNumber': bankAccountNumber,
        'storeImage': storeImage ?? '',
        'approved': false,
        'vendorRegisteredDate': DateTime.now(),
        'vendorId': _auth.currentUser!.uid,
      });
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
