import 'package:flutter/material.dart';
import 'package:plavon/cart/cartPage.dart';
import 'package:plavon/login/view/login.dart';
import 'package:plavon/product/view/listProduct.dart';
import 'package:http/http.dart' as http;
import 'package:plavon/profile/view/profile.dart';
import 'package:plavon/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _client = http.Client();

  final _logoutUrl = Uri.parse('https://plavon.eastbluetechnology.com/api/logout');

  // ignore: non_constant_identifier_names
  Future Logout() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client.get(_logoutUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("email");
          preferences.remove("id_user");
          preferences.remove("is_login");
          preferences.remove("token");
        });

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (route) => false,
        );
        // Navigator.of(context).pop();
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

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
                Logout();
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
          ],
        );
      },
    );
  }
int _selectedIndex = 0;
void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      
    });
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      const ListProduct(),
      const CartPage(),
      const transaksiPage(),
      const ProfilePage()
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Plavon", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white,),
            onPressed: () {
              _showMyDialog('Log Out', 'Are you sure you want to logout?', 'No',
                  'Yes', () async {}, false);

              // ignore: unused_label
              child:
              const Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              );
            },
          )
        ],
        centerTitle: true,
      ),
      body: Center(
          child: widgetOptions.elementAt(
            _selectedIndex,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop_2),
              label: 'Cart',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Riwayat',
              backgroundColor: Colors.blue
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Profile',
              backgroundColor: Colors.blue
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          onTap: _onItemTapped,
        ),

      //memberikan button garis tiga disebelah kiri appbar
      //jika ditekan akan menjalankan widget builddrawer
      // drawer: MenuPage(),
    );
  }
}
