import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/attendance_result.dart';
import 'result_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({
    super.key,
    this.mataKuliah = 'Pemrograman Mobile',
    this.jadwalRuang = 'Ruang 207 • Dr. Arini • 08.00-10.30',
  });

  final String mataKuliah;
  final String jadwalRuang;

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
    with SingleTickerProviderStateMixin {
  // Toggle status sesi:
  // true = "Sesi presensi aktif" (tampilan kiri di referensi)
  // false = "Sesi presensi terputus" / "KODE QR TIDAK TERBACA" (tampilan kanan di referensi)
  bool _isSessionActive = true;

  bool _isProcessing = false;

  late AnimationController _laserController;
  late Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _laserController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  void _handleSuccessfulScan([String? code]) {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Simulasi pemrosesan presensi dan menuju ResultScreen
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);

      final dummyResult = AttendanceResult(
        id: 'att-${DateTime.now().millisecondsSinceEpoch}',
        mahasiswaId: 'mhs-1',
        name: 'Mahasiswa',
        nim: '220101001',
        jurusan: 'Teknik Informatika',
        semester: 4,
        status: 'PRESENT',
        checkIn: DateTime.now().toIso8601String(),
        location: LocationVerification(
          distance: 12.5,
          isValid: true,
          campusLat: -6.200000,
          campusLon: 106.816666,
          maxRadius: 150.0,
        ),
        ai: AiVerification(
          verdict: 'APPROVED',
          isRealPerson: true,
          isFaceClear: true,
          spoofDetected: false,
          confidence: 98,
          reason: 'Valid QR Presensi',
          environment: 'Ruang 207',
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResultScreen(result: dummyResult)),
      );
    });
  }

  // Dialog untuk opsi: "Masukkan kode QR manual"
  void _showManualQrDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F263B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Input Kode QR Manual',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan kode teks yang tertera di bawah kode QR di layar proyektor.',
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              style: GoogleFonts.inter(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Contoh: SAMA-PM-2026-X9',
                hintStyle: GoogleFonts.inter(
                  color: Colors.white38,
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF00A2FE)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A2FE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _handleSuccessfulScan(controller.text);
            },
            child: Text(
              'Kirim',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk opsi: "Masukkan Kode Presensi 6-Digit"
  void _showSixDigitPinDialog() {
    final controllers = List.generate(6, (_) => TextEditingController());
    final focusNodes = List.generate(6, (_) => FocusNode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Color(0xFF0F263B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'PIN',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kode Presensi 6-Digit',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'PIN cadangan dari slide dosen di kelas',
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              // 6 kotak input PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 44,
                    height: 52,
                    child: TextField(
                      controller: controllers[i],
                      focusNode: focusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF38BDF8),
                            width: 1.5,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val.isNotEmpty && i < 5) {
                          focusNodes[i + 1].requestFocus();
                        } else if (val.isEmpty && i > 0) {
                          focusNodes[i - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A2FE),
                  minimumSize: const Size.fromHeight(46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final code = controllers.map((c) => c.text).join();
                  Navigator.of(ctx).pop();
                  _handleSuccessfulScan(code);
                },
                child: Text(
                  'Verifikasi Presensi',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A2FE), Color(0xFF0D6FA8), Color(0xFF071926)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.40, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 1. Top Brand "SATPAMO" (kuning tebal di tengah) ───────────
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'SATPAMO',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFFDD00),
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── 2. Header Bar: Tombol Kembali & Judul "Scan QR Absen" ────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Tombol kembali berbentuk lingkaran transparan
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan QR Absen',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Pindai kode QR di ruang kelas',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFD0EEFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── 3. Main Glass Card Container (sesuai persis dengan gambar) ─
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.28),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ── Baris Info Matkul & Badge Status ────────────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.mataKuliah,
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.jadwalRuang,
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF475569),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Badge: "Sesi presensi aktif" ATAU "Sesi presensi terputus"
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isSessionActive
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _isSessionActive
                                          ? const Color(0xFF86EFAC)
                                          : const Color(0xFFFCA5A5),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    _isSessionActive
                                        ? 'Sesi presensi aktif'
                                        : 'Sesi presensi terputus',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: _isSessionActive
                                          ? const Color(0xFF15803D)
                                          : const Color(0xFFB91C1C),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // ── Area Viewfinder QR Scanner Besar ───────────
                            GestureDetector(
                              onTap: () {
                                if (_isSessionActive) {
                                  _handleSuccessfulScan();
                                }
                              },
                              child: Container(
                                height: 280,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: _isSessionActive
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xFFE0F2FE)
                                                .withValues(alpha: 0.85),
                                            const Color(0xFFBAE6FD)
                                                .withValues(alpha: 0.60),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : LinearGradient(
                                          colors: [
                                            const Color(0xFFEF4444)
                                                .withValues(alpha: 0.35),
                                            const Color(0xFF7F1D1D)
                                                .withValues(alpha: 0.50),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                  border: Border.all(
                                    color: _isSessionActive
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : const Color(0xFFEF4444)
                                              .withValues(alpha: 0.7),
                                    width: 1.5,
                                  ),
                                ),
                                child: _isSessionActive
                                    ? _buildActiveQrScanner()
                                    : _buildDisconnectedQrError(),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // ── Baris Keterangan di Bawah Scanner ───────────
                            Row(
                              children: [
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.20),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_2_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Arahkan kamera ke QR absen di ruang kelas untuk memulai presensi.',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.88,
                                      ),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // ── Pilihan 1: Masukkan kode QR manual ──────────
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _showManualQrDialog,
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0284C7),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.image_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Masukkan kode QR manual jika pemindaian tidak berhasil',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // ── Pilihan 2: Masukkan Kode Presensi 6-Digit ──
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _showSixDigitPinDialog,
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0284C7),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'PIN',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Masukkan Kode Presensi 6-Digit',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Pin cadangan dari slide dosen di kelas',
                                              style: GoogleFonts.inter(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white.withValues(
                                                  alpha: 0.65,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Input',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF38BDF8),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_forward_rounded,
                                            size: 16,
                                            color: Color(0xFF38BDF8),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Switcher Pengujian: Aktif vs Terputus ───────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.75),
                    ),
                    onPressed: () {
                      setState(() => _isSessionActive = !_isSessionActive);
                    },
                    icon: Icon(
                      _isSessionActive
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 16,
                    ),
                    label: Text(
                      _isSessionActive
                          ? 'Simulasikan "Sesi presensi terputus"'
                          : 'Simulasikan "Sesi presensi aktif"',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
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

  // ── Tampilan 1: Scanner QR Aktif (Kiri pada gambar) ────────────────────────
  Widget _buildActiveQrScanner() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const _AuthenticQrCodeGraphic(size: 104),
                // Garis pemindai animasi di bawah kode QR
                AnimatedBuilder(
                  animation: _laserAnimation,
                  builder: (context, child) {
                    return Positioned(
                      top: 14 + (_laserAnimation.value * 105),
                      child: Container(
                        width: 110,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D4ED8),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1D4ED8)
                                  .withValues(alpha: 0.6),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ketuk QR untuk simulasi presensi',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A).withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tampilan 2: Sesi Terputus / Kode QR Tidak Terbaca (Kanan pada gambar) ───
  Widget _buildDisconnectedQrError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ikon QR samar dengan tanda seru merah di pojok kanan bawah
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: _AuthenticQrCodeGraphic(
                      size: 64,
                      color: Colors.black45,
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC2626),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'KODE QR TIDAK TERBACA',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Pastikan QR code utuh, bersih, dan\ntidak buram di layar',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widget Grafis Kode QR Otentik Presisi ────────────────────────────────────
class _AuthenticQrCodeGraphic extends StatelessWidget {
  const _AuthenticQrCodeGraphic({
    required this.size,
    this.color = const Color(0xFF111827),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _QrPainter(color: color),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cell = size.width / 13.0;

    void drawBlock(int col, int row, int w, int h) {
      canvas.drawRect(
        Rect.fromLTWH(col * cell, row * cell, w * cell, h * cell),
        paint,
      );
    }

    void drawFinder(int startCol, int startRow) {
      // Outer 4x4
      drawBlock(startCol, startRow, 4, 1);
      drawBlock(startCol, startRow + 3, 4, 1);
      drawBlock(startCol, startRow + 1, 1, 2);
      drawBlock(startCol + 3, startRow + 1, 1, 2);
      // Center 2x2
      drawBlock(startCol + 1, startRow + 1, 2, 2);
    }

    // Tiga sudut Finder Pattern (khas QR code)
    drawFinder(0, 0); // Top-left
    drawFinder(9, 0); // Top-right
    drawFinder(0, 9); // Bottom-left

    // Pola data di tengah dan kanan bawah
    drawBlock(5, 1, 2, 2);
    drawBlock(5, 5, 3, 3);
    drawBlock(9, 5, 2, 2);
    drawBlock(7, 9, 2, 2);
    drawBlock(10, 8, 2, 4);
    drawBlock(6, 11, 2, 2);
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) =>
      oldDelegate.color != color;
}
