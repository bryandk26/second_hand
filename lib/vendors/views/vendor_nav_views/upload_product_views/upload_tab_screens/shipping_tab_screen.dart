import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/provider/product_provider.dart';

class ShippingTabScreen extends StatefulWidget {
  @override
  State<ShippingTabScreen> createState() => _ShippingTabScreenState();
}

class _ShippingTabScreenState extends State<ShippingTabScreen>
    with AutomaticKeepAliveClientMixin {
  // change the line here to
  bool? _chargeShipping = false;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    String? validatorFormField(String? value, String fieldName) {
      if (value == null || value.isEmpty) {
        return 'This $fieldName is required';
      } else {
        return null;
      }
    }

    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Charge Shipping',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
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
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) =>
                  validatorFormField(value, 'Shipping charge'),
              onChanged: (value) {
                _product_provider.getFormData(shippingCharge: int.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Shipping charge'),
            ),
          )
      ],
    );
  }
}
