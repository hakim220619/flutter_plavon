import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:plavon/cart/cartDetail.dart';
import 'package:plavon/home/menu_page.dart';
// ignore: unused_import
import 'package:plavon/home/view/home.dart';
import 'package:plavon/product/service/service_product.dart';
// ignore: unused_import
import 'package:plavon/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// ignore: camel_case_types
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

List _get = [];

// ignore: camel_case_types
class _CartPageState extends State<CartPage> {
  // ignore: non_constant_identifier_names
  String id_user = '';
  String total = '';
  Future riwayatTiket() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var idUser = preferences.getString('id_user');
      var token = preferences.getString('token');
      var riwayatTiket = Uri.parse(
          'https://plavon.dlhcode.com/api/getCart/${idUser.toString()}');
      http.Response response = await http.get(riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(id_user);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data['data'];
          id_user = data['data'][0]['id_user'];
        });
        // print(_get[0]['order_id']);

        // print(data);
        for (var i = 0; i < data['data'].length; i++) {
          var orderId = data['data'][i]['order_id'];
          // print(orderId);
          String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
          String password = '';
          String basicAuth =
              'Basic ${base64Encode(utf8.encode('$username:$password'))}';
          http.Response responseTransaksi = await http.get(
            Uri.parse(
                // ignore: prefer_interpolation_to_compose_strings
                "https://api.sandbox.midtrans.com/v2/" + orderId + "/status"),
            headers: <String, String>{
              'authorization': basicAuth,
              'Content-Type': 'application/json'
            },
          );
          var jsonTransaksi = jsonDecode(responseTransaksi.body.toString());
          // print(jsonTransaksi);
          if (jsonTransaksi['status_code'] == '200') {
            var updateTransaksi =
                Uri.parse('https://plavon.dlhcode.com/api/updateTransaksi');
            // ignore: unused_local_variable
            http.Response getOrderId =
                await http.post(updateTransaksi, headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            }, body: {
              "order_id": orderId,
            });
            // print(getOrderId.body);
          }
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> showMyDialog(String title, String text, String nobutton,
      String yesbutton, Function onTap, bool isValue) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isValue,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("$text Dengan Total : $total"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(nobutton),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(yesbutton),
              onPressed: () async {
                await ServiceProduct.SendPesan(id_user, context);
              },
            ),
          ],
        );
      },
    );
  }

  Future cartTotal() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var riwayatTiket =
          Uri.parse('https://plavon.dlhcode.com/api/getTotalCart');
      http.Response response = await http.get(riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          total = data['data'];
          // print(total);
        });
        // print(_get[0]['order_id']);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future refresh() async {
    setState(() {
      riwayatTiket();
      cartTotal();
    });
  }

  @override
  void initState() {
    super.initState();
    riwayatTiket();
    cartTotal();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 450,
              child: Center(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    itemCount: _get.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(10),
                          elevation: 8,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 48, 31, 83),
                              child: Image.network(
                                _get[index]['image'] == ''
                                    ? 'https://plavon.dlhcode.com/storage/images/barang/plavon1.jpeg'
                                    : 'https://plavon.dlhcode.com/storage/images/barang/${_get[index]['image']}',
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              "Barang ${_get[index]['nama_barang']}",
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "Tgl ${_get[index]['created_at']}",
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(_get[index]['total'].toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartDetail(
                                    id: _get[index]['id'],
                                    nama_barang:
                                        _get[index]['nama_barang'].toString(),
                                    harga: _get[index]['harga'].toString(),
                                    jumlah: _get[index]['jumlah'].toString(),
                                    image: _get[index]['image'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Row(
              children: [
                Text(''),
                SizedBox(
                  width: 200,
                ),
              ],
            ),
            InkWell(
                onTap: () async {
                  showMyDialog('Detail Pesanan', 'Pesanan anda sudah benar?',
                      'No', 'Yes', () async {}, false);
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                    child: Text(
                      "Pesan",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
