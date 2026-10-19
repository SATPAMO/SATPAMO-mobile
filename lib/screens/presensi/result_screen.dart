import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/attendance_result.dart';
import '../dashboard/dashboard_screen.dart';

class ResultScreen extends StatelessWidget {
  final AttendanceResult result;
  final String mataKuliah;
  final String jadwalRuang;

  const ResultScreen({
    super.key,
    required this.result,
    this.mataKuliah = 'Pemrograman Mobile',
    this.jadwalRuang = 'Ruang 207 • Dr. Arini • 08.00-10.30',
  });

  String _formatRadiusText() {
    if (result.location != null && result.location!.distance > 0) {
      return '${result.location!.distance.round()} Meter';
    }
    return '8 Meter';
  }

  String _formatStatusText() {
    switch (result.status.toUpperCase()) {
      case 'PRESENT':
        return 'Hadir';
      case 'LATE':
        return 'Terlambat';
      case 'IZIN':
        return 'Izin';
      default:
        return 'Ditolak';
    }
  }

  Color _formatStatusColor() {
    switch (result.status.toUpperCase()) {
      case 'PRESENT':
        return const Color(0xFF059669);
      case 'LATE':
        return const Color(0xFFD97706);
      case 'IZIN':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFFDC2626);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF00A2FE), // Biru langit cerah (atas)
              Color(0xFF0D6FA8), // Transisi biru sedang
              Color(0xFF0B1E2B), // Biru gelap (bawah)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 14),

              // Title SATPAMO
              Text(
                'SATPAMO',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFFFDD00),
                  letterSpacing: 2.0,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Card Hasil Presensi (Glassmorphism)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(26),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                22,
                                26,
                                22,
                                22,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.12),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // 1. Icon Sukses
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF00A2FE),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 42,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  // 2. Headline
                                  Text(
                                    'Presensi berhasil!',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF0C2030),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // 3. Subheadline
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      'Kehadiranmu telah tercatat untuk sesi ini. Selamat mengikuti perkuliahan.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF1E3A5F)
                                            .withValues(alpha: 0.85),
                                        height: 1.35,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // 4. Section Label
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'RINGKASAN PRESENSI',
                                      style: GoogleFonts.inter(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.1,
                                        color: const Color(0xFF1E3A5F)
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // 5. Nama Mata Kuliah & Jadwal
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      mataKuliah,
                                      style: GoogleFonts.inter(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0C2030),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      jadwalRuang,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF1E3A5F)
                                            .withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  // 6. Grid Ringkasan (Status, Jadwal Sesi, Radius GPS)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Status Kehadiran
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.35,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.done_all_rounded,
                                                size: 16,
                                                color: Color(0xFF0C2030),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Status kehadiran',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      color: const Color(
                                                        0xFF1E3A5F,
                                                      ).withValues(alpha: 0.75),
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatStatusText(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          _formatStatusColor(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Jadwal Sesi
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.35,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.calendar_today_rounded,
                                                size: 14,
                                                color: Color(0xFF0C2030),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Jadwal sesi',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 10.5,
                                                      color: const Color(
                                                        0xFF1E3A5F,
                                                      ).withValues(alpha: 0.75),
                                                    ),
                                                  ),
                                                  Text(
                                                    '08.00-10.30',
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: const Color(
                                                        0xFF0C2030,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Baris Radius GPS
                                  Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.35,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.location_on_outlined,
                                          size: 16,
                                          color: Color(0xFF0C2030),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Radius GPS',
                                            style: GoogleFonts.inter(
                                              fontSize: 10.5,
                                              color: const Color(0xFF1E3A5F)
                                                  .withValues(alpha: 0.75),
                                            ),
                                          ),
                                          Text(
                                            _formatRadiusText(),
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF0C2030),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  // 7. Banner Verifikasi Kamera
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.22,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.4,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt_outlined,
                                            color: Color(0xFF0C2030),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Verifikasi kamera berhasil',
                                                style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(
                                                    0xFF0C2030,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Presensi melalui kamera langsung.',
                                                style: GoogleFonts.inter(
                                                  fontSize: 11,
                                                  color: const Color(0xFF1E3A5F)
                                                      .withValues(alpha: 0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 22),

                                  // 8. Tombol Kembali ke Beranda
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const DashboardScreen(),
                                              ),
                                              (route) => false,
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.home_outlined,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Kembali ke Beranda',
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF00A2FE,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Subtitle Bawah
                        Text(
                          'Presensi ini tersimpan di riwayat kehadiranmu.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
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
