import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'check_in_screen.dart';
import 'riwayat_screen.dart';
import 'scan_qr_screen.dart';
import 'pengajuan_izin_screen.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key, this.isStandalone = false});

  final bool isStandalone;

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  // Toggle untuk mendemonstrasikan kedua kondisi:
  // true = Dosen sudah membuat/membuka sesi presensi (ada kartu 'BELUM ABSEN')
  // false = Dosen belum membuat absensi (tampilan kosong / menunggu sesi dimulai)
  bool _isSessionAvailable = true;

  void _showIzinDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: const BoxDecoration(
          color: Color(0xFF0F263B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD600),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF0A1926),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Pengajuan Izin',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Form pengajuan izin presensi untuk mata kuliah Pemrograman Mobile.',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A2FE),
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PengajuanIzinScreen(
                      initialMataKuliah: 'Pemrograman Mobile',
                    ),
                  ),
                );
              },
              child: Text(
                'Lanjutkan Pengajuan',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCheckIn() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CheckInScreen()));
  }

  void _openScanQR() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ScanQrScreen()));
  }

  void _openRiwayat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00A2FE),
                  Color(0xFF0D6FA8),
                  Color(0xFF0B1E2B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Text(
                            'SATPAMO',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFDD00),
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const Expanded(child: RiwayatScreen()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner card atas: "ABSENSI MAHASISWA / Presensi Mata Kuliah"
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
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
                      'ABSENSI  MAHASISWA',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFFDD00),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Presensi Mata Kuliah',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.90),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Card: "Ringkasan absensi"
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.32),
                    width: 1.2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header row: "Ringkasan absensi" & nama mata kuliah
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ringkasan absensi',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Pemrograman Mobile',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    if (_isSessionAvailable) ...[
                      // Kondisi 1: Dosen sudah membuat sesi absensi
                      Row(
                        children: [
                          Expanded(
                            child: _StatBox(label: 'Hadir', value: '11x'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatBox(label: 'Izin', value: '2x'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatBox(label: 'Alpha', value: '2x'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Tombol "BELUM ABSEN" (mengarahkan ke Check In Screen)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _openCheckIn,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFEF5350),
                                width: 1.2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'BELUM ABSEN',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFB71C1C),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Kondisi 2: Dosen belum membuat absensi (sesuai pertanyaan pengguna)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.50),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ),
                              child: const Icon(
                                Icons.hourglass_empty_rounded,
                                color: Color(0xFF64748B),
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Belum Ada Sesi Presensi Aktif',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dosen belum membuka sesi absensi untuk mata kuliah ini. Halaman presensi akan aktif saat dosen memulai sesi.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                height: 1.4,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0284C7),
                                side: const BorderSide(
                                  color: Color(0xFF0284C7),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() => _isSessionAvailable = true);
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: Text(
                                'Cek Sesi Presensi',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // 3 Action cards di bawah (Scan QR, Izin, Riwayat) persis seperti di gambar
          Row(
            children: [
              // 1. Scan QR (Absen cepat)
              Expanded(
                child: _QuickActionCard(
                  iconWidget: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      color: Colors.black87,
                      size: 22,
                    ),
                  ),
                  title: 'Scan QR',
                  subtitle: 'Absen cepat',
                  onTap: _openScanQR,
                ),
              ),

              const SizedBox(width: 10),

              // 2. Izin (Ajukan cuti)
              Expanded(
                child: _QuickActionCard(
                  iconWidget: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDD00),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'I',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  title: 'Izin',
                  subtitle: 'Ajukan cuti',
                  onTap: _showIzinDialog,
                ),
              ),

              const SizedBox(width: 10),

              // 3. Riwayat (Lihat riwayat)
              Expanded(
                child: _QuickActionCard(
                  iconWidget: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  title: 'Riwayat',
                  subtitle: 'Lihat riwayat',
                  onTap: _openRiwayat,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tombol simulasi switch status untuk melihat tampilan kosong vs aktif
          Center(
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.75),
              ),
              onPressed: () {
                setState(() => _isSessionAvailable = !_isSessionAvailable);
              },
              icon: Icon(
                _isSessionAvailable
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 16,
              ),
              label: Text(
                _isSessionAvailable
                    ? 'Simulasikan Dosen Belum Buat Absensi (Kosong)'
                    : 'Simulasikan Sesi Absensi Aktif',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isStandalone) return _buildContent();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A2FE), Color(0xFF0D6FA8), Color(0xFF0B1E2B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar persis seperti gambar 1: tombol kembali `<` dan teks "SATPAMO"
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'SATPAMO',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFFFDD00),
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // balance back button
                  ],
                ),
              ),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget kotak statistik (Hadir, Izin, Alpha) ──────────────────────────────
class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget tombol aksi cepat (Scan QR, Izin, Riwayat) ────────────────────────
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.26),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconWidget,
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
