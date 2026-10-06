import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../model/pegawai.dart';
import '../service/data_service.dart';
import '../widget/date_input_formatter.dart';
import 'pegawai_detail.dart';

class PegawaiUpdateForm extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiUpdateForm({super.key, required this.pegawai});

  @override
  State<PegawaiUpdateForm> createState() => _PegawaiUpdateFormState();
}

class _PegawaiUpdateFormState extends State<PegawaiUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _nipCtrl = TextEditingController();
  final _namaCtrl = TextEditingController();
  final _tanggalLahirCtrl = TextEditingController();
  final _nomorTeleponCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _lokasiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nipCtrl.text = widget.pegawai.nip;
    _namaCtrl.text = widget.pegawai.nama;
    _tanggalLahirCtrl.text = widget.pegawai.tanggalLahir;
    _nomorTeleponCtrl.text = widget.pegawai.nomorTelepon;
    _emailCtrl.text = widget.pegawai.email;
    _passwordCtrl.text = widget.pegawai.password;
    _lokasiCtrl.text = widget.pegawai.lokasi ?? '';
  }

  @override
  void dispose() {
    _nipCtrl.dispose();
    _namaCtrl.dispose();
    _tanggalLahirCtrl.dispose();
    _nomorTeleponCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _lokasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 1, 1),
      firstDate: DateTime(1950),
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
      appBar: AppBar(title: const Text("Ubah Pegawai")),
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
                        "Ubah Data Pegawai",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _nipCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: "NIP (Nomor Induk Pegawai)",
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "NIP tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _namaCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nama Lengkap Pegawai",
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Nama Pegawai tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _tanggalLahirCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [DateInputFormatter()],
                        decoration: InputDecoration(
                          labelText: "Tanggal Lahir (Hanya Angka)",
                          hintText: "DD/MM/YYYY (Contoh: 01/01/1990)",
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range_rounded,
                                color: AppColors.accentGreen),
                            onPressed: _pilihTanggal,
                            tooltip: "Pilih Kalender",
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
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Alamat Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Email tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password Akun",
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? "Password tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _lokasiCtrl,
                        decoration: const InputDecoration(
                          labelText: "Lokasi Tugas / Penempatan",
                          prefixIcon: Icon(Icons.pin_drop_outlined),
                        ),
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
      final updatedPegawai = Pegawai(
        id: widget.pegawai.id,
        nip: _nipCtrl.text.trim(),
        nama: _namaCtrl.text.trim(),
        tanggalLahir: _tanggalLahirCtrl.text.trim(),
        nomorTelepon: _nomorTeleponCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        lokasi: _lokasiCtrl.text.trim().isEmpty ? null : _lokasiCtrl.text.trim(),
      );

      DataService.instance.updatePegawai(updatedPegawai);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Perubahan data Pegawai berhasil disimpan"),
          backgroundColor: AppColors.accentGreen,
        ),
      );

      Navigator.pop(context); // Tutup form ubah
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PegawaiDetail(pegawai: updatedPegawai),
        ),
      );
    }
  }
}
