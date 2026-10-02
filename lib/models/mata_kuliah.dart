/// Model data untuk satu Mata Kuliah (MK).
class MataKuliah {
  final String kodeMK;
  final String namaMK;
  final int sks;
  final String kelas;

  const MataKuliah({
    required this.kodeMK,
    required this.namaMK,
    required this.sks,
    required this.kelas,
  });

  /// Nama dalam format judul (mis. "Jaringan Nirkabel") agar tampilan
  /// aplikasi berbeda dari form KRS asli yang serba kapital.
  String get namaTampil => namaMK
      .toLowerCase()
      .split(' ')
      .map((kata) =>
          kata.isEmpty ? kata : '${kata[0].toUpperCase()}${kata.substring(1)}')
      .join(' ');
}
