# MyPortfolio Mobile

Aplikasi Flutter untuk portofolio Nashri Khalid (2506657131, PBP F). Di halaman utama, tiga kartu menampilkan identitas pemilik. Tombol Lihat Proyek, Tambah Proyek, dan Logout menampilkan konfirmasi sesuai aksi yang dipilih. Tambah Proyek juga membuka formulir proyek; drawer menyediakan navigasi Home, Add Project, dan Tambah Pengalaman. Kartu Tambah Pengalaman membuka formulir yang mengikuti model Experience pada proyek Django.

## Menjalankan proyek

Pasang Flutter SDK dan Chrome, lalu jalankan perintah berikut dari folder yang berisi `pubspec.yaml`:

```sh
flutter pub get
flutter run -d chrome
```

Gunakan `flutter analyze` untuk memeriksa kode dan `flutter test` untuk menguji profil, respons tombol, navigasi drawer, validasi, isi dialog, dan reset formulir.


### Tugas 7

1. **Apa itu widget tree?** Widget tree adalah susunan hierarkis widget yang mendeskripsikan tampilan. Induk menyusun anak lewat properti seperti `child`, `children`, atau `body`. Di halaman ini, `Scaffold.body` berisi `SingleChildScrollView`, yang membungkus `Column`. Di dalam kolom itu, `Row` menata tiga kartu identitas. Dalam proses layout, induk memberi batas ukuran kepada anak, anak memilih ukuran dalam batas tersebut, lalu induk menentukan posisinya.

2. **Widget apa saja yang digunakan?**

   | Widget | Fungsi dalam proyek |
   | --- | --- |
   | `MyApp`, `MaterialApp` | MyApp membangun aplikasi. MaterialApp menerapkan tema dan membuka halaman utama. |
   | `MyHomePage`, `Scaffold`, `AppBar` | MyHomePage menyusun halaman profil. Scaffold menyediakan area isi dan AppBar menampilkan judul. |
   | `SingleChildScrollView`, `Column`, `Row`, `Expanded` | Halaman bisa digulir saat ruang terbatas. Column menyusun isi vertikal, Row menjajarkan kartu profil, dan Expanded membagi lebar baris secara merata. |
   | `InfoCard`, `Card`, `Padding` | InfoCard memasangkan label dengan nilai. Card memberi permukaan dan bayangan, sedangkan Padding memberi ruang di dalam kartu. |
   | `Text`, `SizedBox` | Text menampilkan judul, identitas, dan label tombol. SizedBox memberi jarak antarelemen. |
   | `GridView.count`, `ItemCard` | GridView menyusun tiga kolom. Setiap ItemCard membangun satu tombol berdasarkan nama, ikon, dan warna dari model ItemHomepage. |
   | `Material`, `InkWell`, `Icon` | Material memberi permukaan berwarna, InkWell menangani ketukan dan efek sentuh, dan Icon memberi simbol aksi. |
   | `ScaffoldMessenger`, `SnackBar` | Saat tombol ditekan, halaman mengambil ScaffoldMessenger lewat context untuk menutup pesan lama dan menampilkan SnackBar yang menyebut tombol tersebut. |

3. **Mengapa memakai MaterialApp di akar aplikasi?** Di proyek ini, runApp menerima MyApp, lalu MyApp membangun MaterialApp. Dengan menempatkannya di atas halaman, kita cukup mengatur tema indigo dan halaman awal sekali. Widget di bawahnya bisa mengambil tema yang sama, menggunakan navigasi, dan mengakses ScaffoldMessenger tanpa menyiapkan layanan itu di setiap kartu.

4. **Kapan memakai StatelessWidget atau StatefulWidget?** StatelessWidget membangun tampilan dari konfigurasi dan konteksnya. Ia tetap bisa dibangun ulang, misalnya saat tema berubah. MyHomePage cocok memakai StatelessWidget karena identitas dan daftar tombol tetap. Menekan tombol cukup meminta ScaffoldMessenger menampilkan pesan. StatefulWidget cocok jika halaman perlu menyimpan perubahan lokal antar-build, misalnya filter proyek yang dipilih pengguna. Nilai filter disimpan di objek State, lalu setState memberi tahu Flutter untuk membangun ulang tampilan.

