import 'package:flutter/material.dart';
import 'package:plavon/home/view/home.dart';
import 'package:plavon/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class transaksiPage extends StatefulWidget {
  const transaksiPage({super.key});

  @override
  State<transaksiPage> createState() => _transaksiPageState();
}

List _get = [];

class _transaksiPageState extends State<transaksiPage> {
  @override
  Widget build(BuildContext context) {
    Future riwayatTiket() async {
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var email = preferences.getString('email');
        var id_user = preferences.getInt('id_user');
        var _riwayatTiket =
            Uri.parse('https://plafon.dlhcode.com/api/pemesanan');
        http.Response response = await http.post(_riwayatTiket, body: {
          "email": email,
          "id_user": id_user.toString(),
        });
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          setState(() {
            _get = data['data'];
          });
          // var _orderid =
          //     Uri.parse('https://travel.dlhcode.com/api/cek_transaksi');
          // http.Response getOrderId = await http.post(_orderid, body: {
          //   "id_user": id_user.toString(),
          // });

          // if (getOrderId.statusCode == 200) {
          //   final dataOrderId = jsonDecode(getOrderId.body)['data'];
          //   // print(dataOrderId);
          //   for (var i = 0; i < dataOrderId.length; i++) {
          //     var orderId = dataOrderId[i]['order_id'];
          //     // print(i);
          //     String username = 'SB-Mid-server-z5T9WhivZDuXrJxC7w-civ_k';
          //     String password = '';
          //     String basicAuth =
          //         'Basic ' + base64Encode(utf8.encode('$username:$password'));
          //     http.Response responseTransaksi = await http.get(
          //       Uri.parse("https://api.sandbox.midtrans.com/v2/" +
          //           orderId +
          //           "/status"),
          //       headers: <String, String>{
          //         'authorization': basicAuth,
          //         'Content-Type': 'application/json'
          //       },
          //     );
          //     var jsonTransaksi = jsonDecode(responseTransaksi.body.toString());

          //     if (jsonTransaksi['status_code'] == '200') {
          //       var updateTransaksi =
          //           Uri.parse('https://travel.dlhcode.com/api/updateTransaksi');
          //       // ignore: unused_local_variable
          //       http.Response getOrderId =
          //           await http.post(updateTransaksi, body: {
          //         "order_id": orderId,
          //       });
          //       // print(jsonTransaksi['status_code']);
          //     }
          //   }
          // }
        }
      } catch (e) {
        print(e);
      }
    }

    Future refresh() async {
      setState(() {
        riwayatTiket();
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Transaksi"),
        ),
        body: Center(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              itemCount: _get.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(10),
                elevation: 8,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 48, 31, 83),
                    child: Icon(
                      Icons.directions_car,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Dari " +
                        _get[index]['asal'] +
                        ' | ' +
                        _get[index]['tujuan'],
                    style: new TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _get[index]['status'] +
                        " | "
                            "Tgl " +
                        _get[index]['created_at'].toString().substring(0, 10),
                    maxLines: 2,
                    style: new TextStyle(fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _get[index]['tgl_keberangkatan']
                        .toString()
                        .substring(10, 19),
                  ),
                  onTap: () {
                    if (_get[index]['status'] == 'lunas') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()
                            // TicketData(
                            //   order_id: _get[index]['order_id'].toString(),
                            //   nama: _get[index]['nama_pemesan'].toString(),
                            //   tanggal:
                            //       _get[index]['tgl_keberangkatan'].toString(),
                            //   email: _get[index]['email'].toString(),
                            //   no_hp: _get[index]['no_hp'].toString(),
                            //   status: _get[index]['status'].toString(),
                            // ),
                            ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()
                            //   payPage(
                            //       nama: _get[index]['nama_pemesan'].toString(),
                            //       email: _get[index]['email'].toString(),
                            //       no_hp: _get[index]['no_hp'].toString(),
                            //       status: _get[index]['status'].toString(),
                            //       redirect_url:
                            //           _get[index]['redirect_url'].toString()),
                            // ),
                            ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
