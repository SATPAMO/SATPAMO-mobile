import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_popups.dart';

class PengajuanIzinScreen extends StatefulWidget {
  final String? initialMataKuliah;

  const PengajuanIzinScreen({super.key, this.initialMataKuliah});

  @override
  State<PengajuanIzinScreen> createState() => _PengajuanIzinScreenState();
}

class _PengajuanIzinScreenState extends State<PengajuanIzinScreen> {
  final List<String> _dosenMataKuliahList = [
    'Mas Arfan • Pemrograman Mobile',
    'Pak Budi • Sistem Operasi',
    'Dr. Arini • Komputer Jaringan',
    'Pak Budi • Kecerdasan Buatan',
    'Pak Budi • Manajemen Sistem Informasi',
    'Dr. Arini • Desain UI/UX',
    'Pak Budi • Pemweb Framework',
    'Dr. Arini • Kewirausahaan',
  ];
  String? _selectedDosen;

  final List<String> _jenisIzinList = [
    'Sakit (Surat Dokter)',
    'Keperluan Keluarga Mendesak',
    'Tugas / Kegiatan Kampus',
    'Lainnya',
  ];
  String? _selectedJenisIzin;

  DateTime? _selectedDate;
  final TextEditingController _alasanController = TextEditingController();

  String? _attachedFileName;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMataKuliah != null) {
      for (final item in _dosenMataKuliahList) {
        if (item.toLowerCase().contains(
          widget.initialMataKuliah!.toLowerCase(),
        )) {
          _selectedDosen = item;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _alasanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0072DF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0C2030),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickDocument() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (file != null) {
        setState(() {
          _attachedFileName = file.name;
        });
      }
    } catch (_) {
      setState(() {
        _attachedFileName = 'surat_keterangan_dokter.jpg';
      });
    }
  }

  Future<void> _submitPengajuan() async {
    if (_selectedDosen == null) {
      CustomPopups.showError(context, 'Silakan pilih Dosen / Mata Kuliah.');
      return;
    }
    if (_selectedJenisIzin == null) {
      CustomPopups.showError(context, 'Silakan pilih Jenis Izin.');
      return;
    }
    if (_selectedDate == null) {
      CustomPopups.showError(context, 'Silakan pilih Tanggal Izin.');
      return;
    }
    if (_alasanController.text.trim().isEmpty) {
      CustomPopups.showError(context, 'Tuliskan alasan izin.');
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F263B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF10B981),
              size: 28,
            ),
            const SizedBox(width: 10),
            Text(
              'Pengajuan Terkirim',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'Permohonan izin Anda untuk $_selectedDosen telah diteruskan ke dosen terkait. Pantau notifikasi untuk pembaruan status.',
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 13,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0072DF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime d) {
    const hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    const bulan = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${hari[d.weekday - 1]}, ${d.day.toString().padLeft(2, '0')} ${bulan[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dateDisplay = _selectedDate != null
        ? _formatTanggal(_selectedDate!)
        : 'Pilih tanggal...';

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
            children: [
              // Top Bar: Back button, SATPAMO Title, Broadcast Signal Icon
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Back
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),

                    // SATPAMO
                    Text(
                      'SATPAMO',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFFDD00),
                        letterSpacing: 2.0,
                      ),
                    ),

                    // Tombol Sinyal / Antena
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.podcasts_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Formulir Card Utama
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.32),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul Card
                            Text(
                              'Pengajuan Izin',
                              style: GoogleFonts.inter(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0C2030),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Isi data berikut untuk mengajukan izin ke dosen.',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                color: const Color(0xFF1E3A5F)
                                    .withValues(alpha: 0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Field 1: Dosen / Mata Kuliah
                            _buildFieldLabel('Dosen / Mata Kuliah'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _selectedDosen,
                              hint: 'Pilih dosen...',
                              items: _dosenMataKuliahList.map((d) {
                                return DropdownMenuItem(
                                  value: d,
                                  child: Text(
                                    d,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedDosen = val),
                            ),

                            const SizedBox(height: 14),

                            // Field 2: Jenis Izin
                            _buildFieldLabel('Jenis Izin'),
                            const SizedBox(height: 6),
                            _buildDropdownField<String>(
                              value: _selectedJenisIzin,
                              hint: 'Pilih jenis izin...',
                              items: _jenisIzinList.map((j) {
                                return DropdownMenuItem(
                                  value: j,
                                  child: Text(j),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedJenisIzin = val),
                            ),

                            const SizedBox(height: 14),

                            // Field 3: Tanggal Izin
                            _buildFieldLabel('Tanggal Izin'),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickDate,
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                height: 46,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 16,
                                      color: const Color(0xFF0C2030)
                                          .withValues(alpha: 0.7),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        dateDisplay,
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: _selectedDate != null
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                          color: _selectedDate != null
                                              ? const Color(0xFF0C2030)
                                              : const Color(0xFF1E3A5F)
                                                    .withValues(alpha: 0.65),
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: const Color(0xFF0C2030)
                                          .withValues(alpha: 0.8),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Field 4: Alasan
                            _buildFieldLabel('Alasan'),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _alasanController,
                                maxLines: 3,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF0C2030),
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Tuliskan alasan izin...',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF1E3A5F)
                                        .withValues(alpha: 0.60),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Field 5: Lampiran Surat Dokter
                            _buildFieldLabel('Lampiran Surat Dokter'),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickDocument,
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.20),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.40),
                                    width: 1.2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF34D399)
                                            .withValues(alpha: 0.35),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.cloud_upload_rounded,
                                        color: Color(0xFFFFD600),
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _attachedFileName ??
                                          'Unggah surat dokter',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0C2030),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'PDF, JPG, PNG (Maks. 5 MB)',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: const Color(0xFF1E3A5F)
                                            .withValues(alpha: 0.75),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Tombol Kirim Pengajuan
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : _submitPengajuan,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF0072DF),
                                        Color(0xFF004FA4),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF0072DF)
                                            .withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: _isSubmitting
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.send_rounded,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Kirim Pengajuan',
                                                style: GoogleFonts.inter(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0C2030),
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required T? value,
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: true,
          dropdownColor: const Color(0xFF0D6FA8),
          icon: Icon(
            Icons.arrow_drop_down,
            color: const Color(0xFF0C2030).withValues(alpha: 0.8),
          ),
          hint: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF1E3A5F).withValues(alpha: 0.65),
              fontWeight: FontWeight.w500,
            ),
          ),
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0C2030),
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item.value,
              child: DefaultTextStyle(
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                child: item.child,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
