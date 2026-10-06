import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../model/poli.dart';
import 'poli_detail.dart';

class PoliItem extends StatelessWidget {
  final Poli poli;

  const PoliItem({super.key, required this.poli});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.pastelMint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.medical_services_rounded,
            color: AppColors.accentGreen,
            size: 22,
          ),
        ),
        title: Text(
          poli.namaPoli,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "ID Poli: ${poli.id ?? '-'}",
          style: const TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.secondaryText,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PoliDetail(poli: poli)),
          );
        },
      ),
    );
  }
}
