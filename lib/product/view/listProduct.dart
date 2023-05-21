import 'package:flutter/material.dart';
import 'package:plavon/home/view/home.dart';
// import 'package:plavon/product/service/service_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ListProduct extends StatefulWidget {
  const ListProduct({super.key});

  @override
  State<ListProduct> createState() => _ListProductState();
}

// class Data {
//   final String user_id;
//   final String id;
//   final String nama_barang;

//   Data({required this.user_id, required this.id, required this.nama_barang});

//   factory Data.fromJson(Map<String, dynamic> json) {
//     // print(json['nama_barang']);
//     return Data(
//       user_id: json['user_id'],
//       id: json['id'],
//       nama_barang: json['nama_barang'],
//     );
//   }
// }
String _jsonString =
    '{ "count": 7, "result": [ { "iconId": 1, "id": 1, "name": "Kitchen", "timestamp": 1586951631 }, { "iconId": 2, "id": 2, "name": "android", "timestamp": 1586951646 }, { "iconId": 3, "id": 3, "name": "mobile", "timestamp": 1586951654 }, { "iconId": 4, "id": 4, "name": "bathroom", "timestamp": 1586951665 }, { "iconId": 5, "id": 5, "name": "parking", "timestamp": 1586974393 }, { "iconId": 6, "id": 6, "name": "theatre", "timestamp": 1586974429 }, { "iconId": 7, "id": 7, "name": "bedroom", "timestamp": 1586974457 } ] }';

Future<String> _getDataFromWeb() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  var url = Uri.parse('https://plavon.dlhcode.com/api/barang');
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer " + token.toString(),
  });

  if (response.statusCode == 200) {
    // If you are sure that your web service has json string, return it directly
    return response.body;
  } else {
    // create a fake response against any stuation that the data couldn't fetch from the web
    return '{ "count": 7, "result": []}';
  }
}

// String json = "https://plavon.dlhcode.com/api/barang";
// Future<String> fetchData() async {
//   try {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     var token = preferences.getString('token');
//     var url = Uri.parse('https://plavon.dlhcode.com/api/barang');
//     final response = await http.get(url, headers: {
//       "Accept": "application/json",
//       "Authorization": "Bearer " + token.toString(),
//     });
//     // print(response.body);
//     if (response.statusCode == 200) {
//       return response.body;
//       // setState(() {
//       //   _get = data;
//       //   print(_get);
//       // });
//     }
//   } catch (e) {
//     print(e);
//   }
// }

// @override
// void initState() {
//   super.initState();
//   fetchData();
// }

class _ListProductState extends State<ListProduct> {
  List _get = [];
  Future search() async {
    try {
      // print({widget.fromAgentValue});
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      var url = Uri.parse('https://plavon.dlhcode.com/api/barang');
      final response = await http.get(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);
        setState(() {
          _get = data['data'];
          // print(_get);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future refresh() async {
    setState(() {
      search();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: _get.length, // <-- required
            itemBuilder: (_, i) => Container(
              margin: const EdgeInsets.all(5),
              color: Colors.grey,
              child: Center(child: Text('${_get[i]['nama_barang']}')),
            ),
          ),
        ),
      ),
    );
  }
}
