import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseHistoryScreen extends StatelessWidget {
  final String mataKuliah;

  const CourseHistoryScreen({super.key, required this.mataKuliah});

  // Dummy per-session data; in production wire to API
  static const _dummyHistory = [
    {'bab': 3, 'status': 'HADIR'},
    {'bab': 2, 'status': 'ALPHA'},
    {'bab': 1, 'status': 'IZIN'},
  ];

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'HADIR':
        return Colors.greenAccent.shade400;
      case 'ALPHA':
        return Colors.red.shade400;
      case 'IZIN':
        return Colors.yellow.shade400;
      default:
        return Colors.white;
    }
  }

  Color _getInnerBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'HADIR':
        return Colors.greenAccent.withValues(alpha: 0.15);
      case 'ALPHA':
        return Colors.red.withValues(alpha: 0.15);
      case 'IZIN':
        return Colors.yellow.withValues(alpha: 0.15);
      default:
        return Colors.white.withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A2FE), Color(0xFF0C2030)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'RIWAYAT',
                      style: GoogleFonts.inter(
                        color: Colors.yellowAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Icon(Icons.notifications, color: Colors.white, size: 32),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  children: [
                    // Course Title Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            mataKuliah,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // History Items
                    ..._dummyHistory.map((data) {
                      final bab = data['bab'] as int;
                      final status = data['status'] as String;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Capaian Pembelajaran : BAB $bab',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF0C2030), // Dark text to match the mockup's readability if any, or keep it white? The mockup shows dark text for Capaian Pembelajaran.
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _getInnerBgColor(status),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getStatusColor(status).withValues(alpha: 0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Catatan ;',
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF0C2030),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          status,
                                          style: GoogleFonts.inter(
                                            color: _getStatusColor(status),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.2,
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
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
