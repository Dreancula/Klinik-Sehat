import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/poli.dart';
import '../model/pegawai.dart';
import '../model/pasien.dart';
import '../model/pendaftaran.dart';

class RegistrationCode {
  final String code;
  final DateTime createdAt;
  bool isUsed;
  String? usedBy;

  RegistrationCode({
    required this.code,
    required this.createdAt,
    this.isUsed = false,
    this.usedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'createdAt': createdAt.toIso8601String(),
      'isUsed': isUsed,
      'usedBy': usedBy,
    };
  }

  factory RegistrationCode.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(map['createdAt'] ?? '');
    } catch (_) {
      parsedDate = DateTime.now();
    }
    return RegistrationCode(
      code: map['code'] ?? '',
      createdAt: parsedDate,
      isUsed: map['isUsed'] ?? false,
      usedBy: map['usedBy'],
    );
  }
}

class UserModel {
  final String nama;
  final String email;
  final String role;
  final String? nip;

  UserModel({
    required this.nama,
    required this.email,
    required this.role,
    this.nip,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'email': email,
      'role': role,
      'nip': nip,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nama: map['nama'] ?? 'Administrator',
      email: map['email'] ?? 'admin@klinik.com',
      role: map['role'] ?? 'Admin',
      nip: map['nip'],
    );
  }
}

class DataService extends ChangeNotifier {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  static DataService get instance => _instance;

  DataService._internal() {
    _initData();
    _loadFromStorage();
  }

  UserModel _currentUser = UserModel(
    nama: "Administrator",
    email: "admin@klinik.com",
    role: "Admin",
  );

