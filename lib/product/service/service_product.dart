import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plavon/product/service/data.dart';

class ServiceProduct {
  Future<List<Data>> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('https://plavon.dlhcode.com/api/barang');
    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + token.toString(),
    });
    // print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }
}
