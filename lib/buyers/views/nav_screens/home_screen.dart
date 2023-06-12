import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/widgets/banner_widget.dart';
import 'package:second_chance/buyers/views/widgets/category_text.dart';
import 'package:second_chance/buyers/views/widgets/welcome_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeTextWidget(),
          SizedBox(
            height: 14,
          ),
          BannerWidget(),
          CategoryTextWidget(),
        ],
      ),
    );
  }
}
