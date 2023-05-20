import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/widgets/banner_widget.dart';
import 'package:second_chance/buyers/views/widgets/category_text.dart';
import 'package:second_chance/buyers/views/widgets/welcome_text_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeText(),
        SizedBox(
          height: 14,
        ),
        BannerWidget(),
        CategoryText(),
      ],
    );
  }
}
