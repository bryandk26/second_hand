import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
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
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';
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
        countryValue,
        stateValue,
        cityValue,
        _image,
      )
          .whenComplete(() {
        EasyLoading.dismiss();

        setState(() {
          _formKey.currentState!.reset();
          _image = null;
        });
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
                //means height and widht
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
                    TextFormField(
                      onChanged: (value) {
                        businessName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Business Name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Business Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Email Address must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Phone Number must not be empty';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CSCPicker(
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 3),
                      ),
                      disabledDropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey.shade300,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 3),
                      ),
                      onCountryChanged: (value) {
                        setState(() {
                          countryValue = value.toString();
                        });
                      },
                      onStateChanged: (value) {
                        setState(() {
                          stateValue = value.toString();
                        });
                      },
                      onCityChanged: (value) {
                        setState(() {
                          cityValue = value.toString();
                        });
                      },
                    ),
                    // SelectState(
                    //   onCountryChanged: (value) {
                    //     setState(() {
                    //       countryValue = value;
                    //     });
                    //   },
                    //   onStateChanged: (value) {
                    //     setState(() {
                    //       stateValue = value;
                    //     });
                    //   },
                    //   onCityChanged: (value) {
                    //     setState(() {
                    //       cityValue = value;
                    //     });
                    //   },
                    // ),
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
