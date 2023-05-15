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
      child: Column(
        children: [
          TextFormGlobal(
            text: 'Brand',
            textInputType: TextInputType.text,
            context: context,
            onChanged: (value) {
              _product_provider.getFormData(brandName: value);
              return null;
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextFormGlobal(
            text: 'Size',
            textInputType: TextInputType.text,
            context: context,
            onChanged: (value) {
              _product_provider.getFormData(size: value);
              return null;
            },
          ),
        ],
      ),
    );
  }
}
