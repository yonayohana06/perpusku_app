class BookModel {
  final String idBuku;
  final String isbn;
  final String idKategoriBuku;
  final String judulBuku;
  final String idPenulisBuku;
  final String idPenerbitBuku;
  final String tahunTerbit;
  final int stokBuku;
  final String rakBuku;
  final String deskripsiBuku;
  final String? gambarBuku;
  final String? kondisiBuku;

  BookModel({
    required this.idBuku,
    required this.isbn,
    required this.idKategoriBuku,
    required this.judulBuku,
    required this.idPenulisBuku,
    required this.idPenerbitBuku,
    required this.tahunTerbit,
    required this.stokBuku,
    required this.rakBuku,
    required this.deskripsiBuku,
    this.gambarBuku,
    this.kondisiBuku,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      idBuku: json['id_buku'] ?? '',
      isbn: json['isbn'] ?? '',
      idKategoriBuku: json['id_kategori_buku'] ?? '',
      judulBuku: json['judul_buku'] ?? 'Tanpa Judul',
      idPenulisBuku: json['id_penulis_buku'] ?? '',
      idPenerbitBuku: json['id_penerbit_buku'] ?? '',
      tahunTerbit: json['tahun_terbit'] ?? '-',
      stokBuku: json['stok_buku'] ?? 0,
      rakBuku: json['rak_buku'] ?? '-',
      deskripsiBuku: json['deskripsi_buku'] ?? '',
      gambarBuku: json['gambar_buku'],
      kondisiBuku: json['kondisi_buku'],
    );
  }
}
