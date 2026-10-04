import 'dart:convert';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../services/api_service.dart';
import 'login_screen.dart';
import 'result_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // Mata Kuliah
  static const List<String> _daftarMataKuliah = [
    'Pemrograman Mobile',
    'Sistem Operasi',
    'Jaringan Komputer',
    'Artificial Intelligence',
    'Manajemen Sistem Informasi',
    'Desain UI/UX',
    'Pemweb Framework',
    'Kewirausahaan',
  ];
  String? _selectedMataKuliah;

  // User (otomatis dari login)
  String? _userId;
  bool _loadingMahasiswa = false;

  // Kamera Selfie
  Uint8List? _photoBytes;
  String? _photoBase64;
  final ImagePicker _picker = ImagePicker();

  // Lokasi GPS
  Position? _currentPosition;
  bool _loadingLocation = false;
  String? _locationError;

  // Form & Submit
  final TextEditingController _notesController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _loadingMahasiswa = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _userId = prefs.getString('userId');
        _loadingMahasiswa = false;
      });
      if (_userId == null || _userId!.isEmpty) {
        _showSnackbar('Data user tidak ditemukan. Silakan login ulang.', isError: true);
      }
    } catch (e) {
      setState(() => _loadingMahasiswa = false);
      _showSnackbar('Gagal memuat data user: $e', isError: true);
    }
  }

  // 2. Deteksi GPS lokasi
  Future<void> _getCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
      _locationError = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError =
              'Layanan GPS tidak aktif. Silakan nyalakan GPS di HP Anda.';
          _loadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Izin lokasi ditolak.';
            _loadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengizinkan.';
          _loadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      setState(() {
        _currentPosition = position;
        _loadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Gagal mendeteksi lokasi: $e';
        // Fallback default kampus untuk kemudahan testing jika di simulator desktop
        if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) {
          _currentPosition = Position(
            latitude: -6.200050,
            longitude: 106.816670,
            timestamp: DateTime.now(),
            accuracy: 10,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
          _locationError = null;
        }
        _loadingLocation = false;
      });
    }
  }

  // 3. Ambil Foto Selfie (Kamera Depan)
  Future<void> _takeSelfie() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        maxWidth: 720,
        maxHeight: 720,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Str = base64Encode(bytes);

        setState(() {
          _photoBytes = bytes;
          _photoBase64 = base64Str;
        });
      }
    } catch (e) {
      _showSnackbar('Gagal membuka kamera: $e', isError: true);
    }
  }

  // 4. Submit Presensi ke Backend
  Future<void> _submitAttendance() async {
    if (_userId == null || _userId!.isEmpty) {
      _showSnackbar('Data user tidak ditemukan. Silakan login ulang.', isError: true);
      return;
    }
    if (_selectedMataKuliah == null) {
      _showSnackbar('Silakan pilih mata kuliah terlebih dahulu.', isError: true);
      return;
    }
    if (_photoBase64 == null) {
      _showSnackbar(
        'Silakan ambil foto selfie Anda terlebih dahulu.',
        isError: true,
      );
      return;
    }
    if (_currentPosition == null) {
      _showSnackbar(
        'Lokasi GPS belum terdeteksi. Silakan segarkan GPS.',
        isError: true,
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      final additionalNotes = _notesController.text.trim();
      final finalNotes = 'Mata Kuliah: $_selectedMataKuliah'
          '${additionalNotes.isNotEmpty ? ' | Catatan: $additionalNotes' : ''}';

      final result = await ApiService.submitCheckIn(
        mahasiswaId: _userId!,
        photoBase64: _photoBase64!,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        notes: finalNotes,
      );

      setState(() => _submitting = false);

      if (!mounted) return;

      // Pindah ke layar hasil
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
      );
    } catch (e) {
      setState(() => _submitting = false);
      _showSnackbar('Gagal memproses presensi: $e', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickMataKuliah() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Pilih Mata Kuliah',
                    style: Theme.of(ctx).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: _daftarMataKuliah.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, i) {
                      final mk = _daftarMataKuliah[i];
                      final selected = _selectedMataKuliah == mk;
                      return ListTile(
                        leading: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: const Color(0xFF2563EB),
                        ),
                        title: Text(
                          mk,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        selected: selected,
                        onTap: () => Navigator.of(ctx).pop(mk),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedMataKuliah = picked);
    }
  }

  // Dialog konfigurasi IP server
  void _showServerSettingsDialog() {
    final controller = TextEditingController(text: ApiService.baseUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pengaturan Server Backend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan alamat IP dan port backend Express:',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Contoh: http://10.200.22.103:3001',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'HP USB: http://127.0.0.1:3001 (adb reverse tcp:3001 tcp:3001)\n'
              'HP Wi-Fi: ${ApiService.lanUrl}\n'
              'Emulator: http://10.0.2.2:3001\n'
              'Windows / Web: http://127.0.0.1:3001',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              ApiService.baseUrl = controller.text.trim();
              Navigator.of(ctx).pop();
              _showSnackbar('URL server diubah: ${ApiService.baseUrl}');
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text('Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ApiService.clearToken();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Absensi Selfie',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 22),
            tooltip: 'Keluar',
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded, size: 22),
            tooltip: 'Pengaturan Server',
            onPressed: _showServerSettingsDialog,
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A2FE), Color(0xFF0063BA), Color(0xFF0C2030)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: _loadingMahasiswa
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text('Menghubungkan ke server...',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Hero Banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.verified_user_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Presensi Mandiri Mahasiswa',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Dilengkapi Verifikasi Gemini AI Vision & Geofencing GPS Kampus',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1. Pilih Mata Kuliah
                      const Text(
                        '1. PILIH MATA KULIAH',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: _pickMataKuliah,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                constraints: const BoxConstraints(minHeight: 52),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _selectedMataKuliah == null
                                          ? const Text(
                                              'Pilih mata kuliah',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white70,
                                              ),
                                            )
                                          : Text(
                                              _selectedMataKuliah!,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Foto Selfie
                      const Text(
                        '2. FOTO SELFIE WAJAH',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            height: 220,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _photoBytes != null
                                    ? const Color(0xFFFFDD00)
                                    : Colors.white.withValues(alpha: 0.35),
                                width: _photoBytes != null ? 2 : 1.2,
                              ),
                            ),
                            child: _photoBytes != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.memory(
                                          _photoBytes!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: ElevatedButton.icon(
                                          onPressed: _takeSelfie,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black.withValues(
                                              alpha: 0.7,
                                            ),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                          ),
                                          icon: const Icon(
                                            Icons.refresh_rounded,
                                            size: 16,
                                          ),
                                          label: const Text(
                                            'Foto Ulang',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: _takeSelfie,
                                    borderRadius: BorderRadius.circular(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_front_rounded,
                                            size: 38,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Ambil Foto Selfie',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Pastikan wajah terlihat jelas & terang',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 3. Lokasi GPS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '3. VALIDASI LOKASI GPS',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                            ),
                          ),
                          InkWell(
                            onTap: _loadingLocation ? null : _getCurrentLocation,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 14,
                                  color: _loadingLocation
                                      ? Colors.white54
                                      : Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Segarkan GPS',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _loadingLocation
                                        ? Colors.white54
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.2,
                              ),
                            ),
                            child: _loadingLocation
                                ? const Row(
                                    children: [
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Mencari sinyal GPS akurasi tinggi...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  )
                                : _currentPosition != null
                                ? Row(
                                    children: [
                                      const Icon(
                                        Icons.my_location_rounded,
                                        color: Color(0xFFFFDD00),
                                        size: 22,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Koordinat: ${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Akurasi: ±${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFEF5350),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _locationError ?? 'Lokasi belum didapatkan.',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFFEF5350),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 4. Catatan Opsional
                      const Text(
                        '4. CATATAN (OPSIONAL)',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          hintText: 'Misal: Gedung B Ruang 204...',
                          hintStyle: const TextStyle(
                            fontSize: 12,
                            color: Colors.white54,
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.22),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 28),

                      // Tombol Kirim Presensi
                      ElevatedButton(
                        onPressed: _submitting ? null : _submitAttendance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDD00),
                          foregroundColor: const Color(0xFF0C2030),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: _submitting
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0C2030),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Memverifikasi AI & Menyimpan...',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Kirim Presensi Sekarang',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
