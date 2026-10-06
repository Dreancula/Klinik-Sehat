import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../model/pasien.dart';
import '../service/data_service.dart';
import '../widget/date_input_formatter.dart';
import 'pasien_detail.dart';

class PasienForm extends StatefulWidget {
  const PasienForm({super.key});

  @override
  State<PasienForm> createState() => _PasienFormState();
}

class _PasienFormState extends State<PasienForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomorRmCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Default format auto-generate Nomor RM
    final nextId = DataService.instance.listPasien.length + 1;
    _nomorRmCtrl.text = "RM-00$nextId";
  }

  @override
  void dispose() {
    _nomorRmCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _alamatCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      setState(() {
        _tanggalLahirCtrl.text = "$day/$month/$year";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pasien")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4F0E8)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryText.withAlpha(8),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Informasi Rekam Medis Pasien",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Lengkapi seluruh data pasien baru berikut ini.",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nomorRmCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nomor Rekam Medis (RM)",
                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Nomor RM tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _namaCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nama Lengkap Pasien",
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Nama Pasien tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _tanggalLahirCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [DateInputFormatter()],
                        decoration: InputDecoration(
                          labelText: "Tanggal Lahir (Hanya Angka)",
                          hintText: "DD/MM/YYYY (Contoh: 15/05/1995)",
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range_rounded, color: AppColors.accentGreen),
                            onPressed: _pilihTanggal,
                            tooltip: "Pilih dari Kalender",
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Tanggal Lahir tidak boleh kosong";
                          }
                          if (val.trim().length < 8) {
                            return "Format tanggal lahir belum lengkap (DD/MM/YYYY)";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _nomorTeleponCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: "Nomor Telepon (Hanya Angka)",
                          hintText: "Contoh: 081234567890",
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return "Nomor Telepon tidak boleh kosong";
                          }
                          if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                            return "Nomor Telepon hanya boleh angka";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _alamatCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Alamat Tinggal Pasien",
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Alamat tidak boleh kosong"
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_rounded),
                  label: const Text("Simpan Data Pasien"),
                  onPressed: _simpan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      final pasien = Pasien(
        nomorRm: _nomorRmCtrl.text.trim(),
        nama: _namaCtrl.text.trim(),
        tanggalLahir: _tanggalLahirCtrl.text.trim(),
        nomorTelepon: _nomorTeleponCtrl.text.trim(),
        alamat: _alamatCtrl.text.trim(),
      );

      DataService.instance.addPasien(pasien);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data Pasien berhasil ditambahkan"),
          backgroundColor: AppColors.accentGreen,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PasienDetail(pasien: pasien)),
      );
    }
  }
}
