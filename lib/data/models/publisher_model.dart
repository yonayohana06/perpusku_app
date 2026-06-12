class PublisherModel {
  final String id;
  final String penerbitBuku;
  final String alamatPenerbit;
  final String telpPenerbit;
  final String emailPenerbit;
  final String deskripsi;
  final String updatedAt;

  PublisherModel({
    required this.id,
    required this.penerbitBuku,
    required this.alamatPenerbit,
    required this.telpPenerbit,
    required this.emailPenerbit,
    required this.deskripsi,
    required this.updatedAt,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'] ?? '',
      penerbitBuku: json['penerbit_buku'] ?? '',
      alamatPenerbit: json['alamat_penerbit'] ?? '',
      telpPenerbit: json['telp_penerbit'] ?? '',
      emailPenerbit: json['email_penerbit'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
