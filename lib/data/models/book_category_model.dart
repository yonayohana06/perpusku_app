class BookCategoryModel {
  final String id;
  final String jenisBuku;
  final String deskripsi;
  final String updatedAt;

  BookCategoryModel({
    required this.id,
    required this.jenisBuku,
    required this.deskripsi,
    required this.updatedAt,
  });

  factory BookCategoryModel.fromJson(Map<String, dynamic> json) {
    return BookCategoryModel(
      id: json['id'] ?? '',
      jenisBuku: json['jenis_buku'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
