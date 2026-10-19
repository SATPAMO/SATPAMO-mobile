import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  String _activeFilter = 'Semua';

  late List<_NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      _NotificationModel(
        id: '1',
        sender: 'Sistem',
        time: '08.00',
        section: 'Hari ini • Senin, 12 Okt',
        categoryTag: 'PENGINGAT KELAS',
        body: 'Pagi! Kelas Basis Data dimulai 30 menit lagi. Siapkan catatanmu, ya.',
        timeSchedule: '08.30-10.10 WIB',
        classMode: 'Daring',
        actionLabel: 'Buka Google Meet',
        actionUrl: 'meet.google.com/abc-defg-hij',
        isUnread: true,
        type: _NotificationType.sistem,
      ),
      _NotificationModel(
        id: '2',
        sender: 'Dr. Rina Putri',
        time: '07.45',
        section: 'Hari ini • Senin, 12 Okt',
        categoryTag: 'Statistika • Perubahan jadwal',
        body: 'Selamat pagi. Kelas hari ini dipindah ke pukul 13.00 di ruang B.204. Sampai bertemu!',
        isUnread: true,
        avatarInitials: 'RP',
        type: _NotificationType.dosen,
      ),
      _NotificationModel(
        id: '3',
        sender: 'Sistem',
        time: '07.30',
        section: 'Hari ini • Senin, 12 Okt',
        categoryTag: 'PENGINGAT KELAS',
        body: 'Ada kelas Interaksi Manusia & Komputer hari ini. Jangan lupa hadir, ya!',
        timeSchedule: '10.30-12.10 WIB',
        classMode: 'Luring',
        roomLocation: 'Ruang A.302 • Gedung A',
        isUnread: true,
        type: _NotificationType.sistem,
      ),
      _NotificationModel(
        id: '4',
        sender: 'Arif Pratama, M.Kom.',
        time: '19.20',
        section: 'Kemarin • Minggu, 11 Okt',
        categoryTag: 'Pemrograman Web • Pengingat tugas',
        body: 'Tugas wireframe dikumpulkan besok sebelum 23.59 melalui LMS. Sertakan tautan Figma kalian, ya.',
        isUnread: false,
        avatarInitials: 'AP',
        type: _NotificationType.dosen,
      ),
      _NotificationModel(
        id: '5',
        sender: 'Dr. Rina Putri',
        time: '16.05',
        section: 'Kemarin • Minggu, 11 Okt',
        categoryTag: 'Statistika • Materi perkuliahan',
        body: 'Materi pertemuan 6 sudah tersedia di LMS. Silakan dibaca sebelum kelas berikutnya.',
        isUnread: false,
        avatarInitials: 'RP',
        type: _NotificationType.dosen,
      ),
    ];
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isUnread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi ditandai sudah dibaca.'),
        backgroundColor: Color(0xFF0072DF),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<_NotificationModel> get _filteredList {
    switch (_activeFilter) {
      case 'Belum dibaca':
        return _notifications.where((n) => n.isUnread).toList();
      case 'Sistem':
        return _notifications
            .where((n) => n.type == _NotificationType.sistem)
            .toList();
      case 'Dosen':
        return _notifications
            .where((n) => n.type == _NotificationType.dosen)
            .toList();
      default:
        return _notifications;
    }
  }

  int get _unreadCount => _notifications.where((n) => n.isUnread).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredList;
    final Map<String, List<_NotificationModel>> grouped = {};
    for (final item in filtered) {
      grouped.putIfAbsent(item.section, () => []).add(item);
    }

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
                          padding: const EdgeInsets.only(right: 38),
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

              // Title Card Banner: NOTIFIKASI
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
                            'NOTIFIKASI',
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFFFDD00),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kabar kuliahmu, di satu tempat.',
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

              const SizedBox(height: 8),

              // Filter Pills Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterPill(
                        label:
                            'Semua (${_unreadCount > 0 ? _unreadCount : _notifications.length})',
                        filterKey: 'Semua',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterPill(
                        label: 'Belum dibaca',
                        filterKey: 'Belum dibaca',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterPill(label: 'Sistem', filterKey: 'Sistem'),
                      const SizedBox(width: 8),
                      _buildFilterPill(label: 'Dosen', filterKey: 'Dosen'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Daftar Notifikasi per Section
              Expanded(
                child: grouped.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada notifikasi.',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: grouped.keys.length,
                        itemBuilder: (context, idx) {
                          final sectionTitle = grouped.keys.elementAt(idx);
                          final items = grouped[sectionTitle]!;
                          final isToday = sectionTitle.contains('Hari ini');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Section Header Row
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4,
                                  right: 4,
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sectionTitle,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                      ),
                                    ),
                                    if (isToday && _unreadCount > 0)
                                      InkWell(
                                        onTap: _markAllAsRead,
                                        child: Text(
                                          'Tandai dibaca',
                                          style: GoogleFonts.inter(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFFFDD00),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // Notification Cards in Section
                              ...items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _NotificationCard(item: item),
                                );
                              }),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill({required String label, required String filterKey}) {
    final isActive = _activeFilter == filterKey;

    return InkWell(
      onTap: () => setState(() => _activeFilter = filterKey),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFFFFDD00)
              : Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive
                ? const Color(0xFFFFDD00)
                : Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive ? const Color(0xFF0C2030) : Colors.white,
          ),
        ),
      ),
    );
  }
}

