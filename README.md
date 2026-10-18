# SATPAMO Presensi (SAMA Mobile)

Aplikasi mobile Flutter buat presensi kuliah mahasiswa. Mahasiswa bisa absen lewat verifikasi lokasi (geofencing GPS), scan QR, dan swafoto, jadi kehadiran tercatat beneran dan nggak bisa asal titip.

---

## Desain UI (Figma)

Desain UI/UX dan alur aplikasinya ada di Figma:

[UI-UX SATPAMO](https://www.figma.com/design/KX9GPFTRqh5Niop4KA8tzB/UI-UX-Absensi-Mahasiswa?node-id=0-1&t=LxZenxSluyO5956U-0)

## Cara Kerja Singkat

Aplikasi ini terhubung ke backend Express API buat sinkronisasi data presensi dan status akademik. Biar data kehadiran tetap valid, ada tiga lapis verifikasi:

1. **Lokasi (GPS):** jarak mahasiswa ke titik pusat kampus dihitung, maksimal 150 meter.
2. **Swafoto:** foto wajah diambil langsung dari kamera sebagai bukti hadir.
3. **QR Code:** scan token sesi presensi yang ditampilkan dosen di kelas.

---

## Fitur

**Login & sesi**

- Login pakai NIM atau email + kata sandi.
- Token JWT disimpan lokal di `shared_preferences`.
- Auto-login saat app dibuka (`AuthGate`).
- Ada dialog konfirmasi sebelum logout.

**Dashboard**

- Ringkasan profil (nama dan inisial).
- Status presensi hari ini plus pengingat jadwal kuliah.
- Pintasan cepat ke Check-In dan Scan QR.
- Navigasi bawah: Beranda, Absensi, Riwayat, Menu, Profil.

**Presensi**

- **Scan QR:** pemindai dengan animasi laser buat baca sesi presensi yang dibuka dosen.
- **Check-In mandiri:** pilih mata kuliah, ambil swafoto, lalu deteksi koordinat GPS.
- **Izin / sakit:** form pengajuan lengkap dengan keterangan pendukung.

**Hasil presensi**

- Status: Hadir (Present), Terlambat (Late), Izin, atau Ditolak (Absent).
- Detail verifikasi lokasi: jarak sebenarnya dan apakah masih dalam radius.
- Detail hasil verifikasi foto wajah.

**Riwayat**

- Daftar riwayat presensi per mata kuliah.
- Status tiap pertemuan: Hadir, Izin, atau Alpha.

**Menu akademik & profil**

- Akses ke Hasil Studi, Kartu Hasil Studi, Jadwal & Presensi, dan Kartu Rencana Studi.
- Profil lengkap: NIM, nama, program studi, fakultas, angkatan, dan status akademik.

---

## Teknologi

| Komponen          | Pustaka / Versi              | Kegunaan                                       |
| :---------------- | :--------------------------- | :--------------------------------------------- |
| Framework         | Flutter (Material 3)         | Bikin UI mobile                                |
| Bahasa            | Dart (SDK `^3.13.1`)         | Bahasa utama                                   |
| Font              | `google_fonts: ^8.2.1`       | Pakai font Inter                               |
| Lokasi            | `geolocator: ^14.0.3`        | Ambil koordinat GPS dan hitung jarak ke kampus |
| Kamera            | `image_picker: ^1.2.3`       | Ambil swafoto dari kamera                      |
| HTTP              | `http: ^1.6.0`               | Request REST API ke backend                    |
| Penyimpanan lokal | `shared_preferences: ^2.5.3` | Simpan token JWT dan cache user                |
| Format tanggal    | `intl: ^0.20.3`              | Format tanggal dan waktu presensi              |

---

## Struktur Folder

```text
lib/
├── main.dart                      # Entry point app & AuthGate
├── models/                        # Model data (serialisasi JSON)
│   ├── attendance_result.dart     # Hasil presensi dan verifikasi AI/lokasi
│   └── mahasiswa.dart             # Data profil mahasiswa
├── screens/                       # Layar-layar UI
│   ├── absensi_screen.dart        # Sesi absensi & form izin
│   ├── check_in_screen.dart       # Presensi mandiri (foto kamera & GPS)
│   ├── course_history_screen.dart # Riwayat presensi per mata kuliah
│   ├── cover_screen.dart          # Layar pembuka (welcome)
│   ├── dashboard_screen.dart      # Dashboard utama & navigasi bawah
│   ├── login_screen.dart          # Form login
│   ├── menu_screen.dart           # Menu layanan akademik
│   ├── profile_screen.dart        # Profil mahasiswa
│   ├── result_screen.dart         # Detail hasil presensi
│   ├── riwayat_screen.dart        # Daftar mata kuliah untuk riwayat
│   └── scan_qr_screen.dart        # Pemindai QR sesi presensi
├── services/
│   └── api_service.dart           # Klien REST API dan konfigurasi base URL
└── widgets/
    └── custom_popups.dart         # Dialog konfirmasi, notifikasi, dan error
```

---

## Mulai Pakai

### Yang perlu disiapkan

1. Flutter SDK 3.13.1 atau lebih baru.
2. Dart SDK 3.13.1 atau lebih baru.
3. Android Studio atau VS Code dengan ekstensi Flutter dan Dart.
4. HP Android fisik, atau emulator dengan Google Play Services aktif (biar GPS bisa dites).

### Menjalankan app

1. **Clone repo:**

   ```bash
   git clone <URL_REPOSITORI>
   cd sama-mobile
   ```

2. **Install dependensi:**

   ```bash
   flutter pub get
   ```

3. **Atur endpoint backend:**
   Backend Express jalan di port 3001. Alamat servernya diatur di `lib/services/api_service.dart`, tergantung cara kamu menjalankan app:
   - **HP fisik lewat USB:** jalankan `adb reverse` supaya HP bisa akses server lokal di laptop.
     ```bash
     adb reverse tcp:3001 tcp:3001
     ```
   - **HP fisik lewat Wi-Fi:** ubah variabel `lanUrl` di `lib/services/api_service.dart` ke IP laptop kamu (HP dan laptop harus satu jaringan), contoh `http://192.168.x.x:3001`.
   - **Emulator Android:** nggak perlu diubah, defaultnya sudah `http://10.0.2.2:3001`.
   - **Lewat Dart Define:**
     ```bash
     flutter run --dart-define=API_BASE_URL=http://<IP_SERVER>:3001
     ```

4. **Jalankan:**
   ```bash
   flutter run
   ```

---

## Cek Kualitas Kode

Sebelum commit, jalankan ini dulu:

```bash
flutter analyze   # linter & analisis statis
dart format .     # rapikan format kode
flutter test      # unit & widget test
```

---

## Izin Perangkat

Izin berikut sudah dikonfigurasi di app:

- **Kamera** (`android.permission.CAMERA`): buat ambil swafoto bukti hadir.
- **Lokasi** (`ACCESS_FINE_LOCATION` dan `ACCESS_COARSE_LOCATION`): buat hitung jarak ke area kampus.
- **Internet** (`android.permission.INTERNET`): buat login dan sinkronisasi presensi dengan backend.
