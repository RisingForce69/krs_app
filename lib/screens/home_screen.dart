import 'package:flutter/material.dart';

import '../data/daftar_mk.dart';
import '../models/mata_kuliah.dart';
import 'krs_summary_screen.dart';

/// Halaman utama: pemilihan mata kuliah dengan desain kartu modern
/// (sengaja dibuat berbeda dari tampilan tabel pada form KRS asli).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Batas maksimal SKS yang boleh diambil dalam satu semester.
  static const int maksimalSKS = 24;

  /// Gradien khas aplikasi (teal -> cyan) sebagai identitas visual.
  static const LinearGradient gradasiUtama = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF22D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Kode MK yang sedang dipilih (draft KRS).
  final Set<String> _kodeTerpilih = {};

  /// KRS yang terakhir disimpan.
  List<MataKuliah> _krsTersimpan = [];

  /// Kueri pencarian mata kuliah.
  String _kueri = '';

  List<MataKuliah> get _mkTerpilih => daftarMataKuliah
      .where((mk) => _kodeTerpilih.contains(mk.kodeMK))
      .toList();

  List<MataKuliah> get _mkTerlihat {
    final String q = _kueri.trim().toLowerCase();
    if (q.isEmpty) return daftarMataKuliah;
    return daftarMataKuliah
        .where((mk) =>
            mk.namaMK.toLowerCase().contains(q) || mk.kodeMK.contains(q))
        .toList();
  }

  int get totalSKS => _mkTerpilih.fold<int>(0, (jumlah, mk) => jumlah + mk.sks);

  void _toggleMataKuliah(MataKuliah mk) {
    if (_kodeTerpilih.contains(mk.kodeMK)) {
      setState(() => _kodeTerpilih.remove(mk.kodeMK));
      return;
    }
    if (totalSKS + mk.sks > maksimalSKS) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Tidak bisa menambah ${mk.namaMK}: batas maksimal $maksimalSKS SKS.',
        ),
      ));
      return;
    }
    setState(() => _kodeTerpilih.add(mk.kodeMK));
  }

  void _simpanKRS() {
    if (_kodeTerpilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Pilih minimal satu mata kuliah terlebih dahulu.'),
      ));
      return;
    }

    setState(() => _krsTersimpan = _mkTerpilih);

    final int tersimpanSKS =
        _krsTersimpan.fold<int>(0, (jumlah, mk) => jumlah + mk.sks);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green),
        title: const Text('KRS Tersimpan'),
        content: Text(
          'KRS berhasil disimpan:\n'
          '${_krsTersimpan.length} mata kuliah, $tersimpanSKS SKS.\n'
          'Lihat hasilnya lewat ikon di kanan atas.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _lihatKRS() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => KrsSummaryScreen(
        judul: 'KRS Tersimpan',
        daftarMK: _krsTersimpan,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('KRS Mobile'),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: gradasiUtama)),
        actions: [
          IconButton(
            tooltip: 'Lihat KRS tersimpan',
            icon: const Icon(Icons.fact_check_outlined),
            onPressed: _lihatKRS,
          ),
        ],
      ),
      body: Column(
        children: [
          _kartuMahasiswa(),
          _kolomPencarian(),
          _judulDaftar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _mkTerlihat.length,
              itemBuilder: (context, index) => _kartuMK(_mkTerlihat[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _panelBawah(),
    );
  }

  /// Kartu profil mahasiswa di bagian atas.
  Widget _kartuMahasiswa() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: gradasiUtama,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'JP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Judson Phangestu',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIM 2411090',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _chipIdentitas('IFB5A'),
                  const SizedBox(height: 6),
                  _chipIdentitas('Semester 5'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chipIdentitas(String teks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F766E).withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        teks,
        style: const TextStyle(
          color: Color(0xFF0F766E),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Kolom pencarian mata kuliah / kode MK.
  Widget _kolomPencarian() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        onChanged: (nilai) => setState(() => _kueri = nilai),
        decoration: InputDecoration(
          hintText: 'Cari mata kuliah atau kode MK...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// Judul seksi daftar + jumlah MK yang tampil.
  Widget _judulDaftar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          const Text(
            'Mata Kuliah Tersedia',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF0F766E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_mkTerlihat.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Satu kartu mata kuliah.
  Widget _kartuMK(MataKuliah mk) {
    final bool dipilih = _kodeTerpilih.contains(mk.kodeMK);
    final ColorScheme skema = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        elevation: dipilih ? 4 : 1,
        borderRadius: BorderRadius.circular(16),
        color: dipilih ? skema.primaryContainer : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _toggleMataKuliah(mk),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Kotak SKS dengan gradien.
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: dipilih
                        ? gradasiUtama
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade300,
                              Colors.grey.shade400,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${mk.sks}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'SKS',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mk.namaTampil,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _chipInfo(mk.kodeMK),
                          _chipInfo('Kelas ${mk.kelas}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  dipilih
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: dipilih ? skema.primary : Colors.grey.shade400,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chipInfo(String teks) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(teks, style: const TextStyle(fontSize: 11)),
    );
  }

  /// Panel bawah: ringkasan SKS + progress bar + tombol simpan.
  Widget _panelBawah() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total SKS dipilih',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_kodeTerpilih.length} dari ${daftarMataKuliah.length} mata kuliah',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$totalSKS / $maksimalSKS',
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: totalSKS / maksimalSKS,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _simpanKRS,
                icon: const Icon(Icons.save_outlined),
                label: const Text(
                  'Simpan KRS',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
