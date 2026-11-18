# MyPortfolio Mobile

Aplikasi Flutter untuk portofolio Nashri Khalid (2506657131, PBP F). Di halaman utama, tiga kartu menampilkan identitas pemilik. Tombol Lihat Proyek, Tambah Proyek, dan Logout menampilkan konfirmasi sesuai aksi yang dipilih. Tambah Proyek juga membuka formulir proyek; drawer menyediakan navigasi Home dan Add Project.

## Menjalankan proyek

Pasang Flutter SDK dan Chrome, lalu jalankan perintah berikut dari folder yang berisi `pubspec.yaml`:

```sh
flutter pub get
flutter run -d chrome
```

Gunakan `flutter analyze` untuk memeriksa kode dan `flutter test` untuk menguji profil, respons tombol, navigasi drawer, validasi, isi dialog, dan reset formulir.

## Progres

Tutorial 08 memisahkan konfigurasi aplikasi di `lib/main.dart` dari halaman menu di `lib/menu.dart`. Tugas 7 mengganti profil Burhan dengan identitas pemilik, memberi warna tersendiri pada setiap aksi, dan menguji pesan yang muncul ketika tombol ditekan.

### Tutorial 09

- Halaman berada di `lib/screens/`, sedangkan drawer dan kartu aksi berada di `lib/widgets/`.
- Tombol Tambah Proyek memakai `Navigator.push`; drawer memakai `Navigator.pushReplacement` setelah ditutup.
- Form berisi nama, deskripsi, kategori, teknologi, dan tautan proyek. Nama dan deskripsi wajib diisi dan tidak boleh hanya spasi.
- Save menampilkan seluruh isian dalam dialog. OK menutup dialog dan mereset semua isian, termasuk kategori ke Web Development. Data belum disimpan ke database.
- Impor Material menggunakan paket `material_ui` sesuai tutorial.

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

## Penggunaan AI

Prompt tugas: Codex membaca PDF tugas dan kode Tutorial 08 serta membantu menjalankan pemeriksaan Flutter. 
