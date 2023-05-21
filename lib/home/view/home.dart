import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:plavon/home/menu_page.dart';
import 'package:plavon/product/view/listProduct.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
      ),
      body: ListProduct(),

      //memberikan button garis tiga disebelah kiri appbar
      //jika ditekan akan menjalankan widget builddrawer
      drawer: MenuPage(),
    );
  }
}
