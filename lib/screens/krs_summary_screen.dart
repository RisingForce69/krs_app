import 'package:flutter/material.dart';

import '../models/mata_kuliah.dart';

/// Halaman ringkasan KRS tersimpan dengan desain kartu (bukan tabel).
class KrsSummaryScreen extends StatelessWidget {
  final String judul;
  final List<MataKuliah> daftarMK;

  const KrsSummaryScreen({
    super.key,
    required this.judul,
    required this.daftarMK,
  });

  int get totalSKS => daftarMK.fold<int>(0, (jumlah, mk) => jumlah + mk.sks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: Text(judul),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF22D3EE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: daftarMK.isEmpty
          ? const Center(child: Text('Belum ada KRS yang tersimpan.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (int i = 0; i < daftarMK.length; i++)
                  _kartuMK(i + 1, daftarMK[i]),
                const SizedBox(height: 16),
                _kartuTotal(),
              ],
            ),
    );
  }

  /// Satu kartu mata kuliah terpilih.
  Widget _kartuMK(int nomor, MataKuliah mk) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF0F766E),
          child: Text(
            '$nomor',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          mk.namaTampil,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${mk.kodeMK}  •  ${mk.sks} SKS  •  Kelas ${mk.kelas}'),
      ),
    );
  }

  /// Kartu gradien berisi total MK dan SKS.
  Widget _kartuTotal() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF22D3EE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.summarize_outlined, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Total: ${daftarMK.length} mata kuliah • $totalSKS SKS',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
