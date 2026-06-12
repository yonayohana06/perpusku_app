class BorrowingModel {
  final String id;
  final String idAnggota;
  final String tglPinjam;
  final String tglHrsKembali;
  final String jaminan;

  BorrowingModel({
    required this.id,
    required this.idAnggota,
    required this.tglPinjam,
    required this.tglHrsKembali,
    required this.jaminan,
  });

  factory BorrowingModel.fromJson(Map<String, dynamic> json) {
    return BorrowingModel(
      id: json['id'] ?? '',
      idAnggota: json['id_anggota'] ?? 'Anonim',
      tglPinjam: json['tgl_pinjam'] ?? '',
      tglHrsKembali: json['tgl_hrs_kembali'] ?? '',
      jaminan: json['jaminan'] ?? '-',
    );
  }
}
