import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ============================================================
// MODEL DATA
// ============================================================
class Buku {
  final String judul; // String
  final String penulis; // String
  final int tahunTerbit; // int
  final double rating; // double
  final bool isFavorit; // bool
  final String sinopsis;

  const Buku({
    required this.judul,
    required this.penulis,
    required this.tahunTerbit,
    required this.rating,
    required this.isFavorit,
    required this.sinopsis,
  });
}

// Objek data buatan sendiri 
const Buku bukuContoh = Buku(
  judul: 'Laskar Pelangi',
  penulis: 'Andrea Hirata',
  tahunTerbit: 2005,
  rating: 4.8,
  isFavorit: true,
  sinopsis:
      'Kisah sepuluh anak di Belitung yang tetap semangat bersekolah '
      'dengan segala keterbatasan. Buku ini mengajarkan arti persahabatan, '
      'mimpi, dan perjuangan.',
);

// ============================================================
// MyApp: satu-satunya MaterialApp + ThemeData
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme skemaWarna = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6D4C41), // coklat ala sampul buku
    );

    return MaterialApp(
      title: 'Katalog Buku Favorit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: skemaWarna,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        appBarTheme: AppBarTheme(
          backgroundColor: skemaWarna.primary,
          foregroundColor: skemaWarna.onPrimary,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: skemaWarna.primary,
            foregroundColor: skemaWarna.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}

// ============================================================
// HALAMAN UTAMA (Scaffold, StatefulWidget karena status favorit berubah)
// ============================================================
class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  bool _isFavorit = bukuContoh.isFavorit;

  // Callback untuk tombol
  void _ubahFavorit() {
    setState(() {
      _isFavorit = !_isFavorit;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorit ? 'Ditambahkan ke favorit' : 'Dihapus dari favorit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Buku Favorit')),
      body: SafeArea(
        child: Center(
          // Batasi lebar supaya tetap rapi di layar lebar (Chrome/tablet)
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            // Bisa di-scroll supaya tidak overflow di layar sempit/pendek
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KartuBuku(buku: bukuContoh, isFavorit: _isFavorit),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _ubahFavorit,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_isFavorit ? Icons.favorite : Icons.favorite_border),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _isFavorit
                                ? 'Hapus dari Favorit'
                                : 'Tambah ke Favorit',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CUSTOM WIDGET 1: Kartu informasi buku
// ============================================================
class KartuBuku extends StatelessWidget {
  final Buku buku;
  final bool isFavorit;

  const KartuBuku({super.key, required this.buku, required this.isFavorit});

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;
    final TextTheme teks = Theme.of(context).textTheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sampul buku (Container + BoxDecoration)
                Container(
                  width: 64,
                  height: 88,
                  decoration: BoxDecoration(
                    color: warna.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: warna.primary, width: 2),
                  ),
                  child: Icon(Icons.menu_book, size: 36, color: warna.primary),
                ),
                const SizedBox(width: 16),
                // Expanded: teks panjang turun ke bawah, tidak overflow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buku.judul,
                        style: teks.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('oleh ${buku.penulis}', style: teks.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Wrap: chip otomatis pindah baris kalau layar sempit
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChipInfo(
                  ikon: Icons.calendar_today,
                  label: 'Terbit ${buku.tahunTerbit}',
                ),
                ChipInfo(
                  ikon: Icons.star,
                  label: 'Rating ${buku.rating.toStringAsFixed(1)}',
                ),
                ChipInfo(
                  ikon: isFavorit ? Icons.favorite : Icons.favorite_border,
                  label: isFavorit ? 'Favorit' : 'Belum favorit',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(buku.sinopsis, style: teks.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// CUSTOM WIDGET 2: Chip kecil berisi ikon + teks
// ============================================================
class ChipInfo extends StatelessWidget {
  final IconData ikon;
  final String label;

  const ChipInfo({super.key, required this.ikon, required this.label});

  @override
  Widget build(BuildContext context) {
    final ColorScheme warna = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: warna.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 16, color: warna.onSecondaryContainer),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: warna.onSecondaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}