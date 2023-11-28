import 'package:flutter/material.dart';
import 'package:plavon/product/service/service_product.dart';

class DetailProduct extends StatefulWidget {
  final String id;
  // ignore: non_constant_identifier_names
  final String user_id;
  // ignore: non_constant_identifier_names
  final String nama_barang;
  final String jenis;
  final String stok;
  final String harga;
  final String ukuran;
  final String image;
  final String deskripsi;
  const DetailProduct(
      {Key? key,
      required this.id,
      // ignore: non_constant_identifier_names
      required this.user_id,
      // ignore: non_constant_identifier_names
      required this.nama_barang,
      required this.jenis,
      required this.stok,
      required this.harga,
      required this.ukuran,
      required this.image,
      required this.deskripsi})
      : super(key: key);

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

late String jumlah;

class _DetailProductState extends State<DetailProduct> {
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
    Future<void> showMyDialog(String title, String text, String nobutton,
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
                  await ServiceProduct.cart(
                      widget.id.toString(), jumlah.toString(), context);
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
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'Detail Product',
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: AutofillHints.creditCardType),
                        ),
                        // Text('Berikut Merupakan Detail Product')
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 22.0),
                    child: Column(
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
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
                          initialValue: widget.jenis.toString(),
                          onChanged: (value) {
                            setState(() {
                              // ignore: unused_local_variable
                              String jenis = value;
                            });
                          },
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Masukan Keterangan",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Keterangan"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Keterangan Pembelian tidak boleh kosong";
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
                          controller: NamaBarang,
                          onChanged: (value) {
                            setState(() {
                              jumlah = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Masukan Jumlah Pembelian",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              labelText: "Jumlah"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Jumlah Pembelian tidak boleh kosong";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          showMyDialog(
                              'Detail Pesanan',
                              'Pesanan anda sudah benar?',
                              'No',
                              'Yes',
                              () async {},
                              false);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                          child: Text(
                            "Cart",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
