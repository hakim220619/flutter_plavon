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
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

// ignore: camel_case_types
class transaksiPage extends StatefulWidget {
  final String order_id;
  const transaksiPage({
    Key? key,
    required this.order_id,
    // ignore: non_constant_identifier_names
   
  }) : super(key: key);

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
          'https://plavon.eastbluetechnology.com/api/get_pemesanan_by_id/${widget.order_id}');
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
            var updateTransaksi = Uri.parse(
                'https://plavon.eastbluetechnology.com/api/updateTransaksi');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ), body:
          SizedBox(
            height: 400,
            width: 800.0,
            child: RefreshIndicator(
              onRefresh: refresh,
              child: SizedBox(
              height: 350,
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
                            leading: const CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 200, 194, 212),
                                child: Text("\$")),
                            title: Text(
                              " ${_get[index]['nama_barang']}",
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "${_get[index]['jumlah']} x ${_get[index]['harga']}",
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Text(
                                '      Harga: \n Rp. ${formatter.format(int.parse(_get[index]['harga'].toString()))}'),
                            
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
            // const SizedBox(height: 20,)
          ),
         
        
    );
  }
}
