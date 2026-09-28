import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'check_in_screen.dart';
import 'login_screen.dart';
import 'menu_screen.dart';
import 'riwayat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeNavIndex = 0;
  String _userName = 'Mahasiswa';
  String _userInitials = 'M';

  // Palette: teal-cyan → navy. Same identity as login screen.
  static const Color _bgTop = Color(0xFF00A2FE);
  static const Color _bgMid = Color(0xFF0D6FA8);
  static const Color _bgBottom = Color(0xFF0B1E2B);

  // Single accent: used only for the badge and one CTA context.
  static const Color _accent = Color(0xFF0066CC);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('userName')?.trim();
      
      if (!mounted) return;
      if (name != null && name.isNotEmpty) {
        setState(() {
          _userName = name;
          _userInitials = _extractInitials(name);
        });
      }
    } catch (_) {
      // Fallback
    }
  }

  String _extractInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'YK';
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F263B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Konfirmasi Logout',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Batal',
              style: GoogleFonts.inter(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.clearToken();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showIzinSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _IzinSheet(
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  void _showRiwayatSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _RiwayatSheet(
        onClose: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  void _openCheckIn() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckInScreen()),
    );
  }

  // HOME page body (index 0)
  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const SizedBox(height: 16),
          _buildGreetingCard(),
          const SizedBox(height: 20),
          _buildTodayClassesSection(),
          const SizedBox(height: 20),
          _buildAttendanceSummarySection(),
          const SizedBox(height: 20),
          _buildQuickActions(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // MENU page body (index 1)
  Widget _buildMenuPage() {
    return Column(
      children: [
        // Reuse the same top bar for brand consistency
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: _buildTopBar(),
        ),
        const Expanded(child: MenuScreen()),
      ],
    );
  }

  // RIWAYAT page body (index 2)
  Widget _buildRiwayatPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: _buildTopBar(),
        ),
        const Expanded(child: RiwayatScreen()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgTop, _bgMid, _bgBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // IndexedStack keeps each tab alive while switching
              IndexedStack(
                index: _activeNavIndex > 2 ? 0 : _activeNavIndex,
                children: [
                  _buildHomePage(),
                  _buildMenuPage(),
                  _buildRiwayatPage(),
                ],
              ),
              // Floating bottom nav: the one glassmorphism accent in the nav area.
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: _buildFloatingBottomNav(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Drawer ──────────────────────────────────────────────────────────────────

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0B1E2B),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  _AvatarCircle(initials: _userInitials, size: 52),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Mahasiswa Aktif',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF00D97E),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            ListTile(
              leading: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white70,
              ),
              title: Text(
                'Presensi QR / Selfie',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _openCheckIn();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_rounded, color: Colors.white70),
              title: Text(
                'Riwayat Presensi',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showRiwayatSheet();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.description_outlined,
                color: Colors.white70,
              ),
              title: Text(
                'Pengajuan Cuti / Izin',
                style: GoogleFonts.inter(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _showIzinSheet();
              },
            ),
            const Spacer(),
            const Divider(color: Colors.white12, height: 1),
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF5350),
              ),
              title: Text(
                'Keluar Akun',
                style: GoogleFonts.inter(
                  color: const Color(0xFFEF5350),
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _handleLogout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Top bar ─────────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
            tooltip: 'Buka menu',
          ),
        ),
        Text(
          'SATPAMO',
          style: GoogleFonts.inter(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFFFDD00),
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_rounded,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Tidak ada notifikasi baru.',
                  style: GoogleFonts.inter(),
                ),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          tooltip: 'Notifikasi',
        ),
      ],
    );
  }

  // ── Greeting card: glass accent #1 ──────────────────────────────────────────

  Widget _buildGreetingCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              _AvatarCircle(initials: _userInitials, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, $_userName',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0C2030),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Selamat datang kembali di SATPAMO',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF1B3A54),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (ctx) => InkWell(
                  onTap: () => Scaffold.of(ctx).openDrawer(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      color: Color(0xFF0C2030),
                      size: 26,
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

  // ── Today classes: glass accent #2 ──────────────────────────────────────────

  Widget _buildTodayClassesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kelas hari ini',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '2 Matkul',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
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
                  _ClassRow(
                    time: '08:00',
                    subject: 'Pemrograman Mobile',
                    room: 'Ruang 207 • Dr. Arini',
                    isPresent: true,
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.white24,
                    height: 1,
                    thickness: 0.5,
                  ),
                  const SizedBox(height: 10),
                  _ClassRow(
                    time: '10:30',
                    subject: 'Sistem Operasi',
                    room: 'Ruang 304 • Pak Budi',
                    isPresent: false,
                    onTap: _openCheckIn,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Attendance summary: solid surface (no extra glass; dose cap R-10) ────────

  Widget _buildAttendanceSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ringkasan absensi',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'Pemrograman Mobile',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryBox(label: 'Hadir', value: '12x'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SummaryBox(label: 'Izin', value: '2x'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SummaryBox(label: 'Alpha', value: '1x'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x3310B981),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0x5510B981),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00C970),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '92%',
                        style: GoogleFonts.inter(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Presensi bulan ini sudah 92% dari target. Lanjutkan konsistensi!',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.35,
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
    );
  }

  // ── Quick actions ────────────────────────────────────────────────────────────

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            iconWidget: const Icon(
              Icons.qr_code_2_rounded,
              color: Color(0xFF0C2030),
              size: 24,
            ),
            iconBg: Colors.white,
            title: 'Scan QR',
            subtitle: 'Absen cepat',
            onTap: _openCheckIn,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            iconWidget: Text(
              '!',
              style: GoogleFonts.inter(
                color: const Color(0xFF0C2030),
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            iconBg: const Color(0xFFFFD600),
            title: 'Izin',
            subtitle: 'Ajukan cuti',
            onTap: _showIzinSheet,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            iconWidget: const Icon(
              Icons.history_rounded,
              color: Colors.white,
              size: 24,
            ),
            iconBg: const Color(0xFF00C970),
            title: 'Riwayat',
            subtitle: 'Lihat riwayat',
            onTap: _showRiwayatSheet,
          ),
        ),
      ],
    );
  }

  // ── Floating bottom nav: glass accent #3 (nav pill) ─────────────────────────

  Widget _buildFloatingBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(36),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xE20B1A26),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AnimatedNavItem(
                icon: Icons.home_rounded,
                label: 'HOME',
                isActive: _activeNavIndex == 0,
                onTap: () => setState(() => _activeNavIndex = 0),
              ),
              Builder(
                builder: (ctx) => _AnimatedNavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'MENU',
                  isActive: _activeNavIndex == 1,
                  onTap: () {
                    setState(() => _activeNavIndex = 1);
                  },
                ),
              ),
              _AnimatedNavItem(
                icon: Icons.assignment_outlined,
                label: 'RIWAYAT',
                isActive: _activeNavIndex == 2,
                onTap: () {
                  setState(() => _activeNavIndex = 2);
                },
              ),
              Builder(
                builder: (ctx) => _AnimatedNavItem(
                  icon: Icons.account_circle_outlined,
                  label: 'PROFILE',
                  isActive: _activeNavIndex == 3,
                  onTap: () {
                    setState(() => _activeNavIndex = 3);
                    Scaffold.of(ctx).openDrawer();
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

// ── Shared small widgets ─────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.initials, required this.size});
  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF0072DF), Color(0xFF004FA4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.35,
        ),
      ),
    );
  }
}

