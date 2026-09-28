import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const _menuItems = [
    _MenuItem(
      label: 'Hasil Studi',
      abbr: 'HS',
      icon: null,
    ),
    _MenuItem(
      label: 'Kartu Hasil Studi',
      abbr: 'KHS',
      icon: null,
    ),
    _MenuItem(
      label: 'Jadwal & Presensi',
      abbr: null,
      icon: Icons.calendar_month_rounded,
    ),
    _MenuItem(
      label: 'Absensi Mahasiswa',
      abbr: null,
      icon: Icons.fact_check_outlined,
    ),
    _MenuItem(
      label: 'Kartu Rencana Studi',
      abbr: null,
      icon: Icons.credit_card_rounded,
    ),
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
                  'RUANG MENU',
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
        // Menu list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // padding to clear bottom nav
            itemCount: _menuItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              return _MenuTile(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.label,
    this.abbr,
    this.icon,
  });
  final String label;
  final String? abbr;
  final IconData? icon;
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});
  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${item.label} belum tersedia.',
                style: GoogleFonts.inter(),
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              // Icon or initials bubble
              _MenuIcon(abbr: item.abbr, icon: item.icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
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

class _MenuIcon extends StatelessWidget {
  const _MenuIcon({this.abbr, this.icon});
  final String? abbr;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0072DF), Color(0xFF004FA4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: abbr != null
          ? Text(
              abbr!,
              style: GoogleFonts.inter(
                fontSize: abbr!.length > 2 ? 10 : 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            )
          : Icon(icon, color: Colors.white, size: 22),
    );
  }
}
