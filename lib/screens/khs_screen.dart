import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KhsScreen extends StatefulWidget {
  const KhsScreen({super.key});

  @override
  State<KhsScreen> createState() => _KhsScreenState();
}

class _KhsScreenState extends State<KhsScreen> {
  final List<String> _semesters = [
    'Semester 4 (2026 Genap)',
    'Semester 3 (2026 Ganjil)',
    'Semester 2 (2025 Genap)',
    'Semester 1 (2025 Ganjil)',
  ];
  String? _selectedSemester;

  final List<String> _jenisSemesters = ['Reguler', 'Pendek'];
  String _selectedJenis = 'Reguler';

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

              // Title Card Banner: KARTU HASIL STUDI
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
                            'KARTU HASIL STUDI',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFDD00),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sistem Absensi Mahasiswa',
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

              // Filter Card: Pilih Semester & Jenis Semester
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
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
                          // Baris 1: Pilih Semester
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'Pilih Semester:',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0C2030),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFF1E3A5F),
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedSemester,
                                      isDense: true,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color(0xFF0C2030),
                                      ),
                                      hint: Text(
                                        'Pilih semester...',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5,
                                          color: const Color(0xFF1E3A5F)
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      dropdownColor: const Color(0xFF0D6FA8),
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0C2030),
                                      ),
                                      items: _semesters.map((s) {
                                        return DropdownMenuItem<String>(
                                          value: s,
                                          child: Text(
                                            s,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _selectedSemester = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          // Baris 2: Jenis Semester
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  'Jenis Semester:',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0C2030),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xFF1E3A5F),
                                        width: 1.2,
                                      ),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedJenis,
                                      isDense: true,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Color(0xFF0C2030),
                                      ),
                                      dropdownColor: const Color(0xFF0D6FA8),
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0C2030),
                                      ),
                                      items: _jenisSemesters.map((j) {
                                        return DropdownMenuItem<String>(
                                          value: j,
                                          child: Text(
                                            j,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() => _selectedJenis = val);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // Tampilan "Tidak ada KHS" (Persis seperti mockup)
              Center(
                child: Text(
                  'Tidak ada KHS',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0C2030),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
