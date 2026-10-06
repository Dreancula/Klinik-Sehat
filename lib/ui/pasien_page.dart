import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../service/data_service.dart';
import '../widget/sidebar.dart';
import 'pasien_item.dart';
import 'pasien_form.dart';

class PasienPage extends StatefulWidget {
  const PasienPage({super.key});

  @override
  State<PasienPage> createState() => _PasienPageState();
}

class _PasienPageState extends State<PasienPage> {
  final DataService _dataService = DataService.instance;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _dataService.addListener(_onDataChanged);
    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _dataService.removeListener(_onDataChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final allPasien = _dataService.listPasien;
    final filteredPasien = _searchQuery.isEmpty
        ? allPasien
        : allPasien.where((p) {
            final q = _searchQuery.toLowerCase();
            return p.nama.toLowerCase().contains(q) ||
                p.nomorRm.toLowerCase().contains(q) ||
                p.nomorTelepon.contains(q);
          }).toList();

    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: const Text("Data Pasien"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 26),
            tooltip: "Tambah Pasien",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PasienForm()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Total Data
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              gradient: AppColors.mainGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Pasien: ${allPasien.length}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${filteredPasien.length} Ditampilkan",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: "Cari nama atau No. RM pasien...",
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

          Expanded(
            child: filteredPasien.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.personal_injury_outlined,
                          size: 56,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _searchQuery.isNotEmpty
                              ? "Tidak ditemukan pasien \"$_searchQuery\""
                              : "Belum ada data pasien",
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 80),
                    itemCount: filteredPasien.length,
                    itemBuilder: (context, index) {
                      return PasienItem(pasien: filteredPasien[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.accentGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Pasien"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PasienForm()),
          );
        },
      ),
    );
  }
}
