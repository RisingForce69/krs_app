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
  // Data mata kuliah sudah diperbarui sesuai gambar tabel milikmu
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

  void toggleCourse(String kode) {
    setState(() {
      if (selectedCourses.contains(kode)) {
        selectedCourses.remove(kode); 
      } else {
        selectedCourses.add(kode); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalSks = 0;
    for (var course in courses) {
      if (selectedCourses.contains(course['kode'])) {
        totalSks += course['sks'] as int;
      }
    }

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
          // Banner Total SKS
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total SKS Dipilih:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalSks SKS',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ],
            ),
          ),
          
          // Daftar Mata Kuliah
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final isSelected = selectedCourses.contains(course['kode']);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kotak SKS
                        Container(
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
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.code, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    course['kode'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Icon(Icons.class_, size: 14, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Kelas ${course['kelas']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
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
                              onPressed: () => toggleCourse(course['kode']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected ? Colors.red[50] : Colors.indigo,
                                foregroundColor: isSelected ? Colors.red : Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected ? Colors.red : Colors.transparent,
                                  )
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
      // Tombol Simpan
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: totalSks > 0 
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('KRS Berhasil Disimpan ($totalSks SKS)')),
                    );
                  } 
                : null, 
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )
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