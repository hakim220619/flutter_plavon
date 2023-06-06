import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore: unused_import
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:plavon/login/service/service_page.dart';
// ignore: unused_import
import 'package:plavon/login/widget/login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

bool _passwordVisible = false;
final _formKey = GlobalKey<FormState>();

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailEditController = TextEditingController();
  late String email;
  late String password;

  // static const IconData directions_car =
  //     IconData(0xe1d7, fontFamily: 'MaterialIcons');
  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Center(
              child: Image.asset( 
                'assets/images/logo.png',
              ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
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
