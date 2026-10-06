import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/poli.dart';
import '../service/data_service.dart';
import 'poli_page.dart';
import 'poli_update_form.dart';

class PoliDetail extends StatefulWidget {
  final Poli poli;

  const PoliDetail({super.key, required this.poli});

  @override
  State<PoliDetail> createState() => _PoliDetailState();
}

class _PoliDetailState extends State<PoliDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Poli")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
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
                        gradient: AppColors.mainGradient,
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        color: AppColors.accentGreen,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.poli.namaPoli,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "ID Layanan: ${widget.poli.id ?? '-'}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFEAF2ED)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusBadge("Status: Aktif", AppColors.accentGreen),
                        _buildStatusBadge("Pelayanan: Rawat Jalan", AppColors.info),
                      ],
                    ),
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

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
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
            builder: (context) => PoliUpdateForm(poli: widget.poli),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              "Yakin ingin menghapus data \"${widget.poli.namaPoli}\"?",
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
                  DataService.instance.deletePoli(widget.poli);
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PoliPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data Poli berhasil dihapus"),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
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
