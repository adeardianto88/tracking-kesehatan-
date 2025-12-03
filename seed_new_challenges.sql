-- Challenge Baru dengan Kategori yang Bermanfaat
-- Menambah kolom category jika belum ada
ALTER TABLE challenges 
ADD COLUMN IF NOT EXISTS subcategory VARCHAR(50) DEFAULT 'general',
ADD COLUMN IF NOT EXISTS difficulty VARCHAR(20) DEFAULT 'easy';

-- Insert challenge baru dengan berbagai kategori

-- KATEGORI OLAHRAGA & KEBUGARAN
INSERT INTO challenges (title, description, type, xp_reward, target_value, category, subcategory, difficulty) VALUES

-- Daily Olahraga
('Jalan Kaki 30 Menit', 'Berjalan kaki minimal 30 menit hari ini', 'daily', 40, 30, 'olahraga', 'cardio', 'easy'),
('Push Up 20 Kali', 'Lakukan 20 push up dalam sehari', 'daily', 35, 20, 'olahraga', 'strength', 'medium'),
('Peregangan Pagi', 'Lakukan peregangan selama 10 menit setelah bangun', 'daily', 25, 10, 'olahraga', 'flexibility', 'easy'),
('Naik Turun Tangga', 'Naik turun tangga 5 kali tanpa lift', 'daily', 30, 5, 'olahraga', 'cardio', 'easy'),

-- Weekly Olahraga
('Olahraga 3x Seminggu', 'Berolahraga minimal 3 kali dalam seminggu', 'weekly', 150, 3, 'olahraga', 'general', 'medium'),
('Jogging 5km', 'Berlari total 5km dalam seminggu', 'weekly', 200, 5, 'olahraga', 'cardio', 'hard'),

-- KATEGORI RUMAH & KEBERSIHAN
('Bersihkan Kamar', 'Rapikan dan bersihkan kamar tidur', 'daily', 30, 1, 'rumah', 'kebersihan', 'easy'),
('Cuci Piring Setelah Makan', 'Langsung cuci piring setelah selesai makan', 'daily', 20, 3, 'rumah', 'kebersihan', 'easy'),
('Buat Tempat Tidur', 'Rapikan tempat tidur setelah bangun', 'daily', 15, 1, 'rumah', 'kerapian', 'easy'),
('Bersihkan Meja Belajar', 'Rapikan dan bersihkan meja belajar/kerja', 'daily', 25, 1, 'rumah', 'kerapian', 'easy'),
('Sapu Lantai', 'Sapu lantai rumah atau kamar', 'daily', 35, 1, 'rumah', 'kebersihan', 'easy'),

-- Weekly Rumah
('Bersih-Bersih Mingguan', 'Lakukan bersih-bersih besar rumah', 'weekly', 100, 1, 'rumah', 'kebersihan', 'medium'),
('Cuci Baju Seminggu', 'Cuci dan jemur baju minimal 2x seminggu', 'weekly', 80, 2, 'rumah', 'kebersihan', 'easy'),

-- KATEGORI SEKOLAH/KAMPUS
('Baca Materi 1 Jam', 'Baca materi pelajaran/kuliah selama 1 jam', 'daily', 50, 60, 'pendidikan', 'belajar', 'medium'),
('Kerjakan PR/Tugas', 'Selesaikan 1 PR atau tugas hari ini', 'daily', 60, 1, 'pendidikan', 'tugas', 'medium'),
('Buat Catatan Pelajaran', 'Buat rangkuman catatan dari 1 mata pelajaran', 'daily', 40, 1, 'pendidikan', 'catatan', 'medium'),
('Datang Tepat Waktu', 'Datang ke sekolah/kampus tepat waktu', 'daily', 30, 1, 'pendidikan', 'disiplin', 'easy'),
('Diskusi Kelompok', 'Ikut diskusi atau tanya jawab di kelas', 'daily', 35, 1, 'pendidikan', 'partisipasi', 'medium'),

-- Weekly Pendidikan
('Selesaikan Proyek', 'Kerjakan dan selesaikan 1 proyek/tugas besar', 'weekly', 200, 1, 'pendidikan', 'proyek', 'hard'),
('Review Materi Minggu Ini', 'Review semua materi yang dipelajari minggu ini', 'weekly', 120, 1, 'pendidikan', 'review', 'medium'),
('Kunjungi Perpustakaan', 'Pergi ke perpustakaan minimal 2x seminggu', 'weekly', 80, 2, 'pendidikan', 'riset', 'easy'),

