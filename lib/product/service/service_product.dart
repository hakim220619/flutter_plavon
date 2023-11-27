import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plavon/cart/cartPage.dart';
import 'package:plavon/home/view/home.dart';
// ignore: unused_import
import 'package:plavon/pay/view/pay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plavon/product/service/data.dart';

class ServiceProduct {
  static final _pesanmidtransUrl =
      Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');

  Future<List<Data>> fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    var url = Uri.parse('https://plavon.dlhcode.com/api/barang');
    final response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });
    // print(response.body);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  static final _pesanUrl =
      Uri.parse("https://plavon.dlhcode.com/api/tambah_pemesanan");

  static pesan(id, jumlah, harga, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString('id_user');
    var token = prefs.getString('token');
    // print(id);
    // print(jumlah);
    // print(harga);
    // print(id_user);

    Random objectname = Random();
    int number = objectname.nextInt(10000000);
    String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
    String password = '';
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    http.Response responseMidtrans = await http.post(_pesanmidtransUrl,
        headers: <String, String>{
          'authorization': basicAuth,
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'transaction_details': {'order_id': number, 'gross_amount': harga},
          "credit_card": {"secure": true}
        }));
    var jsonMidtrans = jsonDecode(responseMidtrans.body.toString());
    // print(jsonMidtrans['redirect_url']);

    http.Response response = await http.post(_pesanUrl, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      "id_user": idUser.toString(),
      "id_barang": id.toString(),
      "jumlah": jumlah.toString(),
      "harga": harga.toString(),
      "status": "belum bayar",
      "order_id": number.toString(),
      "redirect_url": jsonMidtrans['redirect_url'].toString(),
    });
    // print(response.body);
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      var json = jsonDecode(response.body.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                const HomePage()),
        (route) => false,
      );
    }
  }

  static final _pesanUrlCart =
      Uri.parse("https://plavon.dlhcode.com/api/cart");
  // static final _pesanUrlCart =
  //     Uri.parse("http://127.0.0.1:8000/api/cart");

  static cart(id, jumlah, context) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString('id_user');
    var token = prefs.getString('token');
    http.Response response = await http.post(_pesanUrlCart, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      "id_user": idUser.toString(),
      "id_barang": id.toString(),
      "jumlah": jumlah.toString(),
    });
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                const HomePage()),
        (route) => false,
      );
    }
  }
  static final _pesanUrlSend =
      Uri.parse("https://plavon.dlhcode.com/api/SendPesan");
  // static final _pesanUrlSend =
  //     Uri.parse("http://127.0.0.1:8000/api/sendPesan");

  // ignore: non_constant_identifier_names
  static SendPesan(id_user, context) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var idUser = prefs.getString('id_user');
    var token = prefs.getString('token');
    http.Response response = await http.post(_pesanUrlSend, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      "id_user": idUser.toString(),
    });
    
    // print(response.body);
    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (
          context,
        ) =>
                const HomePage()),
        (route) => false,
      );
    }
  }
}
