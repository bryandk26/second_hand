import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  uploadProfileImageToStorage(Uint8List? image) async {
    Reference ref =
        _storage.ref().child('profilePics').child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putData(image!);

    TaskSnapshot snapshot = await uploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
    }
  }

  Future<String> signUpUsers(
    String email,
    String fullName,
    String phoneNumber,
    String password,
    Uint8List? image,
  ) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? profileImageUrl;
        if (image != null) {
          profileImageUrl = await uploadProfileImageToStorage(image);
        }

        await _firestore.collection('buyers').doc(cred.user!.uid).set(
          {
            'email': email,
            'fullName': fullName,
            'phoneNumber': phoneNumber,
            'buyerId': cred.user!.uid,
            'address': '',
            'profileImage': profileImageUrl ?? ''
          },
        );

        res = 'success';
      } else {
        res = 'Please fields must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        res = 'The email address is badly formatted';
      } else if (e.code == 'invalid-input') {
        res = 'Please fill all fields';
      } else {
        res = e.message ?? 'An error occurred while signing up';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  loginUsers(String email, String password) async {
    String res = 'something went wrong';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fields must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password';
      } else {
        res = e.message ?? 'Something went wrong';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
