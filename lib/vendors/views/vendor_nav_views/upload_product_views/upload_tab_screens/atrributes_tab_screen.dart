import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/provider/product_provider.dart';

class AttributesTabScreen extends StatefulWidget {
  @override
  State<AttributesTabScreen> createState() => _AttributesTabScreenState();
}

class _AttributesTabScreenState extends State<AttributesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _entered = false;
  final TextEditingController _sizeController = TextEditingController();

  List<String> _sizeList = []; // to store the size list

  void _deleteSize(int index) {
    setState(() {
      _sizeList.removeAt(index);
    });
  }

  String? validatorFormField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'This $fieldName is required';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextFormField(
            validator: (value) => validatorFormField(value, 'Brand'),
            onChanged: (value) {
              _product_provider.getFormData(brandName: value);
            },
            decoration: InputDecoration(labelText: 'Brand'),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  width: 100,
                  child: TextFormField(
                    // key: GlobalKey(),
                    // validator: (value) => validatorFormField(value, 'Size'),
                    controller: _sizeController,
                    onChanged: (value) {
                      setState(() {
                        _entered = true;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Size'),
                  ),
                ),
              ),
              _entered == true
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade900),
                      onPressed: () {
                        setState(() {
                          _sizeList.add(_sizeController.text);
                          _sizeController
                              .clear(); //clear input after press the button
                          _product_provider.getFormData(sizeList: _sizeList);
                        });
                      },
                      child: Text('Add'),
                    )
                  : Text(''),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          if (_sizeList.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                //harus di wrap dengan container agar bisa jalan tanpa error
                scrollDirection: Axis.horizontal,
                itemCount: _sizeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _deleteSize(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _sizeList[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
