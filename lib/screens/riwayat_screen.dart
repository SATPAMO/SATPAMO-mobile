import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'course_history_screen.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  // Mata kuliah yang ada riwayat presensinya
  static const _mataKuliah = [
    'Pemrograman Mobile',
    'Sistem Operasi',
    'Jaringan Komputer',
    'Artificial Intelligence',
    'Manajemen Sistem Informasi',
    'Desain UI/UX',
    'Pemweb Framework',
    'Kewirausahaan',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header card
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RIWAYAT',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFDD00),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sistem Absensi Mahasiswa',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Mata kuliah list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              0,
              16,
              100,
            ), // padding to clear bottom nav
            itemCount: _mataKuliah.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _RiwayatTile(
                mataKuliah: _mataKuliah[index],
                onTap: () => _showDetail(context, _mataKuliah[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDetail(BuildContext context, String mataKuliah) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseHistoryScreen(mataKuliah: mataKuliah),
      ),
    );
  }
}

class _RiwayatTile extends StatelessWidget {
  const _RiwayatTile({required this.mataKuliah, required this.onTap});
  final String mataKuliah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  mataKuliah,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0C2030),
                  ),
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF0C2030),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
