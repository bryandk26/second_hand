import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/provider/product_provider.dart';

class ShippingTabScreen extends StatefulWidget {
  @override
  State<ShippingTabScreen> createState() => _ShippingTabScreenState();
}

class _ShippingTabScreenState extends State<ShippingTabScreen>
    with AutomaticKeepAliveClientMixin {
  bool? _chargeShipping = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Charge Shipping',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value;
              _product_provider.getFormData(chargeShipping: _chargeShipping);
            });
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormGlobal(
              text: 'Shipping charge',
              textInputType: TextInputType.number,
              context: context,
              onChanged: (value) {
                _product_provider.getFormData(shippingCharge: int.parse(value));
                return null;
              },
            ),
          )
      ],
    );
  }
}
