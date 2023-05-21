class Data {
  final String user_id;
  final String id;
  final String nama_barang;

  Data({required this.user_id, required this.id, required this.nama_barang});

  factory Data.fromJson(Map<String, dynamic> json) {
    // print(json['nama_barang']);
    return new Data(
      user_id: json['user_id'],
      id: json['id'],
      nama_barang: json['nama_barang'],
    );
  }
}
