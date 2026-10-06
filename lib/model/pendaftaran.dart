class Pendaftaran {
  String id;
  String nomorAntrean;
  DateTime tanggal;
  String namaPasien;
  String nomorRm;
  String namaPoli;
  String namaDokter;
  String keluhan;
  String status; // "Menunggu", "Sedang Diperiksa", "Selesai"
  String? catatanDokter;

  Pendaftaran({
    required this.id,
    required this.nomorAntrean,
    required this.tanggal,
    required this.namaPasien,
    required this.nomorRm,
    required this.namaPoli,
    required this.namaDokter,
    required this.keluhan,
    this.status = "Menunggu",
    this.catatanDokter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomorAntrean': nomorAntrean,
      'tanggal': tanggal.toIso8601String(),
      'namaPasien': namaPasien,
      'nomorRm': nomorRm,
      'namaPoli': namaPoli,
      'namaDokter': namaDokter,
      'keluhan': keluhan,
      'status': status,
      'catatanDokter': catatanDokter,
    };
  }

  factory Pendaftaran.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(map['tanggal'] ?? '');
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return Pendaftaran(
      id: map['id'] ?? '',
      nomorAntrean: map['nomorAntrean'] ?? '',
      tanggal: parsedDate,
      namaPasien: map['namaPasien'] ?? '',
      nomorRm: map['nomorRm'] ?? '',
      namaPoli: map['namaPoli'] ?? '',
      namaDokter: map['namaDokter'] ?? '',
      keluhan: map['keluhan'] ?? '',
      status: map['status'] ?? 'Menunggu',
      catatanDokter: map['catatanDokter'],
    );
  }
}
