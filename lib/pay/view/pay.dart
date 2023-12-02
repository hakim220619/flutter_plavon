import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:plavon/home/view/home.dart';
import 'package:plavon/transaksi/view/transaksi.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PayPage extends StatefulWidget {
  const PayPage({
    Key? key,
    required this.id,
    required this.nama_barang,
    required this.harga,
    required this.status,
    required this.jenis,
    required this.jumlah,
    required this.redirect_url,
  }) : super(key: key);
  final String id;
  final String nama_barang;
  final String harga;
  final String status;
  final String jenis;
  final String jumlah;
  final String redirect_url;

  @override
  State<PayPage> createState() => _PayPageState();
}


class _PayPageState extends State<PayPage> {
    final _client = http.Client();

  Future Delete() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client.post(Uri.parse('https://plavon.dlhcode.com/api/delete_pemesanan/${widget.id.toString()}'), headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      });
      // print(response.statusCode);
      if (response.statusCode == 200) {

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const transaksiPage(),
          ),
          (route) => false,
        );
        // Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String title, String text, String nobutton,
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
    return Scaffold(
        
        body: Container(
      padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                child: Card(
                  color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                leading: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.nama_barang,
                  style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                leading: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.harga,
                  style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                leading: const Icon(
                      Icons.call,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.jenis,
                  style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                leading: const Icon(
                      Icons.payment,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.status,
                  style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Card(
                  color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                leading: const Icon(
                      Icons.numbers,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    title: Text(
                      widget.jumlah,
                  style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontFamily: "Source Sans Pro"),
                    ),
                  ),
                ),
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
                  child: const Text("Bayar Sekarang"),
                      onPressed: () async {
                        String url = widget.redirect_url;
                        var urllaunchable = await canLaunch(
                            url); //canLaunch is from url_launcher package
                        if (urllaunchable) {
                          await launch(
                              url); //launch is from url_launcher package to launch URL
                        } else {
                          print("URL can't be launched.");
                        }
                      },
                    )),
                    Center(
                        child: ElevatedButton(
                          
                  child: const Text("Delete"),
                      onPressed: () async {
                    _showMyDialog('Delete', 'Are you sure you want to Delet?',
                        'No',
                  'Yes', () async {}, false);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

