import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/auth/login_view.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _email;
  late String _fullName;
  late String _phoneNumber;
  late String _password;

  bool _isLoading = false;

  _signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      String res = 'Some error occurred';

      try {
        if (_email.isNotEmpty &&
            _fullName.isNotEmpty &&
            _phoneNumber.isNotEmpty &&
            _password.isNotEmpty) {
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: _email,
            password: _password,
          );

          await _firestore.collection('buyers').doc(cred.user!.uid).set(
            {
              'email': _email,
              'fullName': _fullName,
              'phoneNumber': _phoneNumber,
              'buyerId': cred.user!.uid,
              'address': '',
              'postalCode': '',
              'bankName': '',
              'bankAccountName': '',
              'bankAccountNumber': '',
              'profileImage': '',
              'registeredDate': DateTime.now(),
            },
          );

          res = 'success';
        } else {
          res = 'Please fields must not be empty';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          res = 'The password is too weak.';
        } else if (e.code == 'email-already-in-use') {
          res = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          res = 'The email address is badly formatted';
        } else if (e.code == 'invalid-input') {
          res = 'Please fill all fields';
        } else {
          res = e.message ?? 'An error occurred while signing up';
        }
      } catch (e) {
        res = e.toString();
      }

      if (res == 'success') {
        setState(() {
          _formKey.currentState!.reset();
        });
        displayDialog(
          context,
          'Congratulations your account has been created!',
          Icon(
            Icons.check_circle_rounded,
            color: Colors.green.shade600,
            size: 60,
          ),
        );
      } else {
        displayDialog(
          context,
          res,
          Icon(
            Icons.error,
            color: Colors.red,
            size: 60,
          ),
        );
      }
    } else {
      displayDialog(
        context,
        'Please fields must not be empty',
        Icon(
          Icons.error,
          color: Colors.red,
          size: 60,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Text Only Without Background.png',
                    width: 125,
                    height: 125,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Create Customer's Account",
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormGlobal(
                    text: 'Full Name',
                    textInputType: TextInputType.text,
                    labelText: 'Full Name',
                    context: context,
                    onChanged: (value) {
                      _fullName = value;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormGlobal(
                    text: 'Email',
                    textInputType: TextInputType.emailAddress,
                    labelText: 'Email',
                    context: context,
                    onChanged: (value) {
                      _email = value;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormGlobal(
                    text: 'Phone Number',
                    textInputType: TextInputType.phone,
                    labelText: 'Phone Number',
                    context: context,
                    onChanged: (value) {
                      _phoneNumber = value;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormGlobal(
                    text: 'Password',
                    textInputType: TextInputType.text,
                    labelText: 'Password',
                    obsecure: true,
                    context: context,
                    onChanged: (value) {
                      _password = value;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => _signUpUser(),
                    child:
                        ButtonGlobal(isLoading: _isLoading, text: 'Register'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already Have An Account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginView();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
