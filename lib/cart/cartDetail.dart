import 'package:flutter/material.dart';
import 'package:plavon/cart/cartPage.dart';
import 'package:plavon/home/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartDetail extends StatefulWidget {
  final String id;
  // ignore: non_constant_identifier_names
  final String nama_barang;
  final String jumlah;
  final String harga;
  final String image;
  const CartDetail({
    Key? key,
    required this.id,
    // ignore: non_constant_identifier_names
    required this.nama_barang,
    required this.jumlah,
    required this.harga,
    required this.image,
  }) : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

late String jumlah;

class _CartDetailState extends State<CartDetail> {
  // ignore: non_constant_identifier_names
  TextEditingController NamaBarang = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  // TextEditingController Email = TextEditingController();
  // TextEditingController Nohp = TextEditingController();
  @override
  void dispose() {
    _formkey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    // ignore: non_constant_identifier_names
    Future Delete() async {
      try {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var token = preferences.getString('token');
        http.Response response = await client.get(
            Uri.parse(
                'https://plavon.dlhcode.com/api/delete_cart/${widget.id.toString()}'),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            });
        // print(response.body);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const CartPage(),
          ),
          (route) => false,
        );
        // Navigator.of(context).pop();
      } catch (e) {
        print(e);
      }
    }

    Future<void> showMyDialogDelete(String title, String text, String nobutton,
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
                  Text(text),
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
                  Delete();
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
            ],
          );
        },
      );
    }

    // ignore: unused_local_variable
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: SafeArea(
        child: Material(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              widget.image == ''
                                  ? 'https://plavon.dlhcode.com/storage/images/barang/plavon1.jpeg'
                                  : 'https://plavon.dlhcode.com/storage/images/barang/${widget.image.toString()}',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          initialValue: widget.nama_barang.toString(),
                          onChanged: (value) {
                            setState(() {
                              // ignore: unused_local_variable, non_constant_identifier_names
                              String nama_barang = value;
                            });
                          },
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Masukan Nama Paket",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Nama Paket"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Nama Paket Pembelian tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          initialValue: widget.harga.toString(),
                          onChanged: (value) {
                            setState(() {
                              // ignore: unused_local_variable
                              String harga = value;
                            });
                          },
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Masukan Harga",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Harga"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Harga Pembelian tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          initialValue: widget.jumlah.toString(),
                          onChanged: (value) {
                            setState(() {
                              // ignore: unused_local_variable
                              String jumlah = value;
                            });
                          },
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Jumlah",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Jumlah"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Jumlah";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.redAccent[50],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Center(
                                  child: ElevatedButton(
                                child: const Text("Delete"),
                                onPressed: () async {
                                  showMyDialogDelete(
                                      'Delete',
                                      'Are you sure you want to Delet?',
                                      'No',
                                      'Yes',
                                      () async {},
                                      false);
                                },
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
