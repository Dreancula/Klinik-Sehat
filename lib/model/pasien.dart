class Pasien {
  int? id;
  String nomorRm;
  String nama;
  String tanggalLahir;
  String nomorTelepon;
  String alamat;

  Pasien({
    this.id,
    required this.nomorRm,
    required this.nama,
    required this.tanggalLahir,
    required this.nomorTelepon,
    required this.alamat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomorRm': nomorRm,
      'nama': nama,
      'tanggalLahir': tanggalLahir,
      'nomorTelepon': nomorTelepon,
      'alamat': alamat,
    };
  }

  factory Pasien.fromMap(Map<String, dynamic> map) {
    return Pasien(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      nomorRm: map['nomorRm'] ?? '',
      nama: map['nama'] ?? '',
      tanggalLahir: map['tanggalLahir'] ?? '',
      nomorTelepon: map['nomorTelepon'] ?? '',
      alamat: map['alamat'] ?? '',
    );
  }
}
