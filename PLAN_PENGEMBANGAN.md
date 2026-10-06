# 📌 Checklist Rencana Pengembangan & Peningkatan Klinik App

Dokumen ini memuat catatan perkembangan fitur yang sudah diselesaikan serta daftar rencana fitur baru untuk menjadikan **Klinik App** sebuah sistem informasi klinik yang utuh, fungsional, dan siap diuji/dipresentasikan.

---

## ✅ 1. Fitur yang Telah Diselesaikan (Completed)

- [x] **Desain Sistem & Tema Pastel Modern**
  - [x] Palet warna pastel `#CFEBDF` (Mint) dan `#E2FADB` (Soft Green) pada header, card, dan background.
  - [x] Standardisasi teks: `#2C3E50` (Teks Utama) dan `#7F8C8D` (Teks Sekunder).
  - [x] Warna aksen `#27AE60` (Hijau Tua) pada tombol aksi, icon aktif, dan badge.
  - [x] Kartu melengkung (*rounded 16px*), bayangan lembut, dan input bergaya modern.
- [x] **Centralized Data Service (CRUD Berfungsi Penuh)**
  - [x] Singleton `DataService` untuk manajemen data reaktif di seluruh halaman.
  - [x] CRUD Data Poli (Tambah, Ubah, Hapus dengan dialog konfirmasi, Tampil detail).
  - [x] CRUD Data Pasien (Tambah, Ubah, Hapus dengan dialog konfirmasi, Tampil detail).
  - [x] CRUD Data Pegawai (Tambah, Ubah, Hapus dengan dialog konfirmasi, Tampil detail).
- [x] **Pesan Konfirmasi Hapus Data**
  - [x] Dialog konfirmasi *"Yakin ingin menghapus data ini?"* pada Poli, Pasien, dan Pegawai.
  - [x] Tombol "YA" (Merah) dan "Tidak" (Abu-abu/Hijau).
- [x] **Sistem Registrasi Pegawai Terpadu**
  - [x] Generator Kode Registrasi Admin berbasis kombinasi huruf & angka acak (e.g. `ADM88K`).
  - [x] Tombol salin kode registrasi (*copy to clipboard*) untuk Admin.
  - [x] Validasi kode unik sebelum calon pegawai dapat mengisi formulir.
  - [x] Tombol deteksi lokasi otomatis penempatan kerja berbasis koordinat GPS & alamat.
  - [x] Simulasi verifikasi OTP 4-digit via SMS/Email banner.
  - [x] Data registrasi otomatis masuk ke Data Pegawai tanpa perlu diinput ulang oleh Admin.
- [x] **Validasi Khusus Angka Saja (`digitsOnly`)**
  - [x] Tanggal lahir & nomor telepon hanya menerima karakter angka (input huruf & simbol terblokir).
  - [x] Fitur kalender (*date picker*) interaktif untuk memudahkan pemilihan tanggal lahir.
- [x] **Dashboard Beranda & Navigasi Terintegrasi**
  - [x] Banner selamat datang dan kartu metrik statistik (*Total Poli, Total Pegawai, Total Pasien*).
  - [x] Menu cepat (*quick actions*) untuk akses langsung ke setiap modul.
  - [x] Sidebar Drawer dapat diakses dari semua halaman utama (*Beranda, Poli, Pegawai, Pasien*).
  - [x] Autentikasi Login untuk Admin (`admin`/`admin`) dan Pegawai terdaftar.

---

## 📋 2. Rencana Peningkatan Selanjutnya (Backlog & Roadmap)

### 🚀 Prioritas 1: User Experience & Kemudahan Navigasi (Quick Wins) - SELESAI ✅
- [x] **Pencarian Data Real-Time (*Search Bar*)**
  - [x] Search bar di halaman **Data Pasien** (cari berdasarkan Nama atau No. Rekam Medis).
  - [x] Search bar di halaman **Data Pegawai** (cari berdasarkan Nama atau NIP).
  - [x] Search bar di halaman **Data Poli** (cari berdasarkan Nama Poli).
