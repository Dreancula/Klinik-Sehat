import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/poli.dart';
import '../service/data_service.dart';
import 'poli_detail.dart';

class PoliUpdateForm extends StatefulWidget {
  final Poli poli;

  const PoliUpdateForm({super.key, required this.poli});

  @override
  State<PoliUpdateForm> createState() => _PoliUpdateFormState();
}

class _PoliUpdateFormState extends State<PoliUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPoliCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaPoliCtrl.text = widget.poli.namaPoli;
  }

  @override
  void dispose() {
    _namaPoliCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Poli")),
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
                        "Ubah Data Layanan Poli",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "ID Poli: ${widget.poli.id ?? '-'}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _namaPoliCtrl,
                        decoration: const InputDecoration(
                          labelText: "Nama Poli",
                          prefixIcon: Icon(Icons.edit_note_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Nama Poli tidak boleh kosong";
                          }
                          return null;
                        },
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
      final updatedPoli = Poli(
        id: widget.poli.id,
        namaPoli: _namaPoliCtrl.text.trim(),
      );
      DataService.instance.updatePoli(updatedPoli);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Perubahan data Poli berhasil disimpan"),
          backgroundColor: AppColors.accentGreen,
        ),
      );

      Navigator.pop(context); // Tutup form ubah
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PoliDetail(poli: updatedPoli)),
      );
    }
  }
}
