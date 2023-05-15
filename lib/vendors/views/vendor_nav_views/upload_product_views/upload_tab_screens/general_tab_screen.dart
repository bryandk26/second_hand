import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/widgets/dropdown_form_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
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
              TextFormGlobal(
                text: 'Product Name',
                textInputType: TextInputType.text,
                context: context,
                onChanged: (value) {
                  _product_provider.getFormData(productName: value);
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormGlobal(
                text: 'Product Price',
                textInputType: TextInputType.number,
                context: context,
                onChanged: (value) {
                  _product_provider.getFormData(
                      productPrice: double.parse(value));
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownFormGlobal(
                  text: 'Category',
                  onChanged: (value) {
                    setState(() {
                      _product_provider.getFormData(category: value.toString());
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
                textInputType: TextInputType.text,
                context: context,
                onChanged: (value) {
                  _product_provider.getFormData(productDescription: value);
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
