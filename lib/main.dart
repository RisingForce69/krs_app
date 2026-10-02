import 'package:flutter/material.dart';

void main() {
  runApp(const SmartCampusApp());
}

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pilih Mata Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const CourseSelectionScreen(),
    );
  }
}

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  // Data mata kuliah asli milikmu
  final List<Map<String, dynamic>> courses = [
    {"kode": "110600", "nama": "JARINGAN NIRKABEL", "sks": 3, "kelas": "IFB5A"},
    {"kode": "110700", "nama": "KRIPTOGRAFI", "sks": 3, "kelas": "IFB5A"},
    {"kode": "111000", "nama": "PEMROGRAMAN APLIKASI BERGERAK", "sks": 3, "kelas": "IFB5A"},
    {"kode": "111100", "nama": "PENALARAN KOMPUTER", "sks": 3, "kelas": "IFB5A"},
    {"kode": "000800", "nama": "PENULISAN DAN PUBLIKASI ILMIAH", "sks": 2, "kelas": "IFB5A"},
    {"kode": "111400", "nama": "SIMULASI DAN GAME KOMPUTER", "sks": 3, "kelas": "IFB5A"},
    {"kode": "111500", "nama": "SISTEM MANAJEMEN BASIS DATA", "sks": 3, "kelas": "IFB5A"},
    {"kode": "111600", "nama": "TEKNOLOGI APLIKASI BERGERAK", "sks": 3, "kelas": "IFB5A"},
  ];

  final Set<String> selectedCourses = {};
  
  // Variabel untuk fitur pencarian dan batas SKS
  String searchQuery = '';
  final int maxSks = 24;

  // Fungsi menghitung total SKS saat ini
  int get totalSks {
    int total = 0;
    for (var course in courses) {
      if (selectedCourses.contains(course['kode'])) {
        total += course['sks'] as int;
      }
    }
    return total;
  }

  // FITUR 2: Logika batas maksimal SKS saat memilih matkul
  void toggleCourse(Map<String, dynamic> course) {
    String kode = course['kode'];
    int sks = course['sks'];

    setState(() {
      if (selectedCourses.contains(kode)) {
        selectedCourses.remove(kode); // Batal ambil
      } else {
        // Cek apakah kalau ditambah, SKS-nya melebihi batas?
        if (totalSks + sks <= maxSks) {
          selectedCourses.add(kode); 
        } else {
          // Tampilkan peringatan jika melebihi batas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal: Batas maksimal adalah $maxSks SKS!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  // FITUR 3: Popup Ringkasan (Bottom Sheet)
  void showSummary() {
    // Mencari detail matkul yang sudah dipilih
    final selectedList = courses.where((c) => selectedCourses.contains(c['kode'])).toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan KRS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Total yang diambil: $totalSks SKS'),
              const Divider(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedList.length,
                  itemBuilder: (context, index) {
                    final c = selectedList[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(c['nama'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      subtitle: Text('${c['kode']} • Kelas ${c['kelas']}'),
                      trailing: Text('${c['sks']} SKS', style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup popup
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('KRS Berhasil Disubmit secara Permanen!'), backgroundColor: Colors.green),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Konfirmasi & Submit'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // FITUR 1: Memfilter daftar mata kuliah berdasarkan teks pencarian
    final filteredCourses = courses.where((course) {
      final nameLower = course['nama'].toLowerCase();
      final kodeLower = course['kode'].toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return nameLower.contains(searchLower) || kodeLower.contains(searchLower);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('KRS Semester Ini', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Banner Total SKS & Sisa SKS
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total SKS Dipilih:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Sisa kuota: ${maxSks - totalSks} SKS', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
                Text(
                  '$totalSks / $maxSks',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
                ),
              ],
            ),
          ),
          
          // TextField Pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari Nama atau Kode Matkul...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          
          // Daftar Mata Kuliah
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: Text('Mata kuliah tidak ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      final isSelected = selectedCourses.contains(course['kode']);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: isSelected ? 4 : 1, // Elevasi naik sedikit jika dipilih
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Kotak SKS dengan animasi transisi warna
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.indigo : Colors.indigo[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${course['sks']}\nSKS',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.indigo,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Detail Mata Kuliah
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course['nama'],
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.code, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(course['kode'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                        const SizedBox(width: 12),
                                        Icon(Icons.class_, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text('Kelas ${course['kelas']}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Tombol Ambil/Batal
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => toggleCourse(course),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected ? Colors.red[50] : Colors.indigo,
                                      foregroundColor: isSelected ? Colors.red : Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(color: isSelected ? Colors.red : Colors.transparent)
                                      ),
                                    ),
                                    child: Text(isSelected ? 'Batal' : 'Ambil'),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Tombol Simpan KRS memanggil fitur showSummary
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: totalSks > 0 ? showSummary : null, 
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            child: const Text(
              'Simpan KRS',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}