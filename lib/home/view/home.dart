import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:plavon/home/menu_page.dart';
import 'package:plavon/login/view/login.dart';
import 'package:plavon/product/view/listProduct.dart';
import 'package:http/http.dart' as http;
import 'package:plavon/profile/view/profile.dart';
import 'package:plavon/transaksi/view/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _client = http.Client();

  var _logoutUrl = Uri.parse('https://plavon.dlhcode.com/api/logout');

  Future Logout() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = preferences.getString('token');
      http.Response response = await _client.get(_logoutUrl, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer " + token.toString(),
      });
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        setState(() {
          preferences.remove("email");
          preferences.remove("id_user");
          preferences.remove("is_login");
          preferences.remove("token");
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (route) => false,
        );
        // Navigator.of(context).pop();
      }
    } catch (e) {
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
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ListProduct(),
      transaksiPage(),
      ProfilePage()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              _showMyDialog('Log Out', 'Are you sure you want to logout?', 'No',
                  'Yes', () async {}, false);

              // ignore: unused_label
              child:
              Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              );
            },
          )
        ],
        centerTitle: true,
      ),
      body: Center(
          child: _widgetOptions.elementAt(
            _selectedIndex,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),

      //memberikan button garis tiga disebelah kiri appbar
      //jika ditekan akan menjalankan widget builddrawer
      // drawer: MenuPage(),
    );
  }
}
