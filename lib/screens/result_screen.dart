import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/attendance_result.dart';

class ResultScreen extends StatelessWidget {
  final AttendanceResult result;

  const ResultScreen({super.key, required this.result});

  Color _getStatusColor() {
    switch (result.status.toUpperCase()) {
      case 'PRESENT':
        return const Color(0xFF10B981);
      case 'LATE':
        return Colors.orange;
      case 'IZIN':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (result.status.toUpperCase()) {
      case 'PRESENT':
        return 'Hadir Tepat Waktu';
      case 'LATE':
        return 'Hadir Terlambat';
      case 'IZIN':
        return 'Izin';
      default:
        return 'Presensi Ditolak / Tidak Hadir';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final timeStr = result.checkIn != null
        ? DateFormat('HH:mm:ss')
              .format(DateTime.parse(result.checkIn!).toLocal())
        : DateFormat('HH:mm:ss').format(DateTime.now());

    final loc = result.location;
    final ai = result.ai;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Hasil Presensi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Status Atas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    result.status == 'PRESENT' || result.status == 'LATE'
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 54,
                    color: statusColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getStatusText(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pukul $timeStr WIB',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card Identitas Mahasiswa
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'IDENTITAS MAHASISWA',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Nama', result.name, isBold: true),
                    _buildInfoRow('NIM', result.nim),
                    _buildInfoRow(
                      'Jurusan',
                      '${result.jurusan} (Smtr ${result.semester})',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Card Validasi Lokasi (Geofencing Kampus)
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 18,
                              color: Color(0xFF2563EB),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Validasi Lokasi (Geofence)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        if (loc != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: loc.isValid
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: loc.isValid
                                    ? Colors.green.shade300
                                    : Colors.red.shade300,
                              ),
                            ),
                            child: Text(
                              loc.isValid
                                  ? '? Dalam Radius'
                                  : '? Di Luar Radius',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: loc.isValid
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (loc != null) ...[
                      _buildInfoRow(
                        'Jarak ke Kampus',
                        '${loc.distance.toStringAsFixed(1)} meter',
                      ),
                      _buildInfoRow(
                        'Radius Maksimal',
                        '${loc.maxRadius.toInt()} meter',
                      ),
                    ] else
                      const Text(
                        'Data lokasi tidak terverifikasi.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Card Verifikasi AI Gemini
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE0E7FF)),
              ),
              color: const Color(0xFFEEF2FF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 18,
                              color: Color(0xFF4F46E5),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Verifikasi Gemini AI Vision',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF312E81),
                              ),
                            ),
                          ],
                        ),
                        if (ai != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ai.verdict == 'VERIFIED'
                                  ? const Color(0xFFD1FAE5)
                                  : ai.verdict == 'SUSPICIOUS'
                                  ? Colors.amber.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ai.verdict,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: ai.verdict == 'VERIFIED'
                                    ? const Color(0xFF065F46)
                                    : ai.verdict == 'SUSPICIOUS'
                                    ? Colors.amber.shade900
                                    : Colors.red.shade800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (ai != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFC7D2FE)),
                        ),
                        child: Text(
                          '"${ai.reason}"',
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildPill(
                              'Wajah Jelas',
                              ai.isFaceClear ? 'Ya' : 'Buram/Tidak',
                              ai.isFaceClear,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildPill(
                              'Keaslian',
                              ai.spoofDetected
                                  ? 'Layar HP (Palsu)'
                                  : 'Wajah Asli',
                              !ai.spoofDetected,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildPill(
                              'Confidence',
                              '${ai.confidence}%',
                              ai.confidence >= 70,
                            ),
                          ),
                        ],
                      ),
                    ] else
                      const Text(
                        'Verifikasi AI tidak tersedia.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Kembali
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Selesai / Kembali ke Beranda',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String title, String value, bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPositive ? const Color(0xFFA7F3D0) : Colors.amber.shade200,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isPositive
                  ? const Color(0xFF047857)
                  : Colors.amber.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