-- KATEGORI IBADAH & SPIRITUAL
('Sholat 5 Waktu', 'Laksanakan sholat 5 waktu tepat waktu', 'daily', 70, 5, 'ibadah', 'sholat', 'easy'),
('Baca Al-Quran', 'Baca Al-Quran minimal 1 halaman', 'daily', 50, 1, 'ibadah', 'tilawah', 'easy'),
('Dzikir Pagi Petang', 'Lakukan dzikir pagi dan petang', 'daily', 40, 2, 'ibadah', 'dzikir', 'easy'),
('Doa Sebelum Aktivitas', 'Berdoa sebelum memulai aktivitas penting', 'daily', 25, 3, 'ibadah', 'doa', 'easy'),
('Sedekah Harian', 'Berikan sedekah sekecil apapun hari ini', 'daily', 60, 1, 'ibadah', 'sedekah', 'easy'),

-- Weekly Ibadah
('Sholat Sunnah Dhuha', 'Lakukan sholat Dhuha minimal 3x seminggu', 'weekly', 100, 3, 'ibadah', 'sunnah', 'medium'),
('Tadarus Mingguan', 'Ikut tadarus atau kajian agama', 'weekly', 120, 1, 'ibadah', 'kajian', 'easy'),
('Bantu Orang Lain', 'Membantu orang lain tanpa mengharap imbalan', 'weekly', 150, 1, 'ibadah', 'sosial', 'medium'),

-- KATEGORI SOSIAL & KELUARGA
('Hubungi Orang Tua', 'Telepon atau chat orang tua jika tinggal terpisah', 'daily', 35, 1, 'sosial', 'keluarga', 'easy'),
('Bantu Pekerjaan Rumah', 'Bantu orang tua mengerjakan pekerjaan rumah', 'daily', 40, 1, 'sosial', 'keluarga', 'easy'),
('Ucapkan Terima Kasih', 'Ucapkan terima kasih kepada minimal 3 orang', 'daily', 25, 3, 'sosial', 'sopan_santun', 'easy'),
('Senyum dan Sapa', 'Senyum dan sapa tetangga/teman yang bertemu', 'daily', 20, 5, 'sosial', 'ramah', 'easy'),

-- Weekly Sosial
('Silaturahmi Keluarga', 'Kunjungi atau hubungi keluarga besar', 'weekly', 100, 1, 'sosial', 'keluarga', 'medium'),
('Kegiatan Sosial', 'Ikut kegiatan sosial atau gotong royong', 'weekly', 150, 1, 'sosial', 'komunitas', 'medium'),

-- KATEGORI KESEHATAN MENTAL
('Meditasi 10 Menit', 'Lakukan meditasi atau relaksasi 10 menit', 'daily', 45, 10, 'mental', 'relaksasi', 'easy'),
('Tulis Jurnal Harian', 'Tulis perasaan atau kegiatan hari ini', 'daily', 35, 1, 'mental', 'refleksi', 'easy'),
('Dengar Musik Favorit', 'Dengarkan musik yang membuat bahagia', 'daily', 20, 1, 'mental', 'hiburan', 'easy'),
('Hindari Gadget 1 Jam', 'Tidak menggunakan gadget selama 1 jam', 'daily', 40, 1, 'mental', 'digital_detox', 'medium'),

-- Weekly Mental
('Me Time Weekend', 'Luangkan waktu untuk diri sendiri di weekend', 'weekly', 80, 1, 'mental', 'self_care', 'easy'),
('Baca Buku Non-Pelajaran', 'Baca buku untuk hobi atau pengembangan diri', 'weekly', 100, 1, 'mental', 'pengembangan', 'medium'),

-- KATEGORI LINGKUNGAN
('Buang Sampah pada Tempatnya', 'Selalu buang sampah pada tempatnya', 'daily', 15, 5, 'lingkungan', 'kebersihan', 'easy'),
('Hemat Listrik', 'Matikan lampu yang tidak digunakan', 'daily', 20, 3, 'lingkungan', 'hemat_energi', 'easy'),
('Hemat Air', 'Tidak boros air saat mandi atau cuci', 'daily', 25, 1, 'lingkungan', 'hemat_air', 'easy'),
('Kurangi Plastik', 'Gunakan tas belanja sendiri atau hindari plastik', 'daily', 30, 1, 'lingkungan', 'ramah_lingkungan', 'medium'),

-- Weekly Lingkungan
('Bersihkan Lingkungan', 'Ikut bersih-bersih lingkungan atau tanam pohon', 'weekly', 150, 1, 'lingkungan', 'aksi_nyata', 'medium');

-- Update status aktif untuk semua challenge baru
UPDATE challenges SET is_active = 1 WHERE is_active IS NULL;

SELECT 'Challenge baru berhasil ditambahkan!' as status;
SELECT COUNT(*) as total_challenges FROM challenges WHERE is_active = 1;