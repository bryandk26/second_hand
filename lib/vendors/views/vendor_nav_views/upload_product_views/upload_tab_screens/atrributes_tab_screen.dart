import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/provider/product_provider.dart';

class AttributesTabScreen extends StatefulWidget {
  @override
  State<AttributesTabScreen> createState() => _AttributesTabScreenState();
}

class _AttributesTabScreenState extends State<AttributesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextFormGlobal(
              text: 'Brand',
              textInputType: TextInputType.text,
              labelText: 'Brand',
              context: context,
              onChanged: (value) {
                _product_provider.saveFormData(brandName: value);
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormGlobal(
              text:
                  'Detail Size\n\nEx:\nChest: 39 cm\nWaist: 37 cm\nSleeves: 24 cm\nShoulder: 18 cm\nLength: 29 cm',
              textInputType: TextInputType.multiline,
              labelText: 'Detail Size',
              context: context,
              onChanged: (value) {
                _product_provider.saveFormData(size: value);
                return null;
              },
              maxLines: 8,
              maxLength: 800,
            ),
          ],
        ),
      ),
    );
  }
}
