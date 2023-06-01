import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/controllers/vendor_register_controller.dart';

class VendorRegistrationScreen extends StatefulWidget {
  @override
  State<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState extends State<VendorRegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorController _vendorController = VendorController();

  late String businessName;
  late String email;
  late String phoneNumber;
  String address = '';
  String postalCode = '';
  String bankName = '';
  String bankAccountName = '';
  String bankAccountNumber = '';
  Uint8List? _image;

  bool _isLoading = false;

  selectGalleryImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  _saveVendorDetail() async {
    EasyLoading.show(status: 'Please Wait');
    if (_formKey.currentState!.validate()) {
      await _vendorController
          .registerVendor(
        businessName,
        email,
        phoneNumber,
        address,
        postalCode,
        bankName,
        bankAccountName,
        bankAccountNumber,
        _image,
      )
          .whenComplete(() {
        if (mounted) {
          setState(() {
            _formKey.currentState!.reset();
            _image = null;
          });
        }
        EasyLoading.dismiss();
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, blackColor],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _image != null
                                ? Image.memory(
                                    _image!,
                                    fit: BoxFit.cover,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      selectGalleryImage();
                                    },
                                    icon: Icon(CupertinoIcons.photo),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormGlobal(
                      text: 'Business Name',
                      textInputType: TextInputType.name,
                      context: context,
                      onChanged: (value) {
                        businessName = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Email Address',
                      textInputType: TextInputType.emailAddress,
                      context: context,
                      onChanged: (value) {
                        email = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Phone Number',
                      textInputType: TextInputType.phone,
                      context: context,
                      onChanged: (value) {
                        phoneNumber = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Address',
                      textInputType: TextInputType.text,
                      context: context,
                      onChanged: (value) {
                        address = value;
                        return null;
                      },
                      maxLength: 200,
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Postal Code',
                      textInputType: TextInputType.number,
                      context: context,
                      onChanged: (value) {
                        postalCode = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Bank Name',
                      textInputType: TextInputType.text,
                      context: context,
                      onChanged: (value) {
                        bankName = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Bank Account Name',
                      textInputType: TextInputType.text,
                      context: context,
                      onChanged: (value) {
                        bankAccountName = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormGlobal(
                      text: 'Bank Account Number',
                      textInputType: TextInputType.number,
                      context: context,
                      onChanged: (value) {
                        bankAccountNumber = value;
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        _saveVendorDetail();
                      },
                      child: ButtonGlobal(isLoading: _isLoading, text: 'Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
