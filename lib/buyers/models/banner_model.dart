import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String image;

  BannerModel({required this.image});

  factory BannerModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return BannerModel(image: snapshot['image']);
  }
}
