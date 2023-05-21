import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plavon/home/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  static final _client = http.Client();

  static var _loginUrl = Uri.parse('https://plavon.dlhcode.com/api/login');
  static login(email, password, context) async {
    // bool isLoading = false;
    http.Response response = await _client
        .post(_loginUrl, body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      var Users = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("email", email);
      await pref.setString("token", Users['data']);
      await pref.setBool("is_login", true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
        (route) => false,
      );
    }
  }
}
