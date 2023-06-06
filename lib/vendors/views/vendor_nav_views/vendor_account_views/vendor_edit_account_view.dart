import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:second_chance/vendors/controllers/vendor_edit_profile_controller.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';

class VendorEditAccountView extends StatefulWidget {
  final dynamic vendorData;

  VendorEditAccountView({super.key, required this.vendorData});

  @override
  State<VendorEditAccountView> createState() => _VendorEditAccountViewState();
}

class _VendorEditAccountViewState extends State<VendorEditAccountView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VendorEditProfileController _controller = VendorEditProfileController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.initControllerData(widget.vendorData);
  }

  @override
  void dispose() {
    _controller.disposeControllers();
    super.dispose();
  }

  Future<void> _updateVendorProfile(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        await _controller.updateVendorProfile(widget.vendorData);
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorMainScreen(
                initialIndex: 4,
              ),
            ));
      } catch (error) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      displayDialog(
        context,
        'Please fields must not be empty',
        Icon(
          Icons.error,
          color: primaryColor,
          size: 60,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String storeImage = widget.vendorData.storeImage;
    if (storeImage.isEmpty) {
      storeImage =
          'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
    }

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
          'Edit Profile',
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
                Stack(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              storeImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: blackColor,
                            ),
                            child: IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                color: whiteColor,
                                size: 20,
                              ),
                              onPressed: () {
                                _controller.updateStoreImage(
                                    widget.vendorData.toJson(), (downloadUrl) {
                                  setState(() {
                                    widget.vendorData.storeImage = downloadUrl;
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Divider(),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Business Profile',
                          style: subTitle,
                        ),
                        SizedBox(height: 25),
                        TextFormGlobal(
                          text: 'Business Name',
                          textInputType: TextInputType.text,
                          labelText: 'Business Name',
                          context: context,
                          controller: _controller.businessNamecontroller,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormGlobal(
                          enabled: false,
                          text: 'Email',
                          textInputType: TextInputType.emailAddress,
                          labelText: 'Email',
                          context: context,
                          controller: _controller.emailController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormGlobal(
                          text: 'Phone Number',
                          textInputType: TextInputType.phone,
                          labelText: 'Phone Number',
                          context: context,
                          controller: _controller.phoneController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormGlobal(
                          text: 'Address',
                          textInputType: TextInputType.text,
                          labelText: 'Address',
                          context: context,
                          controller: _controller.addressController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormGlobal(
                          text: 'Postal Code',
                          textInputType: TextInputType.number,
                          labelText: 'Postal Code',
                          context: context,
                          controller: _controller.postalCodeController,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Bank Account',
                          style: subTitle,
                        ),
                        SizedBox(height: 25),
                        TextFormGlobal(
                          text: 'Bank Name',
                          textInputType: TextInputType.text,
                          labelText: 'Bank Name',
                          context: context,
                          controller: _controller.bankNameController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormGlobal(
                          text: 'Bank Account Name',
                          textInputType: TextInputType.emailAddress,
                          labelText: 'Bank Account Name',
                          context: context,
                          controller: _controller.bankAccountNameController,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormGlobal(
                          text: 'Bank Account Number',
                          textInputType: TextInputType.number,
                          labelText: 'Bank Account Number',
                          context: context,
                          controller: _controller.bankAccountNumberController,
                        ),
                      ],
                    ),
                  ),
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
          onTap: () async {
            await _updateVendorProfile(context);
          },
          child: ButtonGlobal(isLoading: _isLoading, text: 'Update Profile'),
        ),
      ),
    );
  }
}
