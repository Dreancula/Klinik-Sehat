import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/pasien.dart';
import '../model/pendaftaran.dart';
import '../service/data_service.dart';
import 'pasien_page.dart';
import 'pasien_update_form.dart';
import 'pendaftaran_form.dart';

class PasienDetail extends StatefulWidget {
  final Pasien pasien;

  const PasienDetail({super.key, required this.pasien});

  @override
  State<PasienDetail> createState() => _PasienDetailState();
}

class _PasienDetailState extends State<PasienDetail> {
  final DataService _dataService = DataService.instance;

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _showKarcisModal(Pendaftaran p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(22),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.pastelMint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_rounded,
                    color: AppColors.accentGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Karcis Antrean Berobat",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4FAF6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCFEBDD)),
              ),
              child: Column(
                children: [
                  const Text(
                    "NOMOR ANTREAN",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.nomorAntrean,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.namaPoli,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildKarcisRow("Nama Pasien", p.namaPasien),
            _buildKarcisRow("No. Rekam Medis", p.nomorRm),
            _buildKarcisRow("Dokter", p.namaDokter),
            _buildKarcisRow("Tanggal", "${p.tanggal.day.toString().padLeft(2, '0')}/${p.tanggal.month.toString().padLeft(2, '0')}/${p.tanggal.year} ${p.tanggal.hour.toString().padLeft(2, '0')}:${p.tanggal.minute.toString().padLeft(2, '0')}"),
            _buildKarcisRow("Status", p.status),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 42),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        ),
      ),
    );
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
    // Cari rekam medis pasien
    final riwayatList = _dataService.listPendaftaran.where((p) {
      return p.nomorRm == widget.pasien.nomorRm ||
          p.namaPasien.trim().toLowerCase() == widget.pasien.nama.trim().toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pasien")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Identitas Pasien Card
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
                        color: Color(0xFFFDEBD0),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFFE67E22),
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.pasien.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.pastelMint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "No. Rekam Medis: ${widget.pasien.nomorRm}",
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
                      value: widget.pasien.tanggalLahir,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.phone_rounded,
                      label: "Nomor Telepon",
                      value: widget.pasien.nomorTelepon,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.home_rounded,
                      label: "Alamat",
                      value: widget.pasien.alamat,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons Row (Ubah & Hapus)
              Row(
                children: [
                  Expanded(child: _tombolUbah()),
                  const SizedBox(width: 16),
                  Expanded(child: _tombolHapus()),
                ],
              ),

              const SizedBox(height: 28),

              // Riwayat Rekam Medis Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.pastelMint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.history_edu_rounded,
                          color: AppColors.accentGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Rekam Medis (${riwayatList.length})",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentGreen,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text("Daftar Berobat", style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PendaftaranForm()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Riwayat List / Empty Placeholder
              if (riwayatList.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE4F0E8)),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.folder_open_rounded, size: 42, color: AppColors.secondaryText),
                      SizedBox(height: 8),
                      Text(
                        "Belum Ada Riwayat Kunjungan",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Pasien ini belum memiliki catatan pemeriksaan medis.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: riwayatList.length,
                  itemBuilder: (context, index) {
                    final p = riwayatList[index];
                    return _buildRekamMedisCard(p);
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRekamMedisCard(Pendaftaran p) {
    Color statusColor;
    Color statusBg;
    if (p.status == "Menunggu") {
      statusColor = const Color(0xFFD35400);
      statusBg = const Color(0xFFFDEBD0);
    } else if (p.status == "Sedang Diperiksa") {
      statusColor = AppColors.info;
      statusBg = const Color(0xFFE8F4F8);
    } else {
      statusColor = AppColors.accentGreen;
      statusBg = AppColors.pastelGreen;
    }

    final dateStr =
        "${p.tanggal.day.toString().padLeft(2, '0')}/${p.tanggal.month.toString().padLeft(2, '0')}/${p.tanggal.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5F1EB)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withAlpha(6),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.pastelMint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      p.nomorAntrean,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  p.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.local_hospital_outlined, size: 16, color: AppColors.accentGreen),
              const SizedBox(width: 6),
              Text(
                "${p.namaPoli} • ${p.namaDokter}",
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: AppColors.secondaryText),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Keluhan: \"${p.keluhan}\"",
                  style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
              ),
            ],
          ),

          // Catatan / Resep Obat Dokter
          if (p.catatanDokter != null && p.catatanDokter!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3FAF6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFC8EBD8)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.medication_rounded, size: 16, color: AppColors.accentGreen),
                      SizedBox(width: 6),
                      Text(
                        "Diagnosis & Resep Dokter:",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.catatanDokter!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: AppColors.secondaryText,
              ),
              icon: const Icon(Icons.receipt_outlined, size: 16),
              label: const Text("Lihat Karcis", style: TextStyle(fontSize: 12)),
              onPressed: () => _showKarcisModal(p),
            ),
          ),
        ],
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
            builder: (context) => PasienUpdateForm(pasien: widget.pasien),
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
              "Yakin ingin menghapus data pasien \"${widget.pasien.nama}\"?",
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
                  _dataService.deletePasien(widget.pasien);
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PasienPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Data Pasien berhasil dihapus"),
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
