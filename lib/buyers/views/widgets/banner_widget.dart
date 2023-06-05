import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/controllers/banner_controller.dart';
import 'package:second_chance/buyers/models/banner_model.dart';
import 'package:second_chance/theme.dart';
import 'package:shimmer/shimmer.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final BannerController _bannerController = BannerController();
  List<BannerModel> _bannerImages = [];

  @override
  void initState() {
    super.initState();
    _bannerController.getBanners((List<BannerModel> banners) {
      setState(() {
        _bannerImages = banners;
      });
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: PageView.builder(
          itemCount: _bannerImages.length,
          itemBuilder: (context, index) {
            final banner = _bannerImages[index];
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: banner.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    color: whiteColor,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          },
        ),
      ),
    );
  }
}