5. **Apa peran BuildContext?** BuildContext menunjukkan posisi widget dalam tree. Parameter context di build memungkinkan widget mencari layanan milik leluhurnya. Misalnya, MyHomePage memakai Theme.of(context) untuk warna AppBar dan ItemCard memakai ScaffoldMessenger.of(context) ketika diketuk. Posisi pencarian penting karena Flutter mencari leluhur dari lokasi context tersebut.

6. **Bagaimana memilih hot reload, hot restart, atau full restart?** Saat mengganti warna kartu di mode debug, hot reload memuat kode Dart yang berubah dan membangun ulang tampilan sambil mempertahankan state. main dan initState tidak dijalankan ulang. Kalau perubahan perlu mengulang inisialisasi, misalnya mengubah nilai yang dipasang di initState, gunakan hot restart. Aplikasi Dart dimulai lagi dan state lokal hilang. Jika yang berubah adalah kode native atau konfigurasi build Android, hentikan aplikasi lalu jalankan kembali agar bagian native dikompilasi ulang.

### Tugas 8

1. **Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.** 
Jawab: `Navigator.push()` menambahkan halaman baru di atas stack, `pushReplacement()` mengganti halaman teratas, sedangkan `pop()` menghapus halaman teratas. Kartu Tambah Pengalaman memakai `push()` untuk membuka `ExperienceFormPage`, sehingga halaman utama tetap berada di bawahnya dan dapat ditampilkan lagi lewat tombol kembali perangkat. Di drawer, opsi Home menutup drawer dengan `pop()`, lalu memakai `pushReplacement()` untuk mengganti halaman saat ini dengan `MyHomePage`. Alur Home ini juga bisa dipakai di Chrome. `pushReplacement()` hanya mengganti route teratas, bukan menghapus seluruh riwayat navigasi.

2. **Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama.** 
Jawab: `Scaffold` menyediakan susunan halaman, `AppBar` memberi judul, dan `LeftDrawer` yang sama menyediakan pilihan navigasi pada halaman utama, form proyek, dan form pengalaman. Halaman utama dan form pengalaman sama-sama mengambil warna AppBar dari `Theme.of(context).colorScheme.primary`. Form pengalaman memakai `onPrimary` untuk warna teks agar sesuai dengan pasangan warna tema. Dengan begitu, halaman baru tetap terasa sebagai bagian dari aplikasi portofolio yang sama.

3. **Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.** 
Jawab: Input disusun vertikal menggunakan `Column` agar urutannya mudah diikuti, mulai dari jabatan sampai tanggal pengalaman. `SizedBox` memisahkan kolom supaya label, pesan kesalahan, dan tombol tidak berhimpitan. `Padding` memberi ruang di tepi layar, sedangkan `SingleChildScrollView` memungkinkan input dan tombol Simpan dijangkau saat layar pendek atau papan ketik terbuka. `SafeArea` menjaga isi dari area sistem perangkat. Kartu menu memakai dua kolom pada layar di bawah 600 piksel, dan ringkasan dialog dapat digulir ketika isinya panjang.

4. **Apa peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.**
Jawab: `GlobalKey<FormState>` memberi akses ke state form. Setiap `validator` mengembalikan pesan kesalahan atau `null` jika input valid. Tombol Simpan memanggil `_formKey.currentState!.validate()` dan hanya membuka dialog bila semua input lolos. Misalnya, jabatan berisi spasi ditolak setelah `trim()`, jabatan atau organisasi sepanjang 256 karakter ditolak karena model membatasi 255 karakter, dan tanggal selesai sebelum tanggal mulai juga ditolak. Pemilih tanggal hanya membantu memilih tanggal yang sah; pengguna masih bisa memilih tanggal selesai yang lebih awal. Begitu juga jenis papan ketik tidak menjamin teks wajib sudah diisi atau panjangnya sesuai model. Karena itu, aturan tetap diperiksa oleh validator.

## Penggunaan AI
Codex digunakan untuk membantu saya memahami pembuatan formulir Pengalaman, validasi, navigasi, pengujian, dan dokumentasi berdasarkan PDF tugas serta tutorial 9. 