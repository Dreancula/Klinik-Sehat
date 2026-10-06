import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/pegawai.dart';
import '../service/data_service.dart';
import 'pegawai_page.dart';
import 'pegawai_update_form.dart';

class PegawaiDetail extends StatefulWidget {
  final Pegawai pegawai;

  const PegawaiDetail({super.key, required this.pegawai});

  @override
  State<PegawaiDetail> createState() => _PegawaiDetailState();
}

class _PegawaiDetailState extends State<PegawaiDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pegawai")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE4F0E8)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryText.withAlpha(8),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD6EAF8),
                      ),
                      child: const Icon(
                        Icons.badge_rounded,
                        color: Color(0xFF2980B9),
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.pegawai.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pastelMint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "NIP: ${widget.pegawai.nip}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEAF2ED)),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: "Tanggal Lahir",
                      value: widget.pegawai.tanggalLahir,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.phone_rounded,
                      label: "Nomor Telepon",
                      value: widget.pegawai.nomorTelepon,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.email_rounded,
                      label: "Email",
                      value: widget.pegawai.email,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.lock_outline_rounded,
                      label: "Password",
                      value: "••••••••",
                    ),
                    if (widget.pegawai.lokasi != null &&
                        widget.pegawai.lokasi!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.pin_drop_rounded,
                        label: "Lokasi Tugas / Penempatan",
                        value: widget.pegawai.lokasi!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(child: _tombolUbah()),
                  const SizedBox(width: 16),
                  Expanded(child: _tombolHapus()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.pastelMint.withAlpha(100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.accentGreen, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tombolUbah() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.edit_rounded, size: 18),
      label: const Text("Ubah"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PegawaiUpdateForm(pegawai: widget.pegawai),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _tombolHapus() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.delete_outline_rounded, size: 18),
      label: const Text("Hapus"),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                SizedBox(width: 10),
                Text(
                  "Konfirmasi Hapus",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              "Yakin ingin menghapus data pegawai \"${widget.pegawai.nama}\"?",
              style: const TextStyle(color: AppColors.primaryText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Tidak",
                  style: TextStyle(color: AppColors.secondaryText),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  DataService.instance.deletePegawai(widget.pegawai);
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PegawaiPage(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data Pegawai berhasil dihapus"),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                child: const Text("YA"),
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.danger,
        foregroundColor: Colors.white,
      ),
    );
  }
}
