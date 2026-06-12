class AuthorModel {
  final String id;
  final String penulisBuku;
  final String alamat;
  final String emailPenulis;
  final String deskripsi;
  final String updatedAt;

  AuthorModel({
    required this.id,
    required this.penulisBuku,
    required this.alamat,
    required this.emailPenulis,
    required this.deskripsi,
    required this.updatedAt,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] ?? '',
      penulisBuku: json['penulis_buku'] ?? '',
      alamat: json['alamat'] ?? '-',
      emailPenulis: json['email_penulis'] ?? '',
      deskripsi: json['deskripsi'] ?? '-',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
