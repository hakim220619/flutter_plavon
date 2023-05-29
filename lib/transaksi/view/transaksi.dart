import 'package:flutter/material.dart';
import 'package:plavon/home/menu_page.dart';
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
        var id_user = preferences.getString('id_user');
        var token = preferences.getString('token');
        var _riwayatTiket = Uri.parse(
            'https://plavon.dlhcode.com/api/get_pemesanan_by_id/${id_user.toString()}');
        http.Response response = await http.get(_riwayatTiket, headers: {
          "Accept": "application/json",
          "Authorization": "Bearer " + token.toString(),
        });
        // print(id_user);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          setState(() {
            _get = data['data'];
            // print(_get);
          });
          // var _orderid =
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
                        _get[index]['nama_barang'].toString() +
                        ' | ' +
                        _get[index]['jenis'].toString(),
                    style: new TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _get[index]['status'].toString() +
                        " | "
                            "Tgl " +
                        _get[index]['created_at'].toString(),
                    maxLines: 2,
                    style: new TextStyle(fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(_get[index]['jumlah'].toString()),
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
        drawer: MenuPage(),
      ),
    );
  }
}
