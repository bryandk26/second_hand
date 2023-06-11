import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/auth/authentication_wrapper.dart';
import 'package:second_chance/buyers/views/auth/register_view.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _email;
  late String _password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = 'something went wrong';

      try {
        if (_email.isNotEmpty && _password.isNotEmpty) {
          await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          res = 'success';
        } else {
          res = 'Please fields must not be empty';
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          res = 'No user found';
        } else if (e.code == 'wrong-password') {
          res = 'Wrong password';
        } else {
          res = e.message ?? 'Something went wrong';
        }
      } catch (e) {
        res = e.toString();
      }

      if (res == 'success') {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return AuthenticationWrapper();
            },
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
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
      setState(() {
        _isLoading = false;
      });
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    'Login to your account',
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
                    onTap: () {
                      _loginUsers();
                    },
                    child: ButtonGlobal(isLoading: _isLoading, text: 'Login'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Need An Account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RegisterView();
                          }));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
