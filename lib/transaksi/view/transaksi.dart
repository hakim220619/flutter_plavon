import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
// ignore: unused_import
import 'package:plavon/home/view/home.dart';
import 'package:plavon/pay/view/pay.dart';
// ignore: unused_import
import 'package:plavon/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class transaksiPage extends StatefulWidget {
  const transaksiPage({super.key});

  @override
  State<transaksiPage> createState() => _transaksiPageState();
}

List _get = [];
var formatter = NumberFormat('###,000');

// ignore: camel_case_types
class _transaksiPageState extends State<transaksiPage> {
  Future riwayatTiket() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var idUser = preferences.getString('id_user');
      var token = preferences.getString('token');
      var riwayatTiket = Uri.parse(
          'https://plavon.dlhcode.com/api/get_pemesanan_by_id/${idUser.toString()}');
      http.Response response = await http.get(riwayatTiket, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(id_user);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data['data'];
          // print(_get);
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

  Future refresh() async {
    setState(() {
      riwayatTiket();
    });
  }

  @override
  void initState() {
    super.initState();
    riwayatTiket();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: RefreshIndicator(
          onRefresh: refresh,
          child: GroupedListView<dynamic, String>(
            elements: _get,
            groupBy: (element) => element['order_id'],
            groupSeparatorBuilder: (String groupByValue) =>
                const Divider(height: 15),
            itemBuilder: (context, dynamic element) => Card(
              margin: const EdgeInsets.all(10),
              elevation: 8,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 48, 31, 83),
                  child: Image.network(
                    'https://plavon.dlhcode.com/storage/images/barang/${element['image']}',
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(
                  "Barang ${element['nama_barang']}",
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${element['status'] == '' ? element['status_barang'] : element['status']} | Tgl ${element['created_at']}",
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14.0),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                    formatter.format(int.parse(element['harga'].toString()))),
                onTap: () {
                  if (element['status'] == 'lunas') {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Status Pembayaran'),
                        content:
                            const Text('Selamat pembayaran anda telah lunas'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PayPage(
                          id: element['id'],
                          nama_barang: element['nama_barang'].toString(),
                          harga: element['harga'].toString(),
                          status: element['status_barang'].toString(),
                          jenis: element['jenis'].toString(),
                          jumlah: element['jumlah'].toString(),
                          redirect_url: element['redirect_url'].toString(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            itemComparator: (item1, item2) => item1['nama_barang']
                .compareTo(item2['nama_barang']), // optional
            useStickyGroupSeparators: true, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
          ),
        ),
      ),
    );
  }
}
