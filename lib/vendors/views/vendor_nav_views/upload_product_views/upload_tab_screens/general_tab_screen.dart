import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/provider/product_provider.dart';
import 'package:intl/intl.dart';

class GeneralTabScreen extends StatefulWidget {
  @override
  State<GeneralTabScreen> createState() => _GeneralTabScreenState();
}

class _GeneralTabScreenState extends State<GeneralTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categoryList = [];

  String? validatorFormField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'This $fieldName is required';
    } else {
      return null;
    }
  }

  _getCategories() {
    _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        setState(() {
          _categoryList.add(element['categoryName']);
        });
      });
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  String formatedDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyy');

    final outputFormat = outputDateFormat.format(date);

    return outputFormat;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (value) => validatorFormField(value, 'Product Name'),
                onChanged: (value) {
                  _product_provider.getFormData(productName: value);
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Name',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) =>
                    validatorFormField(value, 'Product Price'),
                onChanged: (value) {
                  _product_provider.getFormData(
                      productPrice: double.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Price',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) =>
                    validatorFormField(value, 'Product Quantity'),
                onChanged: (value) {
                  _product_provider.getFormData(quantity: int.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Quantity',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                validator: (value) => validatorFormField(value, 'Category'),
                hint: Text('Select Category'),
                items: _categoryList.map<DropdownMenuItem<String>>(
                  (e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _product_provider.getFormData(category: value);
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) =>
                    validatorFormField(value, 'Product Description'),
                maxLines: 6,
                maxLength: 800,
                onChanged: (value) {
                  _product_provider.getFormData(productDescription: value);
                },
                decoration: InputDecoration(
                  labelText: 'Enter Product Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(5000),
                      ).then(
                        (value) {
                          setState(() {
                            _product_provider.getFormData(scheduleDate: value);
                          });
                        },
                      );
                    },
                    child: Text('Schedule'),
                  ),
                  if (_product_provider.productData['scheduleDate'] != null)
                    Text(
                      formatedDate(
                        _product_provider.productData['scheduleDate'],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
