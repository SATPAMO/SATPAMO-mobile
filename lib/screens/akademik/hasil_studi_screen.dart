import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HasilStudiScreen extends StatelessWidget {
  const HasilStudiScreen({super.key});

  static const List<_SemesterSummary> _semesterList = [
    _SemesterSummary(
      title: 'Semester 2026 Genap',
      ipBeban: '4.00',
      sks: '20',
      matkul: '8',
      ipk: '4.00',
    ),
    _SemesterSummary(
      title: 'Semester 2026 Ganjil',
      ipBeban: '4.00',
      sks: '20',
      matkul: '8',
      ipk: '4.00',
    ),
    _SemesterSummary(
      title: 'Semester 2025 Genap',
      ipBeban: '4.00',
      sks: '20',
      matkul: '8',
      ipk: '4.00',
    ),
    _SemesterSummary(
      title: 'Semester 2025 Ganjil',
      ipBeban: '4.00',
      sks: '20',
      matkul: '8',
      ipk: '4.00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00A2FE), // Biru langit cerah
              Color(0xFF0D6FA8), // Transisi biru sedang
              Color(0xFF0B1E2B), // Biru gelap bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar: Tombol Kembali + Title SATPAMO
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Kembali',
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 38),
                          child: Text(
                            'SATPAMO',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFDD00),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title Card Banner: HASIL STUDI
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HASIL STUDI',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFDD00),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rekap IPS Beban & IPS Lulus',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // List Kartu Semester Rekap Hasil Studi
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _semesterList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = _semesterList[index];
                    return _SemesterSummaryCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SemesterSummary {
  final String title;
  final String ipBeban;
  final String sks;
  final String matkul;
  final String ipk;

  const _SemesterSummary({
    required this.title,
    required this.ipBeban,
    required this.sks,
    required this.matkul,
    required this.ipk,
  });
}

class _SemesterSummaryCard extends StatelessWidget {
  final _SemesterSummary item;

  const _SemesterSummaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.32),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              // Judul Semester (Tengah)
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0C2030),
                ),
              ),

              const SizedBox(height: 12),

              // Row 4 Kotak Metrik (IP Beban, SKS, Matkul, IPK)
              Row(
                children: [
                  // 1. IP Beban (Kotak Putih)
                  Expanded(
                    child: _MetricBox(
                      value: item.ipBeban,
                      label: 'IP Beban',
                      isYellow: false,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 2. SKS (Kotak Kuning Muda)
                  Expanded(
                    child: _MetricBox(
                      value: item.sks,
                      label: 'SKS',
                      isYellow: true,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 3. Matkul (Kotak Putih)
                  Expanded(
                    child: _MetricBox(
                      value: item.matkul,
                      label: 'Matkul',
                      isYellow: false,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 4. IPK (Kotak Kuning Muda)
                  Expanded(
                    child: _MetricBox(
                      value: item.ipk,
                      label: 'IPK',
                      isYellow: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String value;
  final String label;
  final bool isYellow;

  const _MetricBox({
    required this.value,
    required this.label,
    required this.isYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isYellow ? const Color(0xFFFEF9C3) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1B3A54),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
