import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // padding to clear bottom nav
            itemCount: _mataKuliah.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _RiwayatDetailSheet(mataKuliah: mataKuliah),
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

// Detail sheet per mata kuliah
class _RiwayatDetailSheet extends StatelessWidget {
  const _RiwayatDetailSheet({required this.mataKuliah});
  final String mataKuliah;

  // Dummy per-session data; in production wire to API
  static final _dummyRows = [
    _AttRow(pertemuan: 1, tanggal: '02 Sep 2026', status: 'Hadir'),
    _AttRow(pertemuan: 2, tanggal: '09 Sep 2026', status: 'Hadir'),
    _AttRow(pertemuan: 3, tanggal: '16 Sep 2026', status: 'Izin'),
    _AttRow(pertemuan: 4, tanggal: '23 Sep 2026', status: 'Hadir'),
    _AttRow(pertemuan: 5, tanggal: '28 Sep 2026', status: 'Alpha'),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F263B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0072DF), Color(0xFF004FA4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      mataKuliah,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Summary chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _SummaryChip(label: 'Hadir', value: '3x', color: const Color(0xFF00C970)),
                  const SizedBox(width: 8),
                  _SummaryChip(label: 'Izin', value: '1x', color: const Color(0xFFFFD600)),
                  const SizedBox(width: 8),
                  _SummaryChip(label: 'Alpha', value: '1x', color: const Color(0xFFEF5350)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white12, height: 1),
            // Table header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      'No.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tanggal',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            // Rows
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: _dummyRows.length,
                itemBuilder: (_, i) => _AttendanceRow(row: _dummyRows[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttRow {
  const _AttRow({
    required this.pertemuan,
    required this.tanggal,
    required this.status,
  });
  final int pertemuan;
  final String tanggal;
  final String status;
}

class _AttendanceRow extends StatelessWidget {
  const _AttendanceRow({required this.row});
  final _AttRow row;

  Color get _statusColor {
    switch (row.status) {
      case 'Hadir':
        return const Color(0xFF00C970);
      case 'Izin':
        return const Color(0xFFFFD600);
      default:
        return const Color(0xFFEF5350);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '${row.pertemuan}',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.tanggal,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _statusColor.withValues(alpha: 0.4)),
            ),
            child: Text(
              row.status,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
