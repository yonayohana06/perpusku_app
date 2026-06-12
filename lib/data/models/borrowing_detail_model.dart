class BorrowingDetailModel {
  final String id;
  final AnggotaModel anggota;
  final String tglPinjam;
  final String tglHrsKembali;
  final String jaminan;
  final List<DetailItemModel> details;
  final String createdAt;
  final String updatedAt;

  BorrowingDetailModel({
    required this.id,
    required this.anggota,
    required this.tglPinjam,
    required this.tglHrsKembali,
    required this.jaminan,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BorrowingDetailModel.fromJson(Map<String, dynamic> json) {
    return BorrowingDetailModel(
      id: json['id'] ?? '',
      // Parsing nested object "anggota"
      anggota: AnggotaModel.fromJson(json['anggota'] ?? {}),
      tglPinjam: json['tgl_pinjam'] ?? '',
      tglHrsKembali: json['tgl_hrs_kembali'] ?? '',
      jaminan: json['jaminan'] ?? '-',
      // Parsing nested array "details"
      details: json['details'] != null
          ? (json['details'] as List)
                .map((i) => DetailItemModel.fromJson(i))
                .toList()
          : [],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class AnggotaModel {
  final String idAnggota;
  final String nama;

  AnggotaModel({required this.idAnggota, required this.nama});

  factory AnggotaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaModel(
      idAnggota: json['id_anggota'] ?? '-',
      nama: json['nama'] ?? 'Tanpa Nama',
    );
  }
}

class DetailItemModel {
  final String idDetailPinjam;
  final String idBuku;
  final String kondisi;

  DetailItemModel({
    required this.idDetailPinjam,
    required this.idBuku,
    required this.kondisi,
  });

  factory DetailItemModel.fromJson(Map<String, dynamic> json) {
    return DetailItemModel(
      idDetailPinjam: json['id_detailpinjam'] ?? '',
      idBuku: json['id_buku'] ?? '',
      kondisi: json['kondisi'] ?? 'Baik',
    );
  }
}
