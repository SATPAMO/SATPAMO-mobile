import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/prefs_cache.dart';

import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../akademik/jadwal_presensi_screen.dart';
import '../notifikasi/notifikasi_screen.dart';
import '../presensi/absensi_screen.dart';
import '../presensi/check_in_screen.dart';
import '../presensi/pengajuan_izin_screen.dart';
import '../presensi/riwayat_screen.dart';
import '../presensi/scan_qr_screen.dart';
import 'menu_screen.dart';
import 'profile_screen.dart';
import 'widgets/dashboard_widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeNavIndex = 0;
  String _userName = 'Mahasiswa';
  String _userInitials = 'M';
  final Set<int> _loadedTabs = {0};

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
      final prefs = await PrefsCache.instance;
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




  void _showRiwayatSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => RiwayatSheet(onClose: () => Navigator.of(ctx).pop()),
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

  void _openAbsensi() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AbsensiScreen(isStandalone: true),
      ),
    );
  }

  void _openJadwalPresensi() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const JadwalPresensiScreen()));
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

  // PROFILE page body (index 3)
  Widget _buildProfilePage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: _buildTopBar(),
        ),
        const Expanded(child: ProfileScreen()),
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
                index: _activeNavIndex > 3 ? 0 : _activeNavIndex,
                children: [
                  _buildHomePage(),
                  _loadedTabs.contains(1) ? _buildMenuPage() : const SizedBox(),
                  _loadedTabs.contains(2) ? _buildRiwayatPage() : const SizedBox(),
                  _loadedTabs.contains(3) ? _buildProfilePage() : const SizedBox(),
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
                  AvatarCircle(initials: _userInitials, size: 52),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PengajuanIzinScreen(),
                  ),
                );
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
            icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
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
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const NotifikasiScreen()));
          },
          tooltip: 'Notifikasi',
        ),
      ],
    );
  }

  // ── Greeting card: glass accent #1 ──────────────────────────────────────────

  Widget _buildGreetingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              AvatarCircle(initials: _userInitials, size: 48),
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
              InkWell(
                onTap: _openJadwalPresensi,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '2 Matkul',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.32),
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  ClassRow(
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
                  ClassRow(
                    time: '10:30',
                    subject: 'Sistem Operasi',
                    room: 'Ruang 304 • Pak Budi',
                    isPresent: false,
                    onTap: _openCheckIn,
                  ),
                ],
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
              GestureDetector(
                onTap: _openAbsensi,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Pemrograman Mobile',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ],
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
                    child: SummaryBox(label: 'Hadir', value: '12x'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SummaryBox(label: 'Izin', value: '2x'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SummaryBox(label: 'Alpha', value: '1x'),
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
                  border: Border.all(color: const Color(0x5510B981), width: 1),
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
          child: ActionTile(
            iconWidget: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Color(0xFF0C2030),
              size: 24,
            ),
            iconBg: Colors.white,
            title: 'Scan QR',
            subtitle: 'Absen cepat',
            onTap: _openScanQR,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ActionTile(
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
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PengajuanIzinScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ActionTile(
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
              AnimatedNavItem(
                icon: Icons.home_rounded,
                label: 'HOME',
                isActive: _activeNavIndex == 0,
                onTap: () => setState(() => _activeNavIndex = 0),
              ),
              Builder(
                builder: (ctx) => AnimatedNavItem(
                  icon: Icons.grid_view_rounded,
                  label: 'MENU',
                  isActive: _activeNavIndex == 1,
                  onTap: () {
                    setState(() { _activeNavIndex = 1; _loadedTabs.add(1); });
                  },
                ),
              ),
              AnimatedNavItem(
                icon: Icons.assignment_outlined,
                label: 'RIWAYAT',
                isActive: _activeNavIndex == 2,
                onTap: () {
                  setState(() { _activeNavIndex = 2; _loadedTabs.add(2); });
                },
              ),
              Builder(
                builder: (ctx) => AnimatedNavItem(
                  icon: Icons.account_circle_outlined,
                  label: 'PROFILE',
                  isActive: _activeNavIndex == 3,
                  onTap: () {
                    setState(() { _activeNavIndex = 3; _loadedTabs.add(3); });
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
