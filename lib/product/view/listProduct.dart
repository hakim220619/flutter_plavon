// ignore: file_names
import 'package:flutter/material.dart';
import 'package:plavon/home/menu_page.dart';
// ignore: unused_import
import 'package:plavon/home/view/home.dart';
import 'package:plavon/product/view/product_detail.dart';
// import 'package:plavon/product/service/service_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  List _get = [];
  var formatter = NumberFormat('###,000');
  Future barang() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('https://plavon.eastbluetechnology.com/api/barang');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      // print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          _get = data['data'];
          // print(_get);
        });
      }
    } catch (e) {
      // print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    barang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: barang,
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: _get.length,
              itemBuilder: (_, i) => Card(
                    child: Container(
                      height: 290,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (
                                    context,
                                  ) =>
                                          DetailProduct(
                                            id: _get[i]['id'],
                                            user_id: _get[i]['user_id'],
                                            nama_barang: _get[i]['nama_barang'],
                                            jenis: _get[i]['jenis'],
                                            stok: _get[i]['stok'],
                                            harga: _get[i]['harga'],
                                            ukuran: _get[i]['ukuran'],
                                            image: _get[i]['image'],
                                            deskripsi: _get[i]['deskripsi'],
                                          )));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    _get[i]['image'] == '' ? 'https://plavon.eastbluetechnology.com/storage/images/barang/brg.jpeg' :
                                    'https://plavon.eastbluetechnology.com/storage/images/barang/${_get[i]['image']}',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text(
                                  '${_get[i]['nama_barang']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('Rp. ${formatter.format(int.parse(_get[i]['harga']))}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    
                                  ],
                                  
                                ),
                                Text('Ukuran: ${_get[i]['ukuran']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
      drawer: const MenuPage(),
    );
  }
}
// Container(
//               margin: const EdgeInsets.all(5),
//               color: Colors.grey,
//               child: Center(child: Text('${_get[i]['nama_barang']}')),
//             ),
