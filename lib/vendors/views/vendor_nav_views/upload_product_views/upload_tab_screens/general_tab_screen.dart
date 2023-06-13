import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/widgets/dropdown_form_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/provider/product_provider.dart';

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

  _getCategories() {
    _firestore
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (mounted) {
        querySnapshot.docs.forEach((element) {
          setState(() {
            _categoryList.add(element['categoryName']);
          });
        });
      }
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
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
              SizedBox(
                height: 10,
              ),
              TextFormGlobal(
                text: 'Product Name',
                textInputType: TextInputType.text,
                labelText: 'Product Name',
                context: context,
                onChanged: (value) {
                  _product_provider.saveFormData(productName: value);
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormGlobal(
                text: 'Product Price',
                textInputType: TextInputType.number,
                labelText: 'Product Price',
                context: context,
                onChanged: (value) {
                  _product_provider.saveFormData(
                      productPrice: double.parse(value));
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownFormGlobal(
                  text: 'Category',
                  labelText: 'Category',
                  onChanged: (value) {
                    setState(() {
                      _product_provider.saveFormData(
                          category: value.toString());
                    });
                    return null;
                  },
                  context: context,
                  listData: _categoryList),
              SizedBox(
                height: 20,
              ),
              TextFormGlobal(
                text: 'Product Description',
                textInputType: TextInputType.multiline,
                labelText: 'Product Description',
                context: context,
                onChanged: (value) {
                  _product_provider.saveFormData(productDescription: value);
                  return null;
                },
                maxLines: 6,
                maxLength: 800,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
