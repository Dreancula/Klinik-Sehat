import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/pasien.dart';
import '../model/poli.dart';
import '../model/pegawai.dart';
import '../model/pendaftaran.dart';
import '../service/data_service.dart';

class PendaftaranForm extends StatefulWidget {
  const PendaftaranForm({super.key});

  @override
  State<PendaftaranForm> createState() => _PendaftaranFormState();
}

class _PendaftaranFormState extends State<PendaftaranForm> {
  final _formKey = GlobalKey<FormState>();
  Pasien? _selectedPasien;
  Poli? _selectedPoli;
  Pegawai? _selectedDokter;
  final _keluhanCtrl = TextEditingController();
  String _previewNomorAntrean = "-";

  @override
  void initState() {
    super.initState();
    final listPasien = DataService.instance.listPasien;
    final listPoli = DataService.instance.listPoli;
    final listDokter = DataService.instance.listPegawai;

    if (listPasien.isNotEmpty) _selectedPasien = listPasien.first;
    if (listPoli.isNotEmpty) {
      _selectedPoli = listPoli.first;
      _updateNomorAntrean();
    }
    if (listDokter.isNotEmpty) _selectedDokter = listDokter.first;
  }

  @override
  void dispose() {
    _keluhanCtrl.dispose();
    super.dispose();
  }

  void _updateNomorAntrean() {
    if (_selectedPoli != null) {
      setState(() {
        _previewNomorAntrean =
            DataService.instance.generateNomorAntrean(_selectedPoli!.namaPoli);
      });
    }
  }

  void _simpanPendaftaran() {
    if (_selectedPasien == null || _selectedPoli == null || _selectedDokter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pastikan data Pasien, Poli, dan Dokter telah dipilih!"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final pendaftaran = Pendaftaran(
        id: "REG-${DateTime.now().millisecondsSinceEpoch % 10000}",
        nomorAntrean: _previewNomorAntrean,
        tanggal: DateTime.now(),
        namaPasien: _selectedPasien!.nama,
        nomorRm: _selectedPasien!.nomorRm,
        namaPoli: _selectedPoli!.namaPoli,
        namaDokter: _selectedDokter!.nama,
        keluhan: _keluhanCtrl.text.trim(),
        status: "Menunggu",
      );

      DataService.instance.addPendaftaran(pendaftaran);

      // Tampilkan Karcis Antrean
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pastelMint,
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.accentGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "KARCIS ANTREAN KLINIK",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Pendaftaran Pasien Berhasil Disimpan",
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBFE3D1)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "NOMOR ANTREAN",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pendaftaran.nomorAntrean,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pendaftaran.namaPoli,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildKarcisRow("Nama Pasien", pendaftaran.namaPasien),
              _buildKarcisRow("No. Rekam Medis", pendaftaran.nomorRm),
              _buildKarcisRow("Dokter", pendaftaran.namaDokter),
              _buildKarcisRow("Status", "Menunggu Panggilan"),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                ),
                onPressed: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(context); // Kembali ke list antrean
                },
                child: const Text("Selesai & Lihat Antrean"),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildKarcisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listPasien = DataService.instance.listPasien;
    final listPoli = DataService.instance.listPoli;
    final listDokter = DataService.instance.listPegawai;

    return Scaffold(
      appBar: AppBar(title: const Text("Pendaftaran Pasien Berobat")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Preview Nomor Antrean Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFCBEAD9)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.confirmation_number_rounded,
                          color: AppColors.accentGreen,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nomor Antrean Berikutnya:",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                            Text(
                              _previewNomorAntrean,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE4F0E8)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryText.withAlpha(8),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Formulir Rawat Jalan / Pendaftaran",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tentukan pasien, poli spesialis, dan dokter yang bertugas.",
                        style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 20),

                      // Dropdown Pasien
                      const Text(
                        "Pilih Pasien Terdaftar",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Pasien>(
                        initialValue: _selectedPasien,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        items: listPasien.map((p) {
                          return DropdownMenuItem<Pasien>(
                            value: p,
                            child: Text("${p.nama} (${p.nomorRm})"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedPasien = val;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Dropdown Poli
                      const Text(
                        "Pilih Poli Layanan",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Poli>(
                        initialValue: _selectedPoli,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.medical_services_outlined),
                        ),
                        items: listPoli.map((p) {
                          return DropdownMenuItem<Poli>(
                            value: p,
                            child: Text(p.namaPoli),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedPoli = val;
                            _updateNomorAntrean();
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Dropdown Dokter / Pegawai
                      const Text(
                        "Pilih Dokter Pemeriksa",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Pegawai>(
                        initialValue: _selectedDokter,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        items: listDokter.map((d) {
                          return DropdownMenuItem<Pegawai>(
                            value: d,
                            child: Text(d.nama),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedDokter = val;
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      // Input Keluhan
                      const Text(
                        "Keluhan / Gejala Utama Pasien",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _keluhanCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: "Tuliskan keluhan atau gejala yang dirasakan pasien...",
                          prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Keluhan pasien tidak boleh kosong"
                            : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  icon: const Icon(Icons.send_rounded),
                  label: const Text("Daftarkan Antrean & Ambil Karcis"),
                  onPressed: _simpanPendaftaran,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
