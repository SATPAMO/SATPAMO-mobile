import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String _name = '';
  String _nim = '';
  String _jurusan = '';
  String _email = '';
  String _angkatan = '';
  String _status = 'Aktif';
  String _fakultas = 'Ilmu Komputer';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedName = prefs.getString('userName')?.trim() ?? '';
      final cachedEmail = prefs.getString('userEmail')?.trim() ?? '';
      final cachedNim = prefs.getString('userNim')?.trim() ?? '-';

      final res = await ApiService.getCurrentUser();
      if (res['success'] == true) {
        final data = res['data']?['user'] ?? res['data']?['mahasiswa'] ?? res['data'] ?? {};
        setState(() {
          _name = data['name']?.toString() ?? data['nama']?.toString() ?? cachedName;
          if (_name.isEmpty) _name = 'Mahasiswa';
          
          _nim = data['nim']?.toString() ?? cachedNim;
          _jurusan = data['jurusan']?.toString() ?? data['programStudi']?.toString() ?? 'S1 Informatika';
          _email = data['email']?.toString() ?? cachedEmail;
          if (_email.isEmpty) _email = '-';
          
          final semester = data['semester']?.toString() ?? '';
          _angkatan = data['angkatan']?.toString() ?? (semester.isNotEmpty ? 'Semester $semester' : '2024');
          
          _status = data['status']?.toString() ?? 'Aktif';
          _fakultas = data['fakultas']?.toString() ?? 'Ilmu Komputer';
        });
      } else {
        // Fallback jika fetch gagal
        setState(() {
          _name = cachedName.isNotEmpty ? cachedName : 'Mahasiswa';
          _nim = cachedNim;
          _jurusan = 'S1 Informatika';
          _angkatan = '2024';
          _email = cachedEmail.isNotEmpty ? cachedEmail : '-';
        });
      }
    } catch (e) {
      // Fallback on error
      final prefs = await SharedPreferences.getInstance();
      final cachedName = prefs.getString('userName')?.trim() ?? 'Mahasiswa';
      final cachedEmail = prefs.getString('userEmail')?.trim() ?? '-';
      final cachedNim = prefs.getString('userNim')?.trim() ?? '-';
      if (mounted) {
        setState(() {
          _name = cachedName;
          _nim = cachedNim;
          _jurusan = 'S1 Informatika';
          _angkatan = '2024';
          _email = cachedEmail;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        children: [
          _buildProfileCard(),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final initials = _extractInitials(_name);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              // Top part: Avatar, Name, Role, Button
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0052B4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initials,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0C2030),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mahasiswa aktif • $_jurusan',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF1B3A54),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      color: Color(0xFF0C2030),
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Details list
              _buildDetailRow('NIM', _nim),
              _buildDivider(),
              _buildDetailRow('Program Studi', _jurusan),
              _buildDivider(),
              _buildDetailRow('Angkatan', _angkatan),
              _buildDivider(),
              _buildDetailRow('Status Akademik', _status),
              _buildDivider(),
              _buildDetailRow('Fakultas', _fakultas),
              _buildDivider(),
              _buildDetailRow('Email', _email),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF1B3A54),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF0C2030),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.black12,
      height: 12,
      thickness: 1,
    );
  }
}
