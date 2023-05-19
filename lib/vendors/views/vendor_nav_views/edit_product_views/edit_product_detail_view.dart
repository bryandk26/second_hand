import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';

class EditProductDetailView extends StatefulWidget {
  final dynamic productData;

  const EditProductDetailView({super.key, required this.productData});

  @override
  State<EditProductDetailView> createState() => _EditProductDetailViewState();
}

class _EditProductDetailViewState extends State<EditProductDetailView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _detailSizeController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      _productNameController.text = widget.productData['productName'];
      _brandNameController.text = widget.productData['brandName'];
      _productPriceController.text =
          widget.productData['productPrice'].toString();
      _productDescriptionController.text =
          widget.productData['productDescription'];
      _categoryNameController.text = widget.productData['category'];
      _detailSizeController.text = widget.productData['size'];
    });
    super.initState();
  }

  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    EasyLoading.show(status: 'Updating product...');
    final Map<String, dynamic> updatedData = {
      'productName': _productNameController.text,
      'brandName': _brandNameController.text,
      'productDescription': _productDescriptionController.text,
      'category': _categoryNameController.text,
      'size': _detailSizeController.text,
    };
    if (_productPriceController.text.isNotEmpty) {
      updatedData['productPrice'] = double.parse(_productPriceController.text);
    }

    await _firestore
        .collection('products')
        .doc(widget.productData['productId'])
        .update(updatedData);

    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  double? productPrice;
  int? productQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: blackColor),
        title: Text(
          widget.productData['productName'],
          style: subTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(28.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Product Name',
                  controller: _productNameController,
                  textInputType: TextInputType.text,
                  context: context,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Brand Name',
                  controller: _brandNameController,
                  textInputType: TextInputType.text,
                  context: context,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  enabled: false,
                  text: 'Category',
                  controller: _categoryNameController,
                  textInputType: TextInputType.text,
                  context: context,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Price',
                  controller: _productPriceController,
                  textInputType: TextInputType.number,
                  context: context,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text:
                      'Detail Size\n\nEx:\nChest: 39 cm\nWaist: 37 cm\nSleeves: 24 cm\nShoulder: 18 cm\nLength: 29 cm',
                  controller: _detailSizeController,
                  textInputType: TextInputType.multiline,
                  context: context,
                  maxLines: 8,
                  maxLength: 800,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Product Description',
                  controller: _productDescriptionController,
                  textInputType: TextInputType.multiline,
                  context: context,
                  maxLength: 800,
                  maxLines: 6,
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            _updateProduct();
          },
          child: ButtonGlobal(isLoading: _isLoading, text: 'Update Product'),
        ),
      ),
    );
  }
}
