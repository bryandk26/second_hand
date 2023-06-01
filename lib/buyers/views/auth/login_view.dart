import 'package:flutter/material.dart';
import 'package:second_chance/buyers/controllers/auth_controller.dart';
import 'package:second_chance/buyers/views/auth/register_view.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/role_view.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);

      if (res == 'success') {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return RoleView();
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
                      email = value;
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormGlobal(
                    text: 'Password',
                    textInputType: TextInputType.text,
                    labelText: 'Password',
                    obsecure: true,
                    context: context,
                    onChanged: (value) {
                      password = value;
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
