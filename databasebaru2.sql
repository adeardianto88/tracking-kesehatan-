-- ============================================
-- UPDATE DATABASE - Bahasa Indonesia
-- File ini mengupdate data yang sudah ada tanpa menghapus database
-- ============================================

USE db_auth_robotic;

-- ============================================
-- UPDATE CHALLENGES KE BAHASA INDONESIA
-- ============================================

-- Hapus challenges lama
DELETE FROM challenge_completions;
DELETE FROM challenges;

-- Insert challenges baru dalam Bahasa Indonesia
INSERT INTO challenges (title, description, type, xp_reward, target_value, category) VALUES
('Target Air Harian', 'Minum 2000ml air hari ini', 'daily', 50, 2000, 'water'),
('Sarapan Sehat', 'Catat makanan sarapan yang sehat', 'daily', 30, 1, 'diet'),
('Makan Siang Seimbang', 'Catat makanan makan siang yang seimbang', 'daily', 30, 1, 'diet'),
('Makan Malam Ringan', 'Catat makanan makan malam yang ringan', 'daily', 30, 1, 'diet'),
('Olahraga Mingguan', 'Selesaikan 3 sesi olahraga minggu ini', 'weekly', 150, 3, 'exercise'),
('Kontrol Kalori', 'Tetap dalam target kalori harian selama 5 hari', 'weekly', 200, 5, 'diet'),
('Pelacak Berat Badan', 'Catat berat badan Anda 7 hari berturut-turut', 'weekly', 100, 7, 'weight'),
('Cek Tekanan Darah', 'Pantau tekanan darah 5 kali minggu ini', 'weekly', 120, 5, 'health'),
('Master Hidrasi', 'Capai target air harian selama 7 hari berturut-turut', 'weekly', 250, 7, 'water'),
('Ahli Nutrisi', 'Catat semua makanan selama 5 hari', 'weekly', 180, 5, 'diet');

SELECT 'Challenges updated to Bahasa Indonesia!' as Status;

-- ============================================
-- UPDATE REWARDS KE BAHASA INDONESIA
-- ============================================

-- Hapus user rewards lama (optional - uncomment jika ingin reset)
-- DELETE FROM user_rewards;

-- Hapus rewards lama
DELETE FROM rewards;

-- Insert rewards baru dalam Bahasa Indonesia
INSERT INTO rewards (name, description, type, cost, rarity) VALUES
('Ramuan Penguat XP', 'Gandakan perolehan XP selama 24 jam', 'potion', 100, 'rare'),
('Kulit Emas', 'Kulit avatar emas berkilau', 'skin', 500, 'epic'),
('Kotak Misteri', 'Berisi hadiah acak', 'loot_box', 200, 'common'),
('Penguat Kekuatan', 'Meningkatkan kekuatan secara permanen sebesar 1', 'item', 300, 'rare'),
('Minuman Energi', 'Mengembalikan energi untuk tantangan', 'item', 50, 'common'),
('Armor Perak', 'Kulit armor perak pelindung', 'skin', 350, 'rare'),
('Mahkota Berlian', 'Aksesori mahkota berlian legendaris', 'accessory', 800, 'legendary'),
('Ramuan Kesehatan', 'Selesaikan tantangan kesehatan secara instan', 'potion', 150, 'uncommon'),
('Pengali XP x3', 'Tiga kali lipat XP selama 12 jam', 'potion', 250, 'epic'),
('Lencana Perunggu', 'Lencana pencapaian perunggu', 'badge', 50, 'common');

SELECT 'Rewards updated to Bahasa Indonesia!' as Status;

-- ============================================
-- UPDATE AVATAR STAGES KE BAHASA INDONESIA
-- ============================================

-- Update avatar stages yang sudah ada
UPDATE avatar_stages SET 
    name = 'Robot Pemula',
    description = 'Avatar awal Anda'
WHERE required_level = 1;

UPDATE avatar_stages SET 
    name = 'Bot Magang',
    description = 'Naik level untuk membuka avatar ini'
WHERE required_level = 5;

UPDATE avatar_stages SET 
    name = 'Mech Pejuang',
    description = 'Buktikan kekuatan Anda'
WHERE required_level = 10;

UPDATE avatar_stages SET 
    name = 'Drone Ninja',
    description = 'Master kelincahan'
WHERE required_level = 15;

UPDATE avatar_stages SET 
    name = 'Titan Ketahanan',
    description = 'Dibangun untuk ketahanan'
WHERE required_level = 20;

UPDATE avatar_stages SET 
    name = 'Bijak Fokus',
    description = 'Pikiran di atas segalanya'
WHERE required_level = 25;

UPDATE avatar_stages SET 
    name = 'Penjaga Vitalitas',
    description = 'Kondisi fisik puncak'
WHERE required_level = 30;

SELECT 'Avatar Stages updated to Bahasa Indonesia!' as Status;

-- ============================================
-- VERIFIKASI UPDATE
-- ============================================

SELECT '====== CHALLENGES ======' as '';
SELECT id, title, description, type, xp_reward FROM challenges ORDER BY id LIMIT 5;

SELECT '====== REWARDS ======' as '';
SELECT id, name, description, type, cost, rarity FROM rewards ORDER BY id LIMIT 5;

SELECT '====== AVATAR STAGES ======' as '';
SELECT id, name, description, required_level FROM avatar_stages ORDER BY required_level;

-- ============================================
-- PESAN SELESAI
-- ============================================

SELECT '✅ Database berhasil diupdate ke Bahasa Indonesia!' as Status;
SELECT 'Total Challenges: 10' as Info;
SELECT 'Total Rewards: 10' as Info;
SELECT 'Total Avatar Stages: 7' as Info;
SELECT 'Semua data sudah dalam Bahasa Indonesia!' as Info;
