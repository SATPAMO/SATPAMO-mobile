import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'course_history_screen.dart';

class JadwalPresensiScreen extends StatelessWidget {
  const JadwalPresensiScreen({super.key});

  static const List<_DaySchedule> _scheduleData = [
    _DaySchedule(
      day: 'Kelas hari Senin',
      courseCount: 2,
      courses: [
        _CourseItem(
          sks: 4,
          name: 'Pemrograman Mobile',
          details: 'Ruang 207 • Mas Arfan • 07.00-10.30',
          attendanceRate: '92%',
        ),
        _CourseItem(
          sks: 2,
          name: 'Sistem Operasi',
          details: 'Ruang 304 • Pak Budi • 10.30-12.10',
          attendanceRate: '92%',
        ),
      ],
    ),
    _DaySchedule(
      day: 'Kelas hari Selasa',
      courseCount: 3,
      courses: [
        _CourseItem(
          sks: 4,
          name: 'Komputer Jaringan',
          details: 'Ruang 207 • Dr. Arini • 07.00-10.30',
          attendanceRate: '92%',
        ),
        _CourseItem(
          sks: 2,
          name: 'Kecerdasan Buatan',
          details: 'Ruang 304 • Pak Budi • 10.30-12.10',
          attendanceRate: '92%',
        ),
        _CourseItem(
          sks: 2,
          name: 'Manajemen Sistem Informasi',
          details: 'Ruang 304 • Pak Budi • 10.30-12.10',
          attendanceRate: '92%',
        ),
      ],
    ),
    _DaySchedule(
      day: 'Kelas hari Rabu',
      courseCount: 2,
      courses: [
        _CourseItem(
          sks: 3,
          name: 'Desain UI/UX',
          details: 'Ruang 207 • Dr. Arini • 07.00-10.30',
          attendanceRate: '92%',
        ),
        _CourseItem(
          sks: 3,
          name: 'Pemweb Framework',
          details: 'Ruang 304 • Pak Budi • 11.30-12.10',
          attendanceRate: '92%',
        ),
      ],
    ),
    _DaySchedule(
      day: 'Kelas hari Kamis',
      courseCount: 1,
      courses: [
        _CourseItem(
          sks: 2,
          name: 'Kewirausahaan',
          details: 'Ruang 207 • Dr. Arini • 07.00-10.30',
          attendanceRate: '92%',
        ),
      ],
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
                          padding: const EdgeInsets.only(
                            right: 38,
                          ), // Center balance
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

              // Title Card Banner: JADWAL & PRESENSI
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
                            'JADWAL & PRESENSI',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFDD00),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jadwal Mata Kuliah dan Presensi',
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

              // Daftar Jadwal Semua Hari & Mata Kuliah
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  itemCount: _scheduleData.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final daySchedule = _scheduleData[index];
                    return _DayScheduleCard(daySchedule: daySchedule);
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

class _DaySchedule {
  final String day;
  final int courseCount;
  final List<_CourseItem> courses;

  const _DaySchedule({
    required this.day,
    required this.courseCount,
    required this.courses,
  });
}

class _CourseItem {
  final int sks;
  final String name;
  final String details;
  final String attendanceRate;

  const _CourseItem({
    required this.sks,
    required this.name,
    required this.details,
    required this.attendanceRate,
  });
}

class _DayScheduleCard extends StatelessWidget {
  final _DaySchedule daySchedule;

  const _DayScheduleCard({required this.daySchedule});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Hari + Badge Jumlah Matkul
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    daySchedule.day,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0C2030),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0072DF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${daySchedule.courseCount} Matkul',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // List Mata Kuliah pada Hari Tersebut
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daySchedule.courses.length,
                separatorBuilder: (context, i) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final course = daySchedule.courses[i];
                  return _CourseItemTile(course: course);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseItemTile extends StatelessWidget {
  final _CourseItem course;

  const _CourseItemTile({required this.course});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CourseHistoryScreen(mataKuliah: course.name),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.32),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // SKS Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0072DF), Color(0xFF004FA4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${course.sks} SKS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Detail Mata Kuliah & Dosen / Ruangan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0C2030),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      course.details,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF1E3A5F).withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Pill Persentase Kehadiran
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  course.attendanceRate,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D9488), // Teal green
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
