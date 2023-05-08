import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  //create reusable function
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Function to store image in firebase storage
  _uploadVendorImageToStorage(Uint8List? image) async {
    //create folder where all of the vendor images will be stored
    Reference ref =
        _storage.ref().child('storeImage').child(_auth.currentUser!.uid);
    //first child is the folder name, second child is will be the file name

    //upload the data
    UploadTask uploadTask = ref.putData(image!);

    //get the snapshot
    TaskSnapshot snapshot = await uploadTask;

    //get the image from the storage and later save it to firestore by getting the downloadUrl
    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
  //Function to store image in firebase storage ends here

  //Function to pick store image
  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }
  //Function to pick store image ends here

  //Function to save vendor data
  Future<String> registerVendor(
    String businessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxRegistered,
    String taxNumber,
    Uint8List? image,
  ) async {
    String res = 'some error occured';

    try {
      String storeImage = await _uploadVendorImageToStorage(image);
      // Save data to cloud Firestore
      await _firestore.collection('vendors').doc(_auth.currentUser!.uid).set({
        'businessName': businessName,
        'email': email,
        'phoneNumber': phoneNumber,
        'countryValue': countryValue,
        'stateValue': stateValue,
        'cityValue': cityValue,
        'taxRegistered': taxRegistered,
        'taxNumber': taxNumber,
        'storeImage': storeImage,
        'approved': false,
        'vendorId': _auth.currentUser!.uid,
      });
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
  //Function to save vendor data ends here
}
