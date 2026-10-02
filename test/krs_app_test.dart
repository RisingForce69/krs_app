import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:krs_app/main.dart';

void main() {
  // Layar virtual yang cukup tinggi agar semua kartu daftar terbangun.
  void gunakanLayarTinggi(WidgetTester tester) {
    tester.view.physicalSize = const Size(2400, 3600);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets(
      'memilih MK, menghitung total SKS, menyimpan, dan melihat ringkasan',
      (tester) async {
    gunakanLayarTinggi(tester);
    await tester.pumpWidget(const KrsApp());

    // Semua mata kuliah dari daftar ditampilkan (format judul).
    expect(find.text('Jaringan Nirkabel'), findsOneWidget);
    expect(find.text('Kriptografi'), findsOneWidget);
    expect(find.text('Penulisan Dan Publikasi Ilmiah'), findsOneWidget);
    expect(find.text('Teknologi Aplikasi Bergerak'), findsOneWidget);

    // Awalnya belum ada yang dipilih.
    expect(find.text('0 / 24'), findsOneWidget);

    // Pilih Jaringan Nirkabel (3 SKS) dan Penulisan Dan Publikasi Ilmiah (2 SKS).
    await tester.tap(find.text('Jaringan Nirkabel'));
    await tester.pump();
    await tester.tap(find.text('Penulisan Dan Publikasi Ilmiah'));
    await tester.pump();

    expect(find.text('5 / 24'), findsOneWidget);
    expect(find.text('2 dari 8 mata kuliah'), findsOneWidget);

    // Simpan KRS -> dialog konfirmasi muncul.
    await tester.tap(find.text('Simpan KRS'));
    await tester.pumpAndSettle();
    expect(find.text('KRS Tersimpan'), findsOneWidget);
    expect(find.textContaining('2 mata kuliah, 5 SKS'), findsOneWidget);

    // Tutup dialog.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Buka halaman ringkasan KRS tersimpan.
    await tester.tap(find.byTooltip('Lihat KRS tersimpan'));
    await tester.pumpAndSettle();
    expect(find.text('Total: 2 mata kuliah • 5 SKS'), findsOneWidget);
    expect(find.text('Jaringan Nirkabel'), findsOneWidget);
    expect(find.text('Penulisan Dan Publikasi Ilmiah'), findsOneWidget);
    // MK yang tidak dipilih tidak ikut masuk ringkasan.
    expect(find.text('Kriptografi'), findsNothing);
  });

  testWidgets('memilih semua MK menghasilkan total 23 SKS (di bawah batas 24)',
      (tester) async {
    gunakanLayarTinggi(tester);
    await tester.pumpWidget(const KrsApp());

    for (final nama in [
      'Jaringan Nirkabel',
      'Kriptografi',
      'Pemrograman Aplikasi Bergerak',
      'Penalaran Komputer',
      'Penulisan Dan Publikasi Ilmiah',
      'Simulasi Dan Game Komputer',
      'Sistem Manajemen Basis Data',
      'Teknologi Aplikasi Bergerak',
    ]) {
      await tester.tap(find.text(nama));
      await tester.pump();
    }

    // 7 MK x 3 SKS + 1 MK x 2 SKS = 23 SKS.
    expect(find.text('23 / 24'), findsOneWidget);
    expect(find.text('8 dari 8 mata kuliah'), findsOneWidget);
  });

  testWidgets('pencarian memfilter daftar mata kuliah', (tester) async {
    gunakanLayarTinggi(tester);
    await tester.pumpWidget(const KrsApp());

    await tester.enterText(find.byType(TextField), 'kripto');
    await tester.pump();

    expect(find.text('Kriptografi'), findsOneWidget);
    expect(find.text('Jaringan Nirkabel'), findsNothing);
  });
}
