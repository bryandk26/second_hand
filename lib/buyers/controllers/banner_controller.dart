import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_chance/buyers/models/banner_model.dart';

class BannerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  void getBanners(Function(List<BannerModel>) onBannersReceived) {
    _subscription = _firestore
        .collection('banners')
        .snapshots()
        .listen((QuerySnapshot querySnapshot) {
      final List<BannerModel> banners = querySnapshot.docs
          .map((doc) => BannerModel.fromDocumentSnapshot(doc))
          .toList();

      onBannersReceived(banners);
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}
