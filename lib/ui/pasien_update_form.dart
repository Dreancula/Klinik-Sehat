import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../model/pasien.dart';
import '../service/data_service.dart';
import '../widget/date_input_formatter.dart';
import 'pasien_detail.dart';

class PasienUpdateForm extends StatefulWidget {
  final Pasien pasien;

  const PasienUpdateForm({super.key, required this.pasien});

  @override
  State<PasienUpdateForm> createState() => _PasienUpdateFormState();
}

class _PasienUpdateFormState extends State<PasienUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomorRmCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomorRmCtrl.text = widget.pasien.nomorRm;
    _namaCtrl.text = widget.pasien.nama;
    _tanggalLahirCtrl.text = widget.pasien.tanggalLahir;
    _nomorTeleponCtrl.text = widget.pasien.nomorTelepon;
    _alamatCtrl.text = widget.pasien.alamat;
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
      appBar: AppBar(title: const Text("Ubah Pasien")),
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
                        "Ubah Data Rekam Medis Pasien",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 18),
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
                          labelText: "Nama Pasien",
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
                          labelText: "Alamat",
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
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text("Simpan Perubahan"),
                  onPressed: _simpanPerubahan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      final updatedPasien = Pasien(
        id: widget.pasien.id,
        nomorRm: _nomorRmCtrl.text.trim(),
        nama: _namaCtrl.text.trim(),
        tanggalLahir: _tanggalLahirCtrl.text.trim(),
        nomorTelepon: _nomorTeleponCtrl.text.trim(),
        alamat: _alamatCtrl.text.trim(),
      );

      DataService.instance.updatePasien(updatedPasien);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Perubahan data Pasien berhasil disimpan"),
          backgroundColor: AppColors.accentGreen,
        ),
      );

      Navigator.pop(context); // Tutup form ubah
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PasienDetail(pasien: updatedPasien),
        ),
      );
    }
  }
}
