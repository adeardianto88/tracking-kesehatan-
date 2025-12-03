-- ============================================
-- Robotic Auth Database - CLEAN INSTALL
-- Hapus database lama dan buat ulang dari awal
-- ============================================

-- Drop database jika sudah ada (HATI-HATI: ini akan menghapus semua data!)
DROP DATABASE IF EXISTS db_auth_robotic;

-- Create database baru
CREATE DATABASE db_auth_robotic CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_auth_robotic;

-- ============================================
-- TABEL UTAMA
-- ============================================

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB;

-- ============================================
-- TABEL HEALTH TRACKING
-- ============================================

-- Table: weight_records
CREATE TABLE IF NOT EXISTS weight_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    weight DECIMAL(5,2) NOT NULL,
    height INT NOT NULL,
    bmi DECIMAL(4,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_recorded_at (recorded_at)
) ENGINE=InnoDB;

-- Table: water_records
CREATE TABLE IF NOT EXISTS water_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    amount_ml INT NOT NULL,
    recorded_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_recorded_at (recorded_at)
) ENGINE=InnoDB;

-- Table: blood_pressure_records
CREATE TABLE IF NOT EXISTS blood_pressure_records (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    systolic INT NOT NULL,
    diastolic INT NOT NULL,
    pulse INT,
    measurement_date TIMESTAMP NOT NULL,
    notes TEXT,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_measurement_date (measurement_date)
) ENGINE=InnoDB;

-- Table: food_logs
CREATE TABLE IF NOT EXISTS food_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    food_name VARCHAR(255) NOT NULL,
    calories INT NOT NULL,
    protein DECIMAL(5,2) DEFAULT 0,
    carbs DECIMAL(5,2) DEFAULT 0,
    fat DECIMAL(5,2) DEFAULT 0,
    meal_type VARCHAR(50) NOT NULL,
    logged_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_meal_type (meal_type),
    INDEX idx_logged_at (logged_at)
) ENGINE=InnoDB;

-- ============================================
-- TABEL GAMIFICATION
-- ============================================

-- Table: avatar_stages
CREATE TABLE IF NOT EXISTS avatar_stages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    required_level INT NOT NULL,
    required_strength INT DEFAULT 0,
    required_agility INT DEFAULT 0,
    required_endurance INT DEFAULT 0,
    required_focus INT DEFAULT 0,
    required_vitality INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_required_level (required_level),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- Table: user_stats
CREATE TABLE IF NOT EXISTS user_stats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    xp INT DEFAULT 0,
    level INT DEFAULT 1,
    strength INT DEFAULT 1,
    agility INT DEFAULT 1,
    endurance INT DEFAULT 1,
    focus INT DEFAULT 1,
    vitality INT DEFAULT 1,
    avatar_stage_id INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (avatar_stage_id) REFERENCES avatar_stages(id),
    INDEX idx_user_id (user_id),
    INDEX idx_level (level),
    INDEX idx_avatar_stage_id (avatar_stage_id)
) ENGINE=InnoDB;

-- Table: challenges
CREATE TABLE IF NOT EXISTS challenges (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    xp_reward INT NOT NULL,
    target_value INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_type (type),
    INDEX idx_category (category),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- Table: challenge_completions
CREATE TABLE IF NOT EXISTS challenge_completions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    challenge_id INT NOT NULL,
    completed_at TIMESTAMP NOT NULL,
    xp_earned INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (challenge_id) REFERENCES challenges(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_challenge_id (challenge_id),
    INDEX idx_completed_at (completed_at)
) ENGINE=InnoDB;

-- Table: rewards
CREATE TABLE IF NOT EXISTS rewards (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    cost INT NOT NULL,
    rarity VARCHAR(50) DEFAULT 'common',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_type (type),
    INDEX idx_rarity (rarity),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB;

-- Table: user_rewards
CREATE TABLE IF NOT EXISTS user_rewards (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    reward_id INT NOT NULL,
    quantity INT DEFAULT 1,
    purchased_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reward_id) REFERENCES rewards(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_reward_id (reward_id),
    INDEX idx_purchased_at (purchased_at)
) ENGINE=InnoDB;

-- ============================================
-- DATA AWAL (SEED DATA)
-- ============================================

-- Insert default avatar stages (Bahasa Indonesia)
INSERT INTO avatar_stages (name, description, required_level, required_strength, required_agility, required_endurance, required_focus, required_vitality) VALUES
('Robot Pemula', 'Avatar awal Anda', 1, 0, 0, 0, 0, 0),
('Bot Magang', 'Naik level untuk membuka avatar ini', 5, 2, 2, 2, 2, 2),
('Mech Pejuang', 'Buktikan kekuatan Anda', 10, 5, 3, 5, 2, 3),
('Drone Ninja', 'Master kelincahan', 15, 3, 7, 3, 5, 2),
('Titan Ketahanan', 'Dibangun untuk ketahanan', 20, 4, 4, 8, 3, 5),
('Bijak Fokus', 'Pikiran di atas segalanya', 25, 3, 3, 3, 10, 4),
('Penjaga Vitalitas', 'Kondisi fisik puncak', 30, 5, 5, 5, 5, 10);

-- Insert default challenges (Bahasa Indonesia)
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

-- Insert default rewards (Bahasa Indonesia)
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

-- ============================================
-- PESAN SELESAI
-- ============================================

SELECT '✅ Database db_auth_robotic berhasil dibuat ulang!' as Status;
SELECT 'Total Tables: 13' as Info;
SELECT 'Seed Data: Avatar Stages (7), Challenges (10), Rewards (10)' as SeedData;