  UserModel get currentUser => _currentUser;

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    _saveSession();
    notifyListeners();
  }

  void logout() {
    _currentUser = UserModel(
      nama: "Administrator",
      email: "admin@klinik.com",
      role: "Admin",
    );
    _saveSession();
    notifyListeners();
  }

  final List<Poli> _listPoli = [];
  final List<Pegawai> _listPegawai = [];
  final List<Pasien> _listPasien = [];
  final List<RegistrationCode> _registrationCodes = [];
  final List<Pendaftaran> _listPendaftaran = [];

  void _initData() {
    _listPoli.clear();
    _listPegawai.clear();
    _listPasien.clear();
    _registrationCodes.clear();
    _listPendaftaran.clear();

    // Initial Poli
    _listPoli.addAll([
      Poli(id: "1", namaPoli: "Poli Anak"),
      Poli(id: "2", namaPoli: "Poli Kandungan"),
      Poli(id: "3", namaPoli: "Poli Gigi"),
      Poli(id: "4", namaPoli: "Poli THT"),
      Poli(id: "5", namaPoli: "Poli Umum"),
    ]);

    // Initial Pegawai
    _listPegawai.addAll([
      Pegawai(
        id: 1,
        nip: "19900101",
        nama: "Dr. Budi Santoso",
        tanggalLahir: "01011990",
        nomorTelepon: "081234567890",
        email: "budi@klinik.com",
        password: "password123",
        lokasi: "Klinik Pusat - Jl. Diponegoro No. 12 (-6.2088, 106.8456)",
      ),
      Pegawai(
        id: 2,
        nip: "19920202",
        nama: "Siti Rahmawati, S.Kep",
        tanggalLahir: "02021992",
        nomorTelepon: "081298765432",
        email: "siti@klinik.com",
        password: "password123",
        lokasi: "Klinik Cabang Barat - Jl. Ahmad Yani No. 5 (-6.2145, 106.8410)",
      ),
    ]);

    // Initial Pasien
    _listPasien.addAll([
      Pasien(
        id: 1,
        nomorRm: "RM-001",
        nama: "Ahmad Fauzi",
        tanggalLahir: "15051995",
        nomorTelepon: "089876543210",
        alamat: "Jl. Merdeka No. 10, Jakarta",
      ),
      Pasien(
        id: 2,
        nomorRm: "RM-002",
        nama: "Dewi Lestari",
        tanggalLahir: "20081998",
        nomorTelepon: "085678901234",
        alamat: "Jl. Sudirman No. 25, Jakarta",
      ),
    ]);

    // Default sample registration codes
    _registrationCodes.addAll([
      RegistrationCode(
        code: "ADM88K",
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      RegistrationCode(
        code: "KLN92X",
        createdAt: DateTime.now(),
      ),
    ]);

    // Default sample pendaftaran antrean
    _listPendaftaran.addAll([
      Pendaftaran(
        id: "REG-001",
        nomorAntrean: "U-001",
        tanggal: DateTime.now().subtract(const Duration(hours: 2)),
        namaPasien: "Ahmad Fauzi",
        nomorRm: "RM-001",
        namaPoli: "Poli Umum",
        namaDokter: "Dr. Budi Santoso",
        keluhan: "Demam tinggi dan sakit kepala sejak 2 hari",
        status: "Selesai",
        catatanDokter: "Diagnosis: Faringitis Akut. Resep: Paracetamol 500mg 3x1, Amoxicillin 500mg 3x1 setelah makan.",
      ),
      Pendaftaran(
        id: "REG-002",
        nomorAntrean: "G-001",
        tanggal: DateTime.now().subtract(const Duration(minutes: 40)),
        namaPasien: "Dewi Lestari",
        nomorRm: "RM-002",
        namaPoli: "Poli Gigi",
        namaDokter: "Dr. Budi Santoso",
        keluhan: "Pembersihan karang gigi dan ngilu",
        status: "Selesai",
        catatanDokter: "Scaling gigi rahang atas & bawah. Edukasi sikat gigi halus & pasta gigi sensitif.",
      ),
      Pendaftaran(
        id: "REG-003",
        nomorAntrean: "A-001",
        tanggal: DateTime.now().subtract(const Duration(minutes: 10)),
        namaPasien: "Ahmad Fauzi",
        nomorRm: "RM-001",
        namaPoli: "Poli Anak",
        namaDokter: "Dr. Budi Santoso",
        keluhan: "Konsultasi batuk pilek",
        status: "Sedang Diperiksa",
      ),
    ]);
  }

  // ================= STORAGE PERSISTENCE =================
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final poliJson = prefs.getString('list_poli');
      final pegawaiJson = prefs.getString('list_pegawai');
      final pasienJson = prefs.getString('list_pasien');
      final pendaftaranJson = prefs.getString('list_pendaftaran');
      final codesJson = prefs.getString('list_codes');
      final userJson = prefs.getString('current_user');

      bool hasData = false;
      if (poliJson != null) {
        final List list = jsonDecode(poliJson);
        _listPoli.clear();
        _listPoli.addAll(list.map((e) => Poli.fromMap(e)));
        hasData = true;
      }
      if (pegawaiJson != null) {
        final List list = jsonDecode(pegawaiJson);
        _listPegawai.clear();
        _listPegawai.addAll(list.map((e) => Pegawai.fromMap(e)));
        hasData = true;
      }
      if (pasienJson != null) {
        final List list = jsonDecode(pasienJson);
        _listPasien.clear();
        _listPasien.addAll(list.map((e) => Pasien.fromMap(e)));
        hasData = true;
      }
      if (pendaftaranJson != null) {
        final List list = jsonDecode(pendaftaranJson);
        _listPendaftaran.clear();
        _listPendaftaran.addAll(list.map((e) => Pendaftaran.fromMap(e)));
        hasData = true;
      }
      if (codesJson != null) {
        final List list = jsonDecode(codesJson);
        _registrationCodes.clear();
        _registrationCodes.addAll(list.map((e) => RegistrationCode.fromMap(e)));
        hasData = true;
      }
      if (userJson != null) {
        _currentUser = UserModel.fromMap(jsonDecode(userJson));
      }

      if (hasData) {
        notifyListeners();
      } else {
        _saveToStorage();
      }
    } catch (e) {
      debugPrint("Error loading from SharedPreferences: $e");
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('list_poli', jsonEncode(_listPoli.map((e) => e.toMap()).toList()));
      await prefs.setString('list_pegawai', jsonEncode(_listPegawai.map((e) => e.toMap()).toList()));
      await prefs.setString('list_pasien', jsonEncode(_listPasien.map((e) => e.toMap()).toList()));
      await prefs.setString('list_pendaftaran', jsonEncode(_listPendaftaran.map((e) => e.toMap()).toList()));
      await prefs.setString('list_codes', jsonEncode(_registrationCodes.map((e) => e.toMap()).toList()));
    } catch (e) {
      debugPrint("Error saving to SharedPreferences: $e");
    }
  }

  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', jsonEncode(_currentUser.toMap()));
    } catch (e) {
      debugPrint("Error saving session: $e");
    }
  }

  Future<void> resetToDefaultData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint("Error clearing storage: $e");
    }
    _initData();
    await _saveToStorage();
    notifyListeners();
  }

  // ================= POLI CRUD =================
  List<Poli> get listPoli => List.unmodifiable(_listPoli);

  void addPoli(Poli poli) {
    if (poli.id == null || poli.id!.isEmpty) {
      poli.id = (DateTime.now().millisecondsSinceEpoch % 100000).toString();
    }
    _listPoli.add(poli);
    _saveToStorage();
    notifyListeners();
  }

  void updatePoli(Poli updatedPoli) {
    int index = _listPoli.indexWhere(
      (p) => p.id == updatedPoli.id || p.namaPoli == updatedPoli.namaPoli,
    );
    if (index != -1) {
      _listPoli[index] = updatedPoli;
    } else {
      _listPoli.add(updatedPoli);
    }
    _saveToStorage();
    notifyListeners();
  }

  void deletePoli(Poli poli) {
    _listPoli.removeWhere(
      (p) => p.id == poli.id || p.namaPoli == poli.namaPoli,
    );
    _saveToStorage();
    notifyListeners();
  }

  // ================= PEGAWAI CRUD =================
  List<Pegawai> get listPegawai => List.unmodifiable(_listPegawai);

  void addPegawai(Pegawai pegawai) {
    if (pegawai.id == null) {
      int nextId = _listPegawai.isEmpty
          ? 1
          : (_listPegawai.map((e) => e.id ?? 0).reduce(max) + 1);
      pegawai.id = nextId;
    }
    _listPegawai.add(pegawai);
    _saveToStorage();
    notifyListeners();
  }

  void updatePegawai(Pegawai updatedPegawai) {
    int index = _listPegawai.indexWhere((p) => p.id == updatedPegawai.id);
    if (index != -1) {
      _listPegawai[index] = updatedPegawai;
    } else {
      _listPegawai.add(updatedPegawai);
    }
    _saveToStorage();
    notifyListeners();
  }

  void deletePegawai(Pegawai pegawai) {
    _listPegawai.removeWhere((p) => p.id == pegawai.id);
    _saveToStorage();
    notifyListeners();
  }

  // ================= PASIEN CRUD =================
  List<Pasien> get listPasien => List.unmodifiable(_listPasien);

  void addPasien(Pasien pasien) {
    if (pasien.id == null) {
      int nextId = _listPasien.isEmpty
          ? 1
          : (_listPasien.map((e) => e.id ?? 0).reduce(max) + 1);
      pasien.id = nextId;
    }
    _listPasien.add(pasien);
    _saveToStorage();
    notifyListeners();
  }

  void updatePasien(Pasien updatedPasien) {
    int index = _listPasien.indexWhere((p) => p.id == updatedPasien.id);
    if (index != -1) {
      _listPasien[index] = updatedPasien;
    } else {
      _listPasien.add(updatedPasien);
    }
    _saveToStorage();
    notifyListeners();
  }

  void deletePasien(Pasien pasien) {
    _listPasien.removeWhere((p) => p.id == pasien.id);
    _saveToStorage();
    notifyListeners();
  }

  // ================= UNIQUE REGISTRATION CODE =================
  List<RegistrationCode> get registrationCodes =>
      List.unmodifiable(_registrationCodes);

  String generateRegistrationCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Tanpa huruf/angka ambigu (O, 0, I, 1)
    final random = Random();
    String code;
    do {
      code = List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
    } while (_registrationCodes.any((r) => r.code == code));

    final regCode = RegistrationCode(code: code, createdAt: DateTime.now());
    _registrationCodes.insert(0, regCode);
    _saveToStorage();
    notifyListeners();
    return code;
  }

  bool isCodeValid(String inputCode) {
    final cleanInput = inputCode.trim().toUpperCase();
    return _registrationCodes.any(
      (r) => r.code == cleanInput && !r.isUsed,
    );
  }

  bool consumeCode(String inputCode, String employeeName) {
    final cleanInput = inputCode.trim().toUpperCase();
    final index = _registrationCodes.indexWhere(
      (r) => r.code == cleanInput && !r.isUsed,
    );
    if (index != -1) {
      _registrationCodes[index].isUsed = true;
      _registrationCodes[index].usedBy = employeeName;
      _saveToStorage();
      notifyListeners();
      return true;
    }
    return false;
  }

  // ================= PENDAFTARAN & ANTREAN CRUD =================
  List<Pendaftaran> get listPendaftaran => List.unmodifiable(_listPendaftaran);

  String generateNomorAntrean(String namaPoli) {
    String prefix = "A";
    final lower = namaPoli.toLowerCase();
    if (lower.contains("anak")) {
      prefix = "A";
    } else if (lower.contains("gigi")) {
      prefix = "G";
    } else if (lower.contains("kandungan")) {
      prefix = "K";
    } else if (lower.contains("tht")) {
      prefix = "T";
    } else if (lower.contains("mata")) {
      prefix = "M";
    } else if (lower.contains("umum")) {
      prefix = "U";
    } else if (namaPoli.isNotEmpty) {
      prefix = namaPoli.substring(0, 1).toUpperCase();
    }

    final countSamePrefix = _listPendaftaran
        .where((p) => p.nomorAntrean.startsWith(prefix))
        .length;
    final nextNumber = countSamePrefix + 1;
    return "$prefix-${nextNumber.toString().padLeft(3, '0')}";
  }

  void addPendaftaran(Pendaftaran pendaftaran) {
    _listPendaftaran.insert(0, pendaftaran);
    _saveToStorage();
    notifyListeners();
  }

  void updateStatusPendaftaran(String id, String newStatus, [String? catatan]) {
    final index = _listPendaftaran.indexWhere((p) => p.id == id);
    if (index != -1) {
      _listPendaftaran[index].status = newStatus;
      if (catatan != null && catatan.isNotEmpty) {
        _listPendaftaran[index].catatanDokter = catatan;
      }
      _saveToStorage();
      notifyListeners();
    }
  }

  void deletePendaftaran(String id) {
    _listPendaftaran.removeWhere((p) => p.id == id);
    _saveToStorage();
    notifyListeners();
  }
}