enum _NotificationType { sistem, dosen }

class _NotificationModel {
  final String id;
  final String sender;
  final String time;
  final String section;
  final String categoryTag;
  final String body;
  final String? timeSchedule;
  final String? classMode;
  final String? actionLabel;
  final String? actionUrl;
  final String? roomLocation;
  final String? avatarInitials;
  final _NotificationType type;
  bool isUnread;

  _NotificationModel({
    required this.id,
    required this.sender,
    required this.time,
    required this.section,
    required this.categoryTag,
    required this.body,
    this.timeSchedule,
    this.classMode,
    this.actionLabel,
    this.actionUrl,
    this.roomLocation,
    this.avatarInitials,
    required this.type,
    required this.isUnread,
  });
}

class _NotificationCard extends StatelessWidget {
  final _NotificationModel item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.30),
              width: 1.2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar (System icon or Lecturer initials)
              if (item.avatarInitials != null)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF475569).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.avatarInitials!,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFDD00),
                    ),
                  ),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF475569).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: Color(0xFFFFDD00),
                    ),
                  ),
                ),

              const SizedBox(width: 12),

              // Detail Notifikasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender, Time, and Unread Dot
                    Row(
                      children: [
                        Text(
                          item.sender,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0C2030),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.time,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1E3A5F)
                                .withValues(alpha: 0.75),
                          ),
                        ),
                        if (item.isUnread) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFDD00),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Category Tag
                    Text(
                      item.categoryTag,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFDD00),
                        letterSpacing: 0.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Body Message
                    Text(
                      item.body,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: const Color(0xFF0C2030),
                        height: 1.35,
                      ),
                    ),

                    // Opsional Tag Waktu & Mode Kelas
                    if (item.timeSchedule != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.alarm_rounded,
                            size: 14,
                            color: const Color(0xFFFFDD00),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.timeSchedule!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0C2030),
                            ),
                          ),
                          if (item.classMode != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: item.classMode == 'Daring'
                                    ? const Color(0xFFFEF08A)
                                    : const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item.classMode!,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: item.classMode == 'Daring'
                                      ? const Color(0xFF854D0E)
                                      : const Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],

                    // Opsional Lokasi Ruangan
                    if (item.roomLocation != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 13,
                            color: Color(0xFFFFDD00),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.roomLocation!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1E3A5F),
                            ),
                          ),
                        ],
                      ),
                    ],

                    // Opsional Action Button (contoh Google Meet)
                    if (item.actionLabel != null && item.actionUrl != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B)
                              .withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.videocam_rounded,
                              size: 18,
                              color: Color(0xFFFFDD00),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.actionLabel!,
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFFDD00),
                                    ),
                                  ),
                                  Text(
                                    item.actionUrl!,
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.north_east_rounded,
                              size: 14,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
