class FineModel {
  final String idDenda;
  final int jumlahDenda;
  final String tglPinjam;
  final String tglHrsKembali;
  final String tglKembali;
  final String idPeminjaman;
  final String idAnggota;
  final String createdAt;
  final String updatedAt;

  FineModel({
    required this.idDenda,
    required this.jumlahDenda,
    required this.tglPinjam,
    required this.tglHrsKembali,
    required this.tglKembali,
    required this.idPeminjaman,
    required this.idAnggota,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FineModel.fromJson(Map<String, dynamic> json) {
    return FineModel(
      idDenda: json['id_denda'] ?? '',
      jumlahDenda: json['jumlah_denda'] ?? 0,
      tglPinjam: json['tgl_pinjam'] ?? '',
      tglHrsKembali: json['tgl_hrs_kembali'] ?? '',
      tglKembali: json['tgl_kembali'] ?? '',
      idPeminjaman: json['id_peminjaman'] ?? '',
      idAnggota: json['id_anggota'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
