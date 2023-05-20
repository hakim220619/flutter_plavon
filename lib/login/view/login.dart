
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:plavon/login/service/service_page.dart';
import 'package:plavon/login/widget/login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailEditController = TextEditingController();
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  static const IconData directions_car =
      IconData(0xe1d7, fontFamily: 'MaterialIcons');

  @override
  bool _passwordVisible = false;
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 200,
          ),
          // Container(
          //   padding: const EdgeInsets.all(10),
          //   child: Center(
          //     child: Image.asset(
          //       'assets/images/logo.png',
          //       height: 100,
          //     ),
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextFormField(
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              maxLines: 1,
              keyboardType: TextInputType.text,
              controller: emailEditController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Masukan Email',
                  hintText: 'Masukan Email'),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              maxLines: 1,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _passwordVisible = _passwordVisible ? false : true;
                      });
                    },
                    child: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Masukan Password',
                  hintText: 'Masukan Password'),
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                HttpService.login(email, password, context);
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(150, 15, 150, 15),
            ),
            child: const Text(
              'Masuk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          // LoginWidget()
        ],
      ),
    );
  }
}