- [x] **Sesi Login Dinamis (*Dynamic User Session*)**
  - [x] Menyimpan data profil user yang sedang login di `DataService.currentUser`.
  - [x] Menampilkan nama & email pegawai yang login di header Drawer Sidebar (bukan lagi teks statis *"Admin"*).
  - [x] Menyesuaikan sapaan di Beranda (*"Selamat Datang, dr. Budi"* atau *"Selamat Datang, Admin"*).
- [x] **Dialog Konfirmasi Logout**
  - [x] Menampilkan konfirmasi *"Apakah Anda yakin ingin keluar dari akun?"* saat menekan tombol Keluar di Drawer.
- [x] **Formatting Tanggal Lahir Otomatis (*Input Masking*)**
  - [x] Menambahkan pemisah otomatis saat mengetik tanggal lahir (menjadi format `DD/MM/YYYY` atau `DD-MM-YYYY`).

---

### 🏥 Prioritas 2: Alur Transaksi & Operasional Klinik (Core Operation) - SELESAI ✅
- [x] **Modul Pendaftaran Berobat / Antrean Pasien**
  - [x] Membuat Model `Pendaftaran` / `Antrean` (`id`, `nomorAntrean`, `tanggal`, `namaPasien`, `nomorRm`, `namaPoli`, `namaDokter`, `keluhan`, `status`, `catatanDokter`).
  - [x] Halaman **Pendaftaran Pasien Berobat** (Dropdown pilih Pasien $\rightarrow$ Dropdown pilih Poli $\rightarrow$ Dropdown pilih Dokter $\rightarrow$ Input Keluhan).
  - [x] Generator otomatis Nomor Antrean (e.g. `A-001`, `B-001`, `U-001` sesuai prefiks inisial Poli).
- [x] **Halaman Manajemen Antrean & Status Periksa**
  - [x] Tab status: *Semua*, *Menunggu*, *Sedang Diperiksa*, dan *Selesai*.
  - [x] Aksi dokter/perawat untuk memperbarui status antrean pasien (*Panggil/Mulai Periksa*, *Selesai & Catatan Resep*, *Batalkan Antrean*).
  - [x] Pratinjau Karcis Antrean digital (*Ticket Modal*) langsung setelah pendaftaran dan tombol cetak bukti di kartu antrean.
- [x] **Menu Tambahan di Sidebar Drawer & Beranda**
  - [x] Menambahkan item menu **"Antrean & Pendaftaran"** di Sidebar Drawer.
  - [x] Banner status antrean live dan tombol cepat pendaftaran di Beranda Dashboard.

---

### 💾 Prioritas 3: Penyimpanan Data Permanen (Local Persistence) - SELESAI ✅
- [x] **Integrasi Local Storage / Shared Preferences**
  - [x] Menggunakan `shared_preferences` dengan JSON serializer sehingga data Poli, Pegawai, Pasien, Antrean, dan Kode Admin tetap tersimpan meskipun aplikasi di-restart atau ditutup.
- [x] **Fitur Cadangan / Reset Data Bawaan**
  - [x] Tombol *"Reset Data Bawaan"* di Drawer Sidebar dengan konfirmasi dialog untuk mempermudah saat demo/pengujian aplikasi.

---

### 📊 Prioritas 4: Rekam Medis & Laporan Singkat - SELESAI ✅
- [x] **Catatan Rekam Medis Pasien**
  - [x] Menyimpan riwayat diagnosis dokter dan resep obat yang diterima pasien pada saat kunjungan.
  - [x] Riwayat pemeriksaan, kartu diagnosa/resep, dan status kunjungan tampil langsung di halaman **Detail Pasien**.
- [x] **Cetak / Pratinjau Karcis Antrean**
  - [x] Dialog modal bukti pendaftaran antrean berobat (nomor antrean, tanggal, poli, dokter) yang dapat dilihat dari formulir pendaftaran, kartu antrean, maupun riwayat detail pasien.

---

> 💡 **Catatan Kerja:**
> Checklist ini dapat di-checklist `[x]` secara bertahap sesuai modul yang ingin kita kerjakan berikutnya.
