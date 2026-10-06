class Pegawai {
  int? id;
  String nip;
  String nama;
  String tanggalLahir;
  String nomorTelepon;
  String email;
  String password;
  String? lokasi;

  Pegawai({
    this.id,
    required this.nip,
    required this.nama,
    required this.tanggalLahir,
    required this.nomorTelepon,
    required this.email,
    required this.password,
    this.lokasi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nip': nip,
      'nama': nama,
      'tanggalLahir': tanggalLahir,
      'nomorTelepon': nomorTelepon,
      'email': email,
      'password': password,
      'lokasi': lokasi,
    };
  }

  factory Pegawai.fromMap(Map<String, dynamic> map) {
    return Pegawai(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      nip: map['nip'] ?? '',
      nama: map['nama'] ?? '',
      tanggalLahir: map['tanggalLahir'] ?? '',
      nomorTelepon: map['nomorTelepon'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      lokasi: map['lokasi'],
    );
  }
}
