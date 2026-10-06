import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/pendaftaran.dart';
import '../service/data_service.dart';
import '../widget/sidebar.dart';
import 'pendaftaran_form.dart';

class AntreanPage extends StatefulWidget {
  const AntreanPage({super.key});

  @override
  State<AntreanPage> createState() => _AntreanPageState();
}

class _AntreanPageState extends State<AntreanPage>
    with SingleTickerProviderStateMixin {
  final DataService _dataService = DataService.instance;
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _dataService.addListener(_onDataChanged);
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dataService.removeListener(_onDataChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  void _updateStatus(Pendaftaran p, String newStatus) {
    if (newStatus == "Selesai") {
      final catatanCtrl = TextEditingController(text: p.catatanDokter ?? "");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: AppColors.accentGreen),
              SizedBox(width: 8),
              Text("Selesaikan Pemeriksaan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pasien: ${p.namaPasien} (${p.nomorAntrean})"),
              const SizedBox(height: 12),
              TextField(
                controller: catatanCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Catatan Dokter / Resep Obat (Opsional)",
                  hintText: "Contoh: Paracetamol 3x1, istirahat cukup",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                _dataService.updateStatusPendaftaran(
                  p.id,
                  "Selesai",
                  catatanCtrl.text.trim(),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Pemeriksaan untuk ${p.namaPasien} telah selesai."),
                    backgroundColor: AppColors.accentGreen,
                  ),
                );
              },
              child: const Text("Tandai Selesai"),
            ),
          ],
        ),
      );
    } else {
      _dataService.updateStatusPendaftaran(p.id, newStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Status antrean ${p.nomorAntrean} diubah ke $newStatus."),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }

  void _konfirmasiHapus(Pendaftaran p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: AppColors.danger),
            SizedBox(width: 8),
            Text("Batalkan Antrean", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "Yakin ingin membatalkan antrean ${p.nomorAntrean} atas nama ${p.namaPasien}?",
          style: const TextStyle(color: AppColors.primaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tidak", style: TextStyle(color: AppColors.secondaryText)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              _dataService.deletePendaftaran(p.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Antrean berhasil dibatalkan."),
                  backgroundColor: AppColors.danger,
                ),
              );
            },
            child: const Text("YA, Batalkan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allAntrean = _dataService.listPendaftaran;

    // Filter pencarian
    final searchedList = _searchQuery.isEmpty
        ? allAntrean
        : allAntrean.where((p) {
            final q = _searchQuery.toLowerCase();
            return p.namaPasien.toLowerCase().contains(q) ||
                p.nomorAntrean.toLowerCase().contains(q) ||
                p.nomorRm.toLowerCase().contains(q) ||
                p.namaPoli.toLowerCase().contains(q);
          }).toList();

    final listMenunggu =
        searchedList.where((p) => p.status == "Menunggu").toList();
    final listDiperiksa =
        searchedList.where((p) => p.status == "Sedang Diperiksa").toList();
    final listSelesai =
        searchedList.where((p) => p.status == "Selesai").toList();

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Antrean & Pendaftaran"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, size: 26),
            tooltip: "Daftar Antrean Baru",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PendaftaranForm(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryText,
          indicatorColor: AppColors.accentGreen,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: "Semua (${searchedList.length})"),
            Tab(text: "Menunggu (${listMenunggu.length})"),
            Tab(text: "Diperiksa (${listDiperiksa.length})"),
            Tab(text: "Selesai (${listSelesai.length})"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: "Cari nomor antrean, nama, atau poli...",
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.secondaryText),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFD6E9DF)),
                ),
              ),
            ),
          ),

          // Tab Bar Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAntreanListView(searchedList),
                _buildAntreanListView(listMenunggu),
                _buildAntreanListView(listDiperiksa),
                _buildAntreanListView(listSelesai),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        tooltip: "Daftar Pasien Berobat",
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PendaftaranForm(),
            ),
          );
        },
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }

  Widget _buildAntreanListView(List<Pendaftaran> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.inbox_rounded, size: 60, color: AppColors.secondaryText),
            SizedBox(height: 10),
            Text(
              "Tidak ada data antrean",
              style: TextStyle(color: AppColors.secondaryText, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 88),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return _buildAntreanCard(item);
      },
    );
  }

  Widget _buildAntreanCard(Pendaftaran p) {
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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5F1EB)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nomor Antrean Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: AppColors.mainGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "ANTREAN",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      Text(
                        p.nomorAntrean,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Nama Pasien & Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.namaPasien,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "No. RM: ${p.nomorRm}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.medical_services_outlined, size: 14, color: AppColors.accentGreen),
                          const SizedBox(width: 4),
                          Text(
                            p.namaPoli,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
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
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFF0F4F2), height: 1),
            const SizedBox(height: 10),
            // Dokter & Keluhan
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 15, color: AppColors.secondaryText),
                const SizedBox(width: 6),
                Text(
                  "Dokter: ${p.namaDokter}",
                  style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: AppColors.secondaryText),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "Keluhan: \"${p.keluhan}\"",
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
              ],
            ),
            if (p.catatanDokter != null && p.catatanDokter!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4FBF7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFD6EFE0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note_alt_outlined, size: 15, color: AppColors.accentGreen),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Catatan: ${p.catatanDokter}",
                        style: const TextStyle(fontSize: 12, color: AppColors.accentGreen),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Tombol Aksi Status
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger, size: 20),
                  tooltip: "Batalkan Antrean",
                  onPressed: () => _konfirmasiHapus(p),
                ),
                const SizedBox(width: 6),
                if (p.status == "Menunggu")
                  ElevatedButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text("Mulai Periksa"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.info,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () => _updateStatus(p, "Sedang Diperiksa"),
                  ),
                if (p.status == "Sedang Diperiksa")
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text("Selesai Periksa"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () => _updateStatus(p, "Selesai"),
                  ),
                if (p.status == "Selesai")
                  OutlinedButton.icon(
                    icon: const Icon(Icons.replay_rounded, size: 16),
                    label: const Text("Periksa Ulang"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.secondaryText,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () => _updateStatus(p, "Sedang Diperiksa"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