class _ClassRow extends StatelessWidget {
  const _ClassRow({
    required this.time,
    required this.subject,
    required this.room,
    required this.isPresent,
    this.onTap,
  });
  final String time;
  final String subject;
  final String room;
  final bool isPresent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0078E6), Color(0xFF0052B4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0C2030),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF2A5472),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPresent
                      ? const Color(0xFFD2F7DF)
                      : const Color(0xFFFFE0D4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isPresent ? 'Sudah absen' : 'Belum absen',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPresent
                        ? const Color(0xFF1A7A42)
                        : const Color(0xFFD04515),
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

class _SummaryBox extends StatelessWidget {
  const _SummaryBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.iconWidget,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final Widget iconWidget;
  final Color iconBg;
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.20),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: iconWidget,
              ),
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
                  fontSize: 10.5,
                  color: Colors.white.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        width: isActive ? 54 : 48,
        height: isActive ? 54 : 48,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF7DD8F8) : Colors.transparent,
          borderRadius: BorderRadius.circular(isActive ? 27 : 14),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF7DD8F8).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white54,
              size: 22,
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              style: GoogleFonts.inter(
                color: isActive ? Colors.white : Colors.white54,
                fontSize: isActive ? 8 : 8.5,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0.4,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet: Izin ───────────────────────────────────────────────────────

class _IzinSheet extends StatelessWidget {
  const _IzinSheet({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: Color(0xFF0F263B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ajukan Izin / Cuti',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Fitur pengajuan izin digital sedang disinkronkan dengan sistem portal akademik.',
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0072DF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onClose,
              child: Text(
                'Tutup',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet: Riwayat ────────────────────────────────────────────────────

class _RiwayatSheet extends StatelessWidget {
  const _RiwayatSheet({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: Color(0xFF00C970),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Riwayat Presensi',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _RiwayatItem(
            title: 'Pemrograman Mobile',
            time: 'Hari ini, 08:12 WIB',
            status: 'Hadir Tepat Waktu',
            isSuccess: true,
          ),
          const SizedBox(height: 8),
          _RiwayatItem(
            title: 'Rekayasa Perangkat Lunak',
            time: 'Kemarin, 13:05 WIB',
            status: 'Hadir Tepat Waktu',
            isSuccess: true,
          ),
          const SizedBox(height: 8),
          _RiwayatItem(
            title: 'Basis Data Lanjut',
            time: '19 Sep 2026, 10:15 WIB',
            status: 'Izin Sakit',
            isSuccess: false,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0072DF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onClose,
              child: Text(
                'Tutup',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiwayatItem extends StatelessWidget {
  const _RiwayatItem({
    required this.title,
    required this.time,
    required this.status,
    required this.isSuccess,
  });
  final String title;
  final String time;
  final String status;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_rounded : Icons.info_rounded,
            color: isSuccess ? const Color(0xFF00C970) : const Color(0xFFFFD600),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: GoogleFonts.inter(
              color: isSuccess
                  ? const Color(0xFF00C970)
                  : const Color(0xFFFFD600),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
